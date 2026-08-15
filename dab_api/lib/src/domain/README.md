# DAB: Domain Layer 🧩

The Domain layer is the heart of the system. It contains the business rules and entities that define **what DAB is**, regardless of its technical implementation.

---

## 🏗️ Core Responsibilities

1. **Entities**: Define the core data models (`Activity`, `User`, `ProviderMetadata`).
2. **Provider DTOs + extensions**: **`dtos/`** hold provider-native shapes, JSON→DTO factories, and co-located **`extension OnXDto on XDto`** entries that implement **`toActivities(List<User>)`**. Watch-list parsers live next to the entity or under **`core/{id}_scope.dart`**.
3. **Contracts (`contracts/`)**: Outbound seams. **`ports/`** for I/O that is not our database (`IActivitySource`, live ingest, OAuth, catalogs, `AbsIPhorgeGateway`). **`repositories/`** for Postgres `AbsI*` / `I*` interfaces.
4. **Failures**: Define systematic failure cases (e.g., `DatabaseFailure`, `AuthFailure`) under **`core/failures/`**.

---

## 🛡️ Architectural Guardrails (STRICT)

- **🚫 NO INFRASTRUCTURE IMPORTS**: This layer must **NEVER** import from `infrastructure/` or `application/`. It must only import from within `domain/` or external pure-logic packages (e.g., `dart_mappable`, `uuid`).
- **🚫 NO SIDE EFFECTS**: Entities and mapping extensions must be pure and predictable. No API calls or database queries are allowed here.
- **✅ CONTRACTS FIRST**: All external system interactions must be defined via **Interfaces** (e.g., `IActivitySource`, `ILiveFeedStore`, `IWebhookRequestAuthenticator`).

---

## 🧩 Provider DTO → Activity

Extensions on each DTO (e.g. `OnPhorgeTaskBundleDto`) encode how a Slack message or Phorge transaction reads in the unified feed — business interpretation stays in Domain; infrastructure only fetches/builds DTOs.

---

> [!CAUTION]
> If you are adding a new platform (e.g. GitHub), add **`IActivitySource<T>`** Infrastructure + DTO(s) under **`domain/dtos/`**, **`toActivities`** on the DTO, then register **`TypedConnectorPair<T>`** in **`register_activity_connectors`**.
