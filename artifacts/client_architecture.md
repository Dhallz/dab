# Client Architecture Documentation

## Overview
The `dab_app` client follows **Clean Architecture** principles. This ensures that the UI (Presentation) and the implementation details like API/Database (Infrastructure) are independent of the Business Logic (Domain).

## Layers

### 1. Domain Layer (The Heart)
Independent of all other layers. It contains:
- **Core**: Foundational objects like `IRepository` in `lib/domain/repositories/core/`.
- **Entities**: Business objects named directly (e.g., `User` instead of `UserEntity`).
- **Use Cases**: Atomic business actions (e.g., `Login`, `Logout`).
- **Containers**: Feature-specific sets of use cases located in `lib/domain/containers/`.
- **Repositories (Interfaces)**: Contracts for data operations. It returns **Entities** or **AppFailures**.
  - *Naming*: `abstract interface class I[Name]Repository` in `abs_i_[name]_repository.dart`.

### Extension-First Utilities
To keep Entities clean and lean:
- **Extensions**: Any utility, mapper, or helper that processes an Entity should be implemented as an **extension** on that Entity.
  - *Example*: `extension OnUser on User { UserViewModel get toViewModel => ... }` // Use getter if no params
- **Location**: These extensions live in the **same file** as the Entity, placed directly under the class definition.

### 2.- **Infrastructure**: Concrete implementations.
  - `datasources/`: Remote (API) and Local (Database) raw data access.
  - `repositories/`: Implementation of domain repository interfaces, coordinating data sources.
  - `core/`: Transversal infra components.
    - `remote/`: API clients (e.g., REST, GraphQL).
    - `local/`: Local storage managers (e.g., ObjectBox).
    - `records/`: Persistent database models (DTOs).
- **Core (API)**: Protocol-specific networking clients.
  - **REST**: `RestApiClient` in `lib/infrastructure/core/api/rest/rest_api_client.dart`.
  - **GraphQL**: (Future) `GraphQlClient` in `lib/infrastructure/core/api/graphql/`.
- **Core (Database)**: Data persistence clients.
  - **Local**: `ObjectBoxStore` in `lib/infrastructure/core/database/local/`.
- **Data Sources**:
  - **Remote**: Makes HTTP calls via `RestApiClient`.
  - **Local**: Manages persistence via **ObjectBox**.
- **Repositories (Implementations)**: Orchestrates data retrieval between remote and local sources and **maps data into Domain Entities** using specialized extensions. 
- **Extensions (Infrastructure)**: Transformation logic that converts protocol/storage models into Domain Entities (e.g., `UserRecord.toDomain`).

### 3. Services Layer (Transversal)
Handles non-business, non-data concerns that span all layers.
- **Dependency Management**: `ServiceLocator` in `lib/services/` for centralizing all app dependencies.

### 3. Presentation Layer
Depends on the Domain layer. It contains:
- **Views**: Each specific screen is isolated in its own folder named after the screen (e.g., `login`, `home`).
  - Example: `lib/presentation/views/login/`
    - `login_view.dart`: The UI widget.
    - `login_bloc.dart`: The business logic.
    - `login_event.dart`: Event definitions.
    - `login_state.dart`: State definitions.
    - `layout/`: Platform-specific UI implementations.
      - `login_view_mobile.dart`
      - `login_view_desktop.dart`
      - `login_view_tablet.dart`
- **Core (Presentation)**:
  - **Base Classes**: `AbsBloc` and `AbsCubit` in `lib/presentation/core/`. These provide global access to the `AppCubit` via a static `appCubit` property and an instance `app` getter.
  - **Custom Utilities**: `AppBlocBuilder`, `AppBlocListener`, and `AppBlocConsumer`. These must be used instead of the vanilla counterparts to ensure safe `onInit` lifecycle handling and logging.
  - **Localization**: Logical structure for translations in `lib/presentation/core/localization/`.
  - **`l10n/`**: Subfolder for `.arb` files.
  - **Navigation**: The `AppRouter` class in `lib/presentation/core/navigation/app_router.dart` and route definitions (including view builders) in `lib/presentation/core/navigation/app_route.dart`.
- **Features**: Global cross-cutting features (e.g., Auth, Theme) using **Cubits**.
  - Example: `lib/presentation/features/auth/auth_cubit.dart`.
- **Core**: Contains presentation-wide shared resources.
  - **Navigation**: The **`go_router`** setup in `lib/presentation/core/navigation/app_router.dart`.
  - **Styles**: Theme definitions, constants, and design tokens (`lib/presentation/core/styles`).
  - **Widgets**: Reusable, atomic components used across multiple views (`lib/presentation/core/widgets`).

## Data Flow & Serialization
We follow the **Standard Clean Architecture** flow for maximum type safety:
1. **Infrastructure** fetches raw JSON.
2. **Infrastructure Repository** parses the JSON into a **Domain Entity** immediately.
3. **Domain UseCase** receives the Entity and performs business logic.

## Dependency Injection
We use **`RepositoryProvider`** and **`MultiRepositoryProvider`** from the `flutter_bloc` package to provide repositories through the widget tree.

## Navigation
We use **`go_router`** for declarative, URL-based navigation. 
- **Configuration**: The router is configured in `lib/presentation/core/navigation/app_router.dart`.
- **Redirection**: It allows for easy redirection logic based on `AuthCubit` state.

## Error Handling
We use a **sealed `AppFailure` hierarchy** via `dart_mappable` and functional programming with `fpdart`.
- **Sealed Class**: Standardizes how errors are handled in Blocs (using `switch` expressions).
- **Types**: Includes `ServerFailure`, `NetworkFailure`, `AuthFailure`, and `ValidationFailure`.
- **Error Mapping (Infrastructure Layer)**: Handled exclusively in the **Infrastructure** layer. 
  - To maintain strict separation, the **Domain** (including `AppFailure`) is never aware of `DioException`.
  - The **Infrastructure Repository Implementation** (e.g., `AuthRepository`) catches `DioException` and maps it to `AppFailure`.
  - *Location*: `lib/infrastructure/core/extensions/dio_extensions.dart`.
  - *Example*: `repository.dart` catches `e` and returns `Left(e.toAppFailure)`. // Using getter
- **Repository Error Flow**:
  1. **Infrastructure Repository** calls a Data Source.
  2. If an exception occurs, it maps the low-level exception to an `AppFailure`.
  3. It returns the resulting `AppFailure` via `Left`.
