# DAB App — Flutter Client Architecture

> **Linear source:** [Dab Client](https://linear.app/dev-activity-board/document/dab-client-05e24723cfe7) · Last synced: 2026-04-08  
> **Package:** `dab_app/` · Framework: Flutter · SDK: `^3.9.2`

---

## Architecture Schema

```mermaid
graph TD
    subgraph "Presentation Layer"
        view["View/Switcher"] --> bloc["BLoC/Cubit"]
        view --> layout["Layouts"]
        view --> local_w["Local Widgets"]
    end
    subgraph "Services Layer"
        serv["ServiceLocator"]
    end
    subgraph "Domain Layer"
        ent["Entities & Extensions"]
        uc["Use Cases & Containers"]
        repo_int["I_Repositories"]
        fail["AppFailures (Sealed)"]
    end
    subgraph "Infrastructure Layer"
        repo_impl["Repository Impls"]
        mapper["Dio → Failure Extensions"]
        model["Local/Remote Models + toDomain"]
        ob["ObjectBox / Local"]
        api["Dio / RestApiClient"]
    end
    bloc --> uc
    uc --> repo_int
    bloc --> serv
    serv --> repo_int
    repo_impl -->|implements| repo_int
    repo_impl --> mapper
    repo_impl --> ob
    repo_impl --> api
    view -. provides .-> bloc
```

---

## Layer Details

### 1. Domain Layer (`lib/domain/`)

Pure Dart. Zero Flutter or third-party framework imports.

- **Entities:** Business objects — no "Entity" suffix. Current entities:
  - `Activity` — normalized activity event
  - `ActivityProvider` — sealed hierarchy for provider-specific payloads
  - `User` — DAB user with role, group, and provider identity links
  - `UserIdentity` — maps DAB user to external provider account
  - `Group` — organizational grouping
  - `ProviderConfig` — external tool settings (`baseUrl`, `iconUrl`, `configJson`)
  - `Presence` — real-time online/offline status
  - `AuthResponse` — JWT + refresh token pair

- **Entities use `dart_mappable`** for serialization, equality, and `copyWith`.

- **Extension-First:** Any helper on an entity is an `extension OnUser on User` co-located in the **same file**.

- **Use Cases:** Atomic business actions (e.g., `Login`, `FetchActivities`).

- **Use Case Containers:** Aggregators (e.g., `AuthUseCases`) that group related use cases and inject the required `IRepository` instances.

- **Repository Interfaces:** `abstract interface class I[Name]Repository extends IRepository`. Returns `Either<AppFailure, T>`.

- **Failures:** Sealed `AppFailure` hierarchy — `ServerFailure`, `NetworkFailure`, `CacheFailure`, `AuthFailure`, etc.

---

### 2. Infrastructure Layer (`lib/infrastructure/`)

Implements Domain contracts. Handles protocols, APIs, and databases.

- **Repositories:** Concrete `[Name]Repository extends Repository implements I[Name]Repository`. Orchestrate datasources.

- **Datasources:**
  - **Remote:** `RestApiClient` wrapping Dio. Includes `VegasInterceptor` for sync token management and `AuthInterceptor` for JWT injection + refresh.
  - **Local:** `ObjectBoxStore` — ultra-fast O(1) device persistence.

- **Models:** DB/API-specific DTOs. **Every model must** have an `extension On[Model] on [Model]` with a `toDomain` getter, co-located in the same file.

- **Error Mapping:** Converts `DioException` → `AppFailure`. Located in `core/extensions/dio_extensions.dart`.

---

### 3. Presentation Layer (`lib/presentation/`)

Handles UI and state via `flutter_bloc`.

#### The View Hierarchy (mandatory structure)

Every screen module in `lib/presentation/views/[view_name]/` must follow:

```
[view_name]/
├── [name]_view.dart           ← "Switcher": BlocProvider + LayoutBuilder routing
├── layout/
│   ├── [name]_view_mobile.dart
│   └── [name]_view_desktop.dart
├── [name]_cubit.dart          ← extends AbsCubit (or AbsBloc)
├── [name]_state.dart          ← immutable, isolated state file
└── widgets/                   ← private local widgets (one per file)
```

#### Application Views

| View | Role | State Pattern |
|---|---|---|
| **Login** | Auth gate | Form bound to `AuthCubit` |
| **Dashboard** | Real-time activity feed | Streamed list via WebSocket + `AppBlocBuilder` |
| **Explorer** | Historical activity browser | Chronological strip with selectable timeframe |
| **Statistics** | Behavior analytics | Area/Donut charts built from ObjectBox data |
| **Settings** | User personalization | Dynamic forms — tool linking, theming |
| **Admin Console** | System administration | List/action views gated by `Admin` role |

---

### 4. Services Layer (`lib/services/`)

- `ServiceLocator` — centralizes all dependency instantiation and injection. This is the only place dependencies are wired together.

---

## State Management Rules

- **Base Classes:** Every Cubit extends `AbsCubit`; every Bloc extends `AbsBloc`.
- **Global AppCubit:** Accessible via the inherited `app` getter in any Bloc/Cubit, or via static `AbsBloc.appCubit` for constructor initializers.
- **UI Builders:** Always use `AppBlocBuilder`, `AppBlocListener`, or `AppBlocConsumer`. Use the `onInit` callback for one-time initialization logic.
- **Cubits call use cases only** — never datasources or repositories directly.
- **No business logic in widgets.** Widgets read state and dispatch events — nothing more.

---

## Navigation (go_router)

All routes are declared in `AppRoute` and wired in `AppRouter`.

- Use named routes — never push raw path strings.
- Auth guards (`redirect` logic) live in the router configuration, not in widgets.
- Never import a screen file directly into another screen for navigation.

---

## Vegas Sync — Client-Side Implementation

1. **Storage:** `AppSettingsRecord` in ObjectBox stores the global `syncToken`.
2. **VegasInterceptor:**
   - **Outgoing:** Injects `X-Sync-Token` header.
   - **Incoming:** Extracts `meta.syncToken` from envelope responses and updates ObjectBox.
   - **Short Circuiting:** On `304 Not Modified`, repositories return cached ObjectBox data immediately.
3. **Real-Time Layer:** WebSocket connection pushes new events while the app is alive.

---

## Dynamic Deep-Linking & Provider Config Resolution

1. **Bootstrap:** On init, `AppCubit` fetches `List<ProviderConfig>` from `/metadata/configs`.
2. **Resolution:** `ActivityCard` matches `Activity.provider.name` against the loaded configs.
3. **URL Joining:** If the backend provides a relative path (e.g., `/T123`), the card prepends `ProviderConfig.baseUrl`.
4. **Icons:** Provider icons served via `ProviderConfig.iconUrl` — Material icons as fallback.

---

## Auth & Token Security

- JWTs stored exclusively in `FlutterSecureStorage` (native OS Keychain / Keystore).
- Token refresh handled entirely by `AuthInterceptor` — cubits must not trigger refresh manually.
- On logout: clear both cubit state and secure storage atomically.
- **Phorge Identity Linking:** Client maps `User.ownerPHID` to their DAB `userId` to filter personal backlogs.

---

## Design System: Premium Glassmorphism

The project uses a unified design system centered around Material 3 roles, implemented in `lib/presentation/core/styles/`.

| Token Category | File | Description |
|---|---|---|
| **Colors** | [app_colors.dart](file:///Users/dhallz/git/dab/dab_app/lib/presentation/core/styles/app_colors.dart) | M3 roles + Electric Indigo (`#6366F1`) & Glass Tokens |
| **Spacing** | [app_spacing.dart](file:///Users/dhallz/git/dab/dab_app/lib/presentation/core/styles/app_spacing.dart) | Base 4px grid (tiny=4, small=8, medium=16, large=24) |
| **Typography** | [app_text_styles.dart](file:///Users/dhallz/git/dab/dab_app/lib/presentation/core/styles/app_text_styles.dart) | **Mona Sans** for UI, **Roboto Mono** for Monospace |
| **Layout** | [app_layout.dart](file:///Users/dhallz/git/dab/dab_app/lib/presentation/core/styles/app_layout.dart) | Viewport constraints, standard border radii (12-24px) |
| **Icons** | [app_icons.dart](file:///Users/dhallz/git/dab/dab_app/lib/presentation/core/styles/app_icons.dart) | Centralized icon map for the application |

### Premium Glassmorphism
- **Surface**: `AppColors.glassSurface` (low opacity slate) + backdrop blur `σ 8–12`.
- **Borders**: Subtile `1px` lines using `AppColors.glassBorder` (white alpha).
- **Branding**: Elevated by **Electric Indigo** accents for high-contrast interactivity.

### Micro-Animations
- **Staggered Entrances:** Dashboard cards animate in with a 50ms stagger.
- **Provider Glow:** Hover reveals `BoxShadow` colored by provider glow roles (e.g., Slack Purple `#4A154B`).
- **Entry Pulse:** Incoming WebSocket events trigger a spring-scale transition.

---

## Development Commands

| Action | Command |
|---|---|
| Analyze | `flutter analyze` |
| Run tests | `flutter test` |
| Run app | `flutter run` |
| Regenerate code | `dart run build_runner build --delete-conflicting-outputs` |
| Generate l10n | Automatic via `l10n.yaml` (`flutter gen-l10n`) |
