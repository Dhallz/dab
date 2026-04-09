---
trigger: always_on
glob: "dab_app/**/*"
description: Package-specific rules for DAB App
---

# DAB App — Package-Specific Agent Rules

> These rules supplement (not replace) the global rules in `/.agents/rules/global.md`.  
> Always read the global rules first.

**Stack**: Flutter `^3.x` · Dart `^3.9.2` · flutter_bloc · go_router · ObjectBox · Dio · dart_mappable

---

## 🗂️ Package Layer Map

```
dab_app/lib/
├── domain/
│   ├── entities/      ← Pure Dart models (no Flutter/framework imports)
│   ├── repositories/  ← Abstract repository interfaces (I*)
│   ├── usecases/      ← Single-responsibility use case classes
│   ├── core/          ← Shared failures, value objects, core abstractions
│   └── containers/    ← Domain-level DI containers / registry
├── infrastructure/
│   ├── datasources/   ← Remote (Dio) and local (ObjectBox) data sources
│   ├── repositories/  ← Concrete implementations of domain interfaces
│   └── core/          ← Interceptors, ObjectBox setup, storage helpers
├── presentation/
│   ├── features/      ← Feature modules (auth/, app/, …)
│   │   └── <feature>/
│   │       ├── cubit/         ← BLoC/Cubit state management
│   │       ├── widgets/       ← Feature-specific widgets
│   │       └── screens/       ← Screen-level compositions
│   ├── core/          ← Shared widgets, theming, routing helpers
│   └── views/         ← Top-level view compositions (router root etc.)
├── services/
│   └── service_locator.dart  ← Single file for all DI registrations
└── main.dart
```

---

## 🧩 BLoC / Cubit Rules

- **One Cubit per feature screen or major UI concern.** Do not create "god cubits" that own multiple unrelated state slices.
- **Cubits call use cases only** — never datasources or repositories directly.
- State classes must be defined using `dart_mappable` (`@MappableClass`) or as `sealed` hierarchies (`Initial`, `Loading`, `Success`, `Failure`).
- Use `bloc_test` for all cubit tests — never manually `emit()` inside tests.
- Cubits are **stateless orchestrators**: they hold no application state themselves outside what is in the emitted `State` object.
- Prefer `CubitConsumer` / `BlocBuilder` scoped to the smallest widget that needs the state change.

---

## 🗺️ Navigation Rules (go_router)

- All routes are declared in a single router configuration file (e.g., `presentation/core/router.dart`).
- Use **named routes** — never push raw path strings from business logic or use cases.
- Route guards (redirect logic) live in the router configuration, not in widgets or cubits.
- Never import a screen file directly into another screen to perform navigation.

---

## 🗄️ Local Persistence Rules (ObjectBox)

- The `objectbox.g.dart` and `objectbox-model.json` files are **generated** — never hand-edit them.
- After any ObjectBox entity change run:  
  `dart run build_runner build --delete-conflicting-outputs`
- Entity classes live in `domain/entities/` but are annotated with `@Entity()` — keep the annotation minimal (IDs only in the domain model where possible).
- All ObjectBox I/O is isolated inside `infrastructure/datasources/` — the domain never touches `Store` or `Box` directly.

---

## 🌐 Networking Rules (Dio)

- The Dio client is configured exclusively in `infrastructure/core/` (interceptors, base URL, timeouts).
- Auth token injection and refresh live in a dedicated `AuthInterceptor` — never inline token logic in datasources.
- All API calls return `Either<Failure, T>` — catch `DioException` in the datasource layer and map to a domain `Failure`.
- Never add `.catchError` or raw try-catch inside cubits. Error handling belongs in the datasource or repository.

---

## 🔐 Auth & Token Rules (App-Specific)

- `FlutterSecureStorage` is the only acceptable storage for tokens. Never store tokens in `SharedPreferences`, `ObjectBox`, or in-memory singletons.
- Token refresh is handled entirely by `AuthInterceptor` — cubits must not trigger refresh manually.
- On logout, clear both the in-memory cubit state **and** secure storage atomically.

---

## 🧪 Testing Rules (App-Specific)

- Test file mirrors source path: `lib/presentation/features/auth/cubit/auth_cubit.dart` → `test/presentation/features/auth/cubit/auth_cubit_test.dart`
- Use `bloc_test`'s `blocTest<MyCubit, MyState>(...)` for all cubit tests.
- Use `mocktail` to mock use-case interfaces — never a concrete use-case class.
- Use `TestData` factories for all entity fixtures.
- Widget tests live in `test/presentation/` and use `pumpWidget` with a minimal `MaterialApp` wrapper.
- Always run `flutter analyze && flutter test` before declaring a task complete.

---

## 🎨 UI / Widget Rules

- **No business logic in widgets.** Widgets read state from cubits and dispatch events — nothing more.
- Shared UI components belong in `presentation/core/widgets/` — never duplicate widget code across features.
- Use the app's `ThemeData` tokens (colours, text styles) — never hardcode hex values or font sizes inline.
- Animations use Flutter's built-in animation system (`AnimationController`, `AnimatedWidget`, `Hero`). Avoid third-party animation packages unless a gap is confirmed.
- Accessibility: every interactive widget must have a `Semantics` label or a `Tooltip`.

---

## 🤖 Agent Quick-Reference

| Action | Command |
|---|---|
| Analyze | `flutter analyze` |
| Run tests | `flutter test` |
| Run single test | `flutter test test/path/to/foo_test.dart` |
| Rebuild generated code | `dart run build_runner build --delete-conflicting-outputs` |
| Run app (dev) | `flutter run` |
| L10n generation | Handled automatically by `flutter gen-l10n` (configured in `l10n.yaml`) |
