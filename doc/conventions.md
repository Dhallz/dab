# DAB — Code Conventions

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
4. **Build UI** — Riverpod notifiers and views only after the data flow is verified.

---

## Naming Conventions

### Dart / File Names

| Artifact | Class Name | File Name | Location |
|---|---|---|---|
| Entity | `User` | `user.dart` | `lib/domain/entities/` |
| Failure | `AppFailure` (sealed) | `failures.dart` | `lib/domain/core/` |
| Repository Interface | `IAuthRepository` | `abs_i_auth_repository.dart` | `lib/domain/repositories/` |
| Repository Base (abstract) | `IRepository` | `abs_i_repository.dart` | `lib/domain/repositories/core/` |
| Domain port (API) | `AbsIActivityPort` | `abs_i_activity_port.dart` | `dab_api/.../contracts/ports/` |
| Domain repository (API) | `AbsIAuthRepository` | `abs_i_auth_repository.dart` | `dab_api/.../contracts/repositories/` |
| Repository Impl | `AuthRepository` | `auth_repository.dart` | `lib/infrastructure/repositories/` |
| Use Case | `Login` | `login.dart` | `lib/domain/usecases/[feature]/` |
| Use Case Container | `AuthUseCases` | `auth_usecases.dart` | `lib/domain/containers/` |
| Notifier | `AuthNotifier` | `auth_notifier.dart` | `[view]/` or `features/[feature]/` |
| Feature state | `AuthState` | `auth_state.dart` | Same folder — always isolated file |
| View | `AuthView` | `auth_view.dart` | `lib/presentation/views/auth/` |
| Layout | `AuthViewMobile` | `auth_view_mobile.dart` | `lib/presentation/views/auth/layouts/` |
| Controller (API) | `AuthController` | `auth_controller.dart` | `lib/src/presentation/controllers/` |
| Service Locator | `ServiceLocator` | `service_locator.dart` | `lib/services/` (app) / root `lib/src/` (api) |

API `abstract interface` contracts under `domain/contracts/` use class prefix `AbsI` and file prefix `abs_i_` (ports and repositories). `IUserRepository` is the remaining `abstract class` exception.

### API provider I/O (`dab_api`)

Domain **ports** are interfaces under `domain/contracts/ports/`. **Source** is the infrastructure fetcher that implements a port — never the port itself.

Do **not** use `*Service` under `sources/` — that suffix is for application orchestration and infra core (`RedisService`, `PresenceService`).

| Suffix | Layer | Class / file | Meaning |
|---|---|---|---|
| **Port** | Domain `contracts/ports/` | `AbsIActivityPort` / `abs_i_activity_port.dart` | Interface for provider fetch or lookup (`AbsIDiscoveryPort`, `AbsIFigmaFileMetaPort`) |
| **Source** | Infra `sources/` only | `{Provider}{Resource}Source` / `*_source.dart` | Concrete provider fetcher (`GitHubCommitSource`, `FigmaFileSource`) |
| **Catalog** | Domain port + infra impl | `{Provider}{Resource}Catalog` / `*_catalog.dart` | Read-only pick list (`AbsI*Catalog`) |
| **Facade** | Domain port + infra impl | `PhorgeFacade` / `phorge_facade.dart` | Composes several sources (`AbsIPhorgeFacade`) |
| **Gateway** | Infra Discord client only | `DiscordGatewayClient` / `discord_gateway_client.dart` | Discord Gateway WebSocket; talks to `AbsIDiscordLiveIngestor` |
| **Client** | Domain port + infra | `AbsIOauthTokenClient`, `AbsIPushWakeClient` | Outbound HTTP to a non-activity vendor API |
| **Store** | Domain port + infra | `AbsILiveFeedStore`, `AbsIOauthStateStore` | Ephemeral persistence |

Keep “Gateway” only when it is Discord’s product name. A compose-sources wrapper is a **facade**, not a gateway.

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
| Credential encryption | `pointycastle` (AES-256-CBC for `user_provider_credentials.settings`; key `DAB_CREDENTIALS_KEY`, JWT secret fallback) |
| OAuth PKCE | `crypto` (`sha256` for S256 code challenges) |
| Cache | `redis` |
| Config loading | `dotenv` |
| External HTTP | `http` |

### App (`dab_app/`)

