---
trigger: always_on
glob: "**/*.dart"
description: Rules for functional error handling with fpdart and Either
---

# Functional Programming Rules (fpdart / Either)

These rules govern how errors and results are propagated across all layers. The project uses **fpdart** exclusively for functional error handling. Throwing exceptions as control flow is **strictly forbidden**.

---

## ✅ The Golden Rule: Return, Never Throw

Every fallible operation that crosses a layer boundary must return `Either<AppFailure, T>`, not throw.

```dart
// ✅ Correct
Future<Either<AppFailure, User>> login(...) async {
  try {
    final data = await _dataSource.login(...);
    return Right(data);
  } on DioException catch (e) {
    return Left(e.toAppFailure);
  } catch (e) {
    return Left(UnknownFailure(originalError: e));
  }
}

// ❌ Wrong — never throw across layer boundaries
Future<User> login(...) async {
  throw Exception('Login failed');
}
```

---

## 🗂️ AppFailure — The Sealed Error Hierarchy

All errors in the system are represented as subtypes of `AppFailure` (defined in `domain/core/failures.dart`).

| Subclass | When to Use |
|---|---|
| `ServerFailure` | HTTP 4xx / 5xx from the API. Include `statusCode` and `errorCode`. |
| `NetworkFailure` | No connectivity, timeout, or DNS failure. |
| `AuthFailure` | 401 / 403 — authentication or authorization error. |
| `ValidationFailure` | Client-side or server-side field validation errors. |
| `UnknownFailure` | Catch-all for unexpected exceptions. Always include `originalError`. |

**Never invent ad-hoc error strings** — always use a typed `AppFailure` subclass.

---

## 🛡️ The `guardedCall` Pattern (App Repositories)

Every concrete repository in `dab_app` extends the base `Repository` class and wraps calls with `guardedCall<T>`:

```dart
// ✅ Standard pattern for ALL repository methods
Future<Either<AppFailure, List<Activity>>> getActivities() {
  return guardedCall(() async {
    final response = await _dataSource.getActivities();
    return _parseList(response);
  });
}
```

`guardedCall` automatically catches `DioException` → `ServerFailure/NetworkFailure` and all other exceptions → `UnknownFailure`. **Do not replicate this try/catch logic manually** in individual repository methods.

---

## ⛓️ Folding Either Results in Presentaton

Cubits and BLoCs fold the `Either` result and emit the appropriate state. They **never rethrow** and never use `.getOrElse` blindly.

```dart
// ✅ Correct — fold in the cubit
final result = await _loginUseCase(...);
result.fold(
  (failure) => emit(state.copyWith(status: AuthStatus.failure, error: failure.message)),
  (user) => emit(state.copyWith(status: AuthStatus.success, user: user)),
);

// ❌ Wrong — never use .getOrElse in a cubit without handling the Left
final user = result.getOrElse((_) => throw 'error'); // forbidden
```

---

## 📐 Either in Use Cases

Use cases receive the result from the repository and return it as-is (or transform the `Right`). They **never introduce new `Left` values** without calling a repository or service — they are orchestrators, not error handlers.

```dart
// ✅ Correct — use case just passes through or transforms
Future<Either<AppFailure, List<Activity>>> call(...) async {
  return _repo.searchActivities(startDate: startDate, endDate: endDate);
}
```

---

## 🚫 What Not to Do

- **Never `throw`** as any form of control flow anywhere in the application.
- **Never use `try/catch` inside a Cubit or BLoC** — that belongs in the datasource or `guardedCall`.
- **Never return `null` to indicate failure** — use `Left<AppFailure>`.
- **Never use `.getOrElse` to swallow errors silently** without logging or informing the user.
- **Never create `AppFailure` subtypes outside `domain/core/failures.dart`** — extend the sealed class there.
