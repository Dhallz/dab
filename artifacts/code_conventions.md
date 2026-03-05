# Code Conventions

This document outlines the coding standards and conventions for the `dab_app` project.

## General Principles
- **Conciseness over Redundancy**: If a folder name provides context, don't repeat it in the file or class name (e.g., `lib/domain/entities/user.dart` contains class `User`, not `UserEntity`).
- **Modern Dart**: Use Dart 3 features like `sealed` classes, `switch` expressions, and `abstract interface` classes.

## Tech Stack & Packages

### Core Dependencies
- **`flutter_bloc`**: State management and Dependency Injection (`RepositoryProvider`).
- **`go_router`**: Declarative routing and navigation.
- **`fpdart`**: Functional programming utilities (e.g., `Either` for error handling).
- **`dio`**: Powerful HTTP client for API communication.
- **`flutter_secure_storage`**: Secure local persistence for sensitive data (e.g., Auth Tokens).
- **`dart_mappable`**: High-performance serialization, equality, and `copyWith` generation.

### Views
- **Location**: `lib/presentation/views/[view_name]/`.
- **Mandatory Structure**:
  - `[view_name]_view.dart`: Main entry point, responsive switcher, and `BlocProvider`.
  - `[view_name]_bloc.dart` (or `_cubit.dart`): Logic holder.
  - `[view_name]_state.dart`: State representation (always separate).
  - `layout/`: Folder containing `[view_name]_view_mobile.dart` and `[view_name]_view_desktop.dart`.
  - `widgets/`: (Optional) Local widgets specific only to this view.
- **Naming**: Use `[Name]View`, `[Name]Cubit` (e.g., `SettingsView`, `SettingsCubit`).
- **Base Classes**: Every Bloc must extend `AbsBloc`, and every Cubit must extend `AbsCubit`.
- **UI Consumables**: Always use `AppBlocBuilder`, `AppBlocListener`, or `AppBlocConsumer` instead of vanilla Flutter Bloc widgets.

### Dev Dependencies
- **`build_runner`**: Code generation orchestrator.
- **`dart_mappable_builder`**: The builder for generating mappers.

## Naming Conventions

### Entities
- **Class Name**: Direct name (e.g., `User`).
- **File Name**: snake_case matching the class (e.g., `user.dart`).
- **Location**: `lib/domain/entities/`.
- **Note**: No "Entity" suffix.

### Repositories (Interfaces)
- **Class Name**: `abstract class IRepository` (Marker interface).
- **Location**: `lib/domain/repositories/core/abs_i_repository.dart`.

- **Class Name**: `abstract interface class I[Name]Repository extends IRepository` (e.g., `IAuthRepository`).
- **File Name**: Prefixed with `abs_i_` (e.g., `abs_i_auth_repository.dart`).
- **Location**: `lib/domain/repositories/`.

### Use Cases
- **Class Name**: `[Action]` (e.g., `Login`).
- **File Name**: snake_case of the action (e.g., `login.dart`).
- **Location**: `lib/domain/usecases/[feature]/`.
- **Note**: Use Cases should be atomic.

### Use Case Containers (Aggregators)
- **Class Name**: `[Feature]UseCases` (e.g., `AuthUseCases`).
- **File Name**: `[feature]_usecases.dart`.
- **Location**: `lib/domain/containers/`.
- **Purpose**: Aggregates atomic use cases (potentially from multiple bounded contexts) into a single set for a specific feature or UI layer.
- **Implementation**: The container should instantiate the individual Use Cases, taking the necessary repositories as constructor arguments.

### Repositories (Implementations)
- **Class Name**: `abstract class Repository` (Base implementation).
- **Location**: `lib/infrastructure/repositories/core/repository.dart`.

- **Class Name**: `class [Name]Repository extends Repository implements I[Name]Repository` (e.g., `AuthRepository`).
- **File Name**: `[name]_repository.dart`.
- **Location**: `lib/infrastructure/repositories/`.

### Services (Transversal)
- **Service Locator**: `ServiceLocator` in `lib/services/service_locator.dart`.
  - **Purpose**: Centralized instantiation of all app dependencies.
- **Failures**: Located in `lib/domain/core/failures.dart`.

### Navigation
- **AppRoute**: Centralized class for route names, paths, and **view builders** in `lib/presentation/core/navigation/app_route.dart`.
- **AppRouter**: A class that encapsulates `GoRouter` configuration. It maps `GoRoute` instances to their corresponding `AppRoute` properties.

### Localization
- **Translation Files**: Use `.arb` files in `lib/presentation/core/localization/l10n/`.
- **Logic & Classes**: Localization-specific helpers, extensions, or custom logic should reside in `lib/presentation/core/localization/`.
- **Naming**: Use `app_en.arb`, `app_fr.arb`, etc.

### Extensions
- **Naming**: `extension On[TargetName] on [TargetName]`.
- **Style**: Use **getters** for transformations/utilities that don't require parameters.
- **Location**: 
  - For Entities: Same file, under the class.
  - For External Classes: In a specific `core/extensions/` folder within the relevant layer (e.g., `lib/infrastructure/core/extensions/dio_extensions.dart`).

### Networking
- **RestApiClient**: Centralized class for `Dio` configuration located in `lib/infrastructure/core/api/rest/rest_api_client.dart`.
- **Interceptors**: Custom logic (Auth, Logging) should be added as `Interceptors` to the `RestApiClient`.
- **Base URL**: Managed within the `RestApiClient`.
- **Extensibility**: Other protocols (e.g., GraphQL) follow the same pattern in `lib/infrastructure/core/api/[protocol]/`.

### Database & Persistence
- **Local**: `ObjectBoxStore` and Models in `lib/infrastructure/core/database/local/`.
- **Remote**: Models in `lib/infrastructure/datasources/remote/models/`.
- **Model Mapping**: Local/Remote models **must** have an extension to map them to Domain Entities. 
  - *Location*: In the **same file** as the model itself (e.g., `lib/infrastructure/core/database/local/models/user_record.dart`).
  - *Naming*: `extension On[Model] on [Model]` with a `toDomain` getter.

## Layer Responsibilities
- **Domain**: Pure business logic and contracts. Never imports other layers or 3rd party networking/storage libraries.
- **Infrastructure**: Implements Domain contracts. Handles networking (e.g., Dio), parsing, and error mapping.
- **Presentation**: Handles UI and state management. organized by `views/` and global `features/`.

## State Management Best Practices
- **Global Access**: Access the global `AppCubit` via the inherited `app` getter in any Bloc/Cubit. 
- **Initialization**: For constructor initializers where `this` is not available, use the static `AbsBloc.appCubit` property.
- **View Lifecycle**: Use the `onInit` callback in `AppBlocBuilder/Consumer` for one-time View initialization logic (e.g., firing a "Started" event).

---

## 🏗️ Workflow & Methodology
To ensure a stable foundation for the user interface, the following sequence must be followed for every new feature:

1.  **Contract Layer**: Define the Domain interfaces (IRepository) and Entities first.
2.  **API Implementation (Backend First)**: Complete all `dab_api` endpoints and data models before starting the frontend work. 
3.  **Infrastructure (Client)**: Implement the concrete Repository on the client side once the API is stable.
4.  **UI Implementation**: Build the Blocs and Views only *after* the data flow is verified and working.
