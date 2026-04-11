# Dart Extensions — Naming & Structure

These rules define how Dart extensions must be named and organized across the DAB project to ensure consistency and discoverability.

---

## 🏗️ Naming Conventions

All extensions must follow these exact naming patterns:

### 1. File Naming & Location
- **Presentation & Infrastructure Layers**: Exactly **one file per class** being extended (e.g., `presentation/core/extensions/color_extensions.dart`).
- **Domain Layer**: Extensions are **co-located** in the same file as the entity class (e.g., `domain/entities/activity.dart`), below the class definition. A separate `_extensions.dart` file is **not required** for domain entities.
- **BLoC / Cubit state classes** (`*State` in `views/*/…_state.dart`): Extensions on that state type **must** live in the **same file**, **below** the state class (e.g., `extension OnAdminState on AdminState` at the bottom of `admin_state.dart`). Do **not** use a sibling `extensions/on_*_state.dart` file for state projections.
- **Pattern (when separate)**: `[lowercase_class_name]_extensions.dart` (e.g., `string_extensions.dart`).

### 2. Class Naming
- **Pattern**: `extension On[ClassName] on [ClassName]`
- **Example**: 
  ```dart
  extension OnColor on Color { ... }
  extension OnActivity on Activity { ... }
  ```

---

## 📍 Organization

Extensions should be located in an `extensions/` folder within the relevant architectural layer:

| Layer | Path Example | Use Case | Naming Convention |
|---|---|---|---|
| **Domain** | `lib/domain/entities/` | Business & pure POD logic | `extension On[ClassName] on [ClassName]` (Co-located in entity file) |
| **Presentation (feature state)** | `lib/presentation/views/<feature>/<feature>_state.dart` | Projections/getters on screen state | `extension On[Feature]State` co-located **below** the state class in that file |
| **Presentation** | `lib/presentation/core/extensions/` | UI logic, context-aware styles | `extension On[ClassName] on [ClassName]` (One file per class) |
| **Infrastructure** | `lib/infrastructure/core/extensions/` | Mapping, DTO transformations | `extension On[ClassName] on [ClassName]` (One file per class) |

---

## ⚡ Conflict Resolution

Multiple extensions for the same class can share the same name (e.g., `OnActivity`) across layers. Dart resolves members dynamically based on their **unique names**.

- **Safe usage**: `activity.someDomainMethod()` and `activity.someUiMethod()` can be used in the same file without conflict.
- **When to Prefix**: Prefixed imports (e.g., `import ... as ui`) are **only** required if two extensions define a member with the **exact same name** (e.g., both define `label`).

---

## ✅ Best Practices

- **Co-locate Domain Extensions**: All business logic extensions for domain entities **must** be co-located in the same file as the entity (below the class definition) to maintain domain autonomy.
- **Co-locate State Extensions**: Extensions on a feature `*State` class **must** sit in the same `*_state.dart` file under the state class so projections stay next to the POD snapshot.
- **Public API Documentation**: Use `///` doc-comments to explain the **role** and **contract** of the extension methods.
- **Layer Integrity**: Never import presentation-layer extensions (e.g., using `BuildContext` or `Color`) into the Domain or Application layers.

---

## 🚫 What Not to Do

- **Never use generic names** like `Utils` or `Helpers`. Use typed extensions instead.
- **Never create monolithic extension files** (e.g., `app_extensions.dart`). Split them by the type they extend.
- **Never add complex business logic** inside a presentation extension. Extensions should be used for transformations and convenience getters.
- **Primacy of Extensions**: Extensions take precedence over utility functions. Everything that can be implemented as an extension **must** be an extension. Utility files (e.g., `string_utils.dart`) are discouraged in favor of Typed Extensions.
