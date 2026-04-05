# DAB: Domain Layer 🧩

The Domain layer is the heart of the system. It contains the business rules and entities that define **what DAB is**, regardless of its technical implementation.

---

## 🏗️ Core Responsibilities

1. **Entities**: Define the core data models (`Activity`, `User`, `ProviderMetadata`).
2. **Mappers (`IActivityMapper`)**: Define the **Business Logic** for data interpretation. Even though they handle specialized data types from Infrastructure, they live here to ensure that "What a Sprint is" or "What a Status means" is defined in the Domain.
3. **Failures**: Define systematic failure cases (e.g., `ServerFailure`, `AuthFailure`).

---

## 🛡️ Architectural Guardrails (STRICT)

- **🚫 NO INFRASTRUCTURE IMPORTS**: This layer must **NEVER** import from `infrastructure/` or `application/`. It must only import from within `domain/` or external pure-logic packages (e.g., `dart_mappable`, `uuid`).
- **🚫 NO SIDE EFFECTS**: Entities and Mappers must be pure and predictable. No API calls or database queries are allowed here.
- **✅ CONTRACTS FIRST**: All external system interactions must be defined via **Interfaces** (e.g., `IActivityProvider`, `IAuthRepository`).

---

## 🧩 The Mapper Strategy

Mappers are the bridge between raw protocol data and domain entities. 
Example: `PhorgeTaskMapper` knows that a Phorge transaction of type `status` with value `resolved` means the task is **DONE**. That "Logic of Meaning" is a business rule, so it belongs here.

---

> [!CAUTION]
> If you are adding a new platform (e.g. GitHub), you **MUST** create an `IActivityProvider` interface and a corresponding `IActivityMapper` here first.
