# DAB — Code Conventions

> **Linear source:** [Code Conventions](https://linear.app/dev-activity-board/document/code-conventions-d237039dad44) · Last synced: 2026-04-08  
> Applies to **both** `dab_api/` and `dab_app/`. Package-specific additions are noted where applicable.

---

## General Principles

- **Conciseness over Redundancy:** If the folder name provides context, don't repeat it in the file or class name.  
  `lib/domain/entities/user.dart` → class `User`, not `UserEntity`.
- **Modern Dart:** Use Dart 3 features — `sealed` classes, `switch` expressions, `abstract interface` classes, pattern matching.
- **One public concern per file.** Never combine unrelated entities, use cases, or controllers.
- **Backend First, Frontend Second:** Frontend code is only written *after* the API and Domain contracts are locked.

---

## Workflow Sequence (per feature)

1. **Define Domain contracts** — `IRepository` interfaces + Entities.
2. **Implement API endpoints** — complete `dab_api` before starting client work.
3. **Implement Infrastructure (client)** — concrete repositories once API is stable.
4. **Build UI** — Blocs and Views only after the data flow is verified.

---

## Naming Conventions

### Dart / File Names

| Artifact | Class Name | File Name | Location |
|---|---|---|---|
| Entity | `User` | `user.dart` | `lib/domain/entities/` |
| Failure | `AppFailure` (sealed) | `failures.dart` | `lib/domain/core/` |
| Repository Interface | `IAuthRepository` | `abs_i_auth_repository.dart` | `lib/domain/repositories/` |
| Repository Base (abstract) | `IRepository` | `abs_i_repository.dart` | `lib/domain/repositories/core/` |
| Repository Impl | `AuthRepository` | `auth_repository.dart` | `lib/infrastructure/repositories/` |
| Use Case | `Login` | `login.dart` | `lib/domain/usecases/[feature]/` |
| Use Case Container | `AuthUseCases` | `auth_usecases.dart` | `lib/domain/containers/` |
| Cubit | `AuthCubit` | `auth_cubit.dart` | `[view]/` or `features/[feature]/` |
| Cubit State | `AuthState` | `auth_state.dart` | Same folder — always isolated file |
| View | `AuthView` | `auth_view.dart` | `lib/presentation/views/auth/` |
| Layout | `AuthViewMobile` | `auth_view_mobile.dart` | `lib/presentation/views/auth/layouts/` |
| Controller (API) | `AuthController` | `auth_controller.dart` | `lib/src/presentation/controllers/` |
| Service Locator | `ServiceLocator` | `service_locator.dart` | `lib/services/` (app) / root `lib/src/` (api) |

### Route Names

- **API endpoint paths:** `kebab-case` — e.g., `/auth/refresh-token`, `/metadata/configs`
- **App route names:** Defined as constants in `AppRoute` — never raw strings in widgets

---

## Tech Stack & Packages

### Shared (both packages)

| Concern | Package |
|---|---|
| Serialization | `dart_mappable` — `@MappableClass()`. Never `json_serializable`. |
| Functional errors | `fpdart` — `Either<Failure, T>`. Never throw as control flow. |
| Code generation | `build_runner` — run after every schema change |

### API (`dab_api/`)

| Concern | Package |
|---|---|
| HTTP framework | `relic` |
| Database ORM | `drift` + `drift_postgres` (+ `postgres` driver) |
| DI | `get_it` — resolved via `sl<T>()` |
| JWT | `dart_jsonwebtoken` |
| Password hashing | `bcrypt` |
| Cache | `redis` |
| Config loading | `dotenv` |
| External HTTP | `http` |

### App (`dab_app/`)

| Concern | Package |
|---|---|
| State management | `flutter_bloc` |
| Navigation | `go_router` |
| Networking | `dio` + `web_socket_channel` + `cached_network_image` |
| Local persistence | `objectbox` + `objectbox_flutter_libs` |
| Secure token storage | `flutter_secure_storage` |
| Formatting | `timeago` + `intl` |
| Charts / visual analytics | `fl_chart` |
| Typography / icons | `google_fonts` + `simple_icons` + `flutty_heroicons` |
| Testing | `mocktail` + `bloc_test` |

---

## Code Style Rules

### Comments & Docs

- All public APIs use `///` doc-comments (not `//`).
- Doc-comments explain **role, contract, and constraints** — not just what a field is.
- Classes are annotated with `[ARCH: LAYER_NAME]` to signal layer ownership.

### Data Classes

- Prefer `final` fields and immutable data classes everywhere.
- Use `sealed class` for exhaustive discriminated unions (`Failure`, `ActivityProvider`).
- Use `dart_mappable` — never write `toJson` / `fromJson` manually.

### Extensions

- **Naming:** `extension On[TargetName] on [TargetName]`
- **Style:** Use getters for transformations / utilities that don't require parameters.
- **Location:**
  - On domain entities → same file, below the class.
  - On external classes → `core/extensions/` in the relevant layer (e.g., `dio_extensions.dart`).

### Error Handling

- Repositories return `Either<AppFailure, T>` — never throw.
- Datasources catch protocol-specific exceptions (e.g., `DioException`) and map them to `AppFailure` subtypes.
- Cubits call use cases — they never catch raw exceptions.

---

## App-Specific Conventions

### Views

- **Mandatory structure:**
  ```
  [view_name]/
  ├── [name]_view.dart      ← BlocProvider + LayoutBuilder switcher
  ├── layouts/              ← device-specific layouts (mobile, desktop)
  │   ├── [name]_view_mobile.dart
  │   └── [name]_view_desktop.dart
  ├── [name]_cubit.dart     ← OR: [name]_bloc.dart + [name]_event.dart
  ├── [name]_state.dart     ← uses ViewStatus, always isolated file
  ├── models/               ← feature-local enums and data classes
  └── widgets/              ← extracted UI components, strictly one per file
  ```

- **One Widget Per File:** Strictly enforced. No private widgets (`_MyWidget`) or functions returning `Widget` in layout files.

- **Status Management:** Use the unified `ViewStatus` enum (`initial`, `loading`, `success`, `failure`) in all states.

- **Base classes:** Every Cubit must extend `AbsCubit`. Every Bloc must extend `AbsBloc`.

- **UI builders:** Always use `AppBlocBuilder`, `AppBlocListener`, or `AppBlocConsumer`.  
  Use `onInit` callback for one-time initialization — never trigger in `initState`.

### Networking

- `RestApiClient` — centralized Dio configuration in `lib/infrastructure/core/api/rest/`.
- Interceptors for auth injection, token refresh, Vegas sync, and logging.
- Every model must have `extension On[Model] on [Model]` with a `toDomain` getter, co-located in the model file.

### Navigation

- Route names + paths + view builders centralized in `AppRoute`.
- `AppRouter` encapsulates `GoRouter` config.
- Auth guards live in the router — not in widgets or cubits.

### Localization

- `.arb` files in `lib/presentation/core/localization/l10n/`.
- Current baseline locale file: `app_en.arb` (additional locales are additive as introduced).
- Auto-generated via `flutter gen-l10n` (configured in `l10n.yaml`).
- **Standard Pattern:** Use the `L10n` extension in `lib/presentation/core/localization/l10n_extension.dart` to access keys via `context.l10n.keyName`.

### UI Styling & Workflows

- **Centralized Tokens:** All UI constants (Colors, Spacing, Icons, etc.) MUST be fetched from `lib/presentation/core/styles/`.
- **Material 3:** Adhere strictly to M3 color roles (Primary, Surface, OnSurface, etc.).
- **Scaffolding:** Use the `/sc-view` workflow for creating new view screens to ensure correct folder hierarchy and boilerplate.

---

## API-Specific Conventions

### Controllers

```dart
// Pattern: parse → call one use case → map result
router.get('/activities', (request) async {
  final result = await sl<ActivityUseCases>().getRecentActivities.execute();
  return result.fold(
    (failure) => Response.internalServerError(...),
    (data) => Response.ok(jsonEncode({ 'data': data, 'meta': {...} })),
  );
});
```

- Controllers are **thin** — one use case call per handler.
- Map `Left<Failure>` to HTTP status codes in the controller, not in use cases.

### Database

- Column naming: `snake_case`.
- Table naming: plural `snake_case` (e.g., `provider_configs`, `user_identities`).
- Table timestamps follow each table contract; `created_at` is standard on activity rows, and additional timestamp columns are added only when needed by behavior.
- Drift migrations are required for any schema change — never alter the DB manually.

---

## Testing Conventions

| Rule | Detail |
|---|---|
| Test file mirrors source | `lib/src/application/usecases/auth/login.dart` → `test/application/usecases/auth/login_test.dart` |
| App mirror example | `lib/presentation/features/auth/auth_cubit.dart` → `test/presentation/features/auth/auth_cubit_test.dart` |
| Fixtures | Use `TestData` (Object Mother) factory — never inline entity construction |
| Mocking | `mocktail` at interface / repository boundaries only |
| Cubit testing | `bloc_test`'s `blocTest<MyCubit, MyState>(...)` — never call `emit()` manually |
| Integration tests | Tagged `@Tags(['integration'])` — excluded from CI unit runs |
| Determinism | No real network calls, no `DateTime.now()` without injection |