| Concern | Package |
|---|---|
| State management | `flutter_riverpod` |
| Navigation | `go_router` |
| Networking | `dio` + `web_socket_channel` + `cached_network_image` |
| Local persistence | `objectbox` + `objectbox_flutter_libs` |
| Secure token storage | `flutter_secure_storage` |
| Formatting | `timeago` + `intl` |
| Charts / visual analytics | `fl_chart` |
| Masonry / staggered grids | `flutter_staggered_grid_view` |
| Typography / icons | `google_fonts` + `simple_icons` + `flutty_heroicons` |
| App metadata (version / build) | `package_info_plus` |
| Local OS banners | `flutter_local_notifications` (desktop; copy stays on device) |
| External browser (OAuth Connect) | `url_launcher` |
| DI | Custom `ServiceLocator` singleton (`lib/services/service_locator.dart`) — not GetIt |
| Testing | `mocktail` (`ProviderContainer` / overrides for notifiers) |

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
  - On feature `*State` → same `*_state.dart` file.
  - On presentation or infrastructure helpers → `core/extensions/` in that layer, **one file per receiver class** (`activity_extensions.dart` → `OnActivity`).
  - Do not add free functions when a typed `On*` extension is the natural home. Named-arg builders with no single receiver (for example `inboxLaneTargets`, Admin webhook URL builders) may stay as functions.

### Error Handling

- Repositories return `Either<AppFailure, T>` — never throw.
- Datasources catch protocol-specific exceptions (e.g., `DioException`) and map them to `AppFailure` subtypes.
- Presentation notifiers call use cases — they never catch raw exceptions from infra.

---

## App-Specific Conventions

### Views

- **Mandatory structure:**
  ```
  [view_name]/
  ├── [name]_view.dart      ← LayoutBuilder + notifier bootstrap (often post-frame)
  ├── layouts/              ← device-specific layouts (mobile, desktop)
  │   ├── [name]_view_mobile.dart
  │   └── [name]_view_desktop.dart
  ├── [name]_notifier.dart  ← Riverpod `Notifier` + `…NotifierProvider`
  ├── [name]_state.dart     ← uses ViewStatus, always isolated file
  ├── models/               ← feature-local enums and data classes
  └── widgets/              ← one widget per file; subfolder for parent + children
  ```

- **One Widget Per File:** Strictly enforced. No extra widget classes in view, layout, or widget files. When a parent needs several files, put them in a named subfolder of `widgets/` (for example `dashboard/widgets/dashboard_follow_search/`). A single extracted widget with no siblings sits beside the other feature widgets.

- **Status Management:** Use the unified `ViewStatus` enum (`initial`, `loading`, `success`, `failure`) in all states.

- **Riverpod:** Prefer `ConsumerWidget` / `ConsumerStatefulWidget` and `ref.watch` / `ref.read` on feature `NotifierProvider`s. Root `ProviderScope` wraps the app in `main.dart`.

- **Initialization:** Trigger screen load via notifier methods (e.g. `started()`) from `addPostFrameCallback` when the view needs a stable context — avoid duplicating global DI.

### Networking

- `RestApiClient` — centralized Dio configuration in `lib/infrastructure/core/api/rest/`.
- Interceptors for auth injection, token refresh, Vegas sync, and logging.
- Every model must have `extension On[Model] on [Model]` with a `toDomain` getter, co-located in the model file.

### Navigation

- Route names + paths + view builders centralized in `AppRoute`.
- `AppRouter` encapsulates `GoRouter` config.
- Auth guards live in the router — not in widgets or notifiers.

### Localization

- `.arb` files in `lib/presentation/core/localization/l10n/`.
- Current baseline locale file: `app_en.arb` (additional locales are additive as introduced; includes `es`, `de`, `fr`, `pt`, `it`).
- Auto-generated via `flutter gen-l10n` (configured in `l10n.yaml`).
- **ARB metadata (`@key` blocks, placeholders, `description`):** define these **only** in `app_en.arb`. Every template message key should have a matching `@key` entry with at least a `description` (and `placeholders` where the string uses `{named}` placeholders). Other locale files contain message keys and values only—duplicate `@` metadata triggers tooling noise and is unnecessary; placeholder definitions are inherited from the template.
- **Non-English copy length:** The **main top app bar** (`dashboardTitle`, `navExplorer`, `insightsTitle`, `navAdmin`, `navFeed`) uses **full words** per locale—no truncation for space there. For **view toolbars**, **sidebar chips**, **settings sections**, and other dense chrome, prefer **short labels and standard abbreviations** so translated strings stay close to English length and avoid overflow without per-locale layout hacks. **Product / app names** (`brandTagline`, `appWindowTitle`, `appBrandShortName`, theme label **DAB**, etc.) stay **identical to English** in every locale—they are not translated.
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
| App mirror example | `lib/presentation/features/auth/auth_notifier.dart` → `test/presentation/features/auth/auth_notifier_test.dart` |
| Fixtures | Use `TestData` (Object Mother) factory — never inline entity construction |
| Mocking | `mocktail` at interface / repository boundaries only |
| Notifier testing | `ProviderContainer` + `provider.overrideWith(...)`; `listen` autoDispose providers during async tests |
| Integration tests | Tagged `@Tags(['integration'])` — excluded from CI unit runs |
| Determinism | No real network calls, no `DateTime.now()` without injection |
