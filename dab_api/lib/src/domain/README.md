# DAB: Domain Layer 🧩

The Domain layer is the heart of the system. It contains the business rules and entities that define **what DAB is**, regardless of its technical implementation.

---

## 🏗️ Core Responsibilities

1. **Entities**: Define the core data models (`Activity`, `User`, `ProviderMetadata`).
2. **Provider payloads + extensions**: **`entities/provider_payloads/`** hold provider-native shapes. Co-located **`extension OnXDto on XDto`** entries implement **`toActivities(List<User>)`** — the “meaning” rules (pure logic) linking remote rows to **`Activity`**.
3. **Failures**: Define systematic failure cases (e.g., `DatabaseFailure`, `AuthFailure`).

---

## 🛡️ Architectural Guardrails (STRICT)

- **🚫 NO INFRASTRUCTURE IMPORTS**: This layer must **NEVER** import from `infrastructure/` or `application/`. It must only import from within `domain/` or external pure-logic packages (e.g., `dart_mappable`, `uuid`).
- **🚫 NO SIDE EFFECTS**: Entities and mapping extensions must be pure and predictable. No API calls or database queries are allowed here.
- **✅ CONTRACTS FIRST**: All external system interactions must be defined via **Interfaces** (e.g., `IActivitySource`, `IAuthRepository`).

---

## 🧩 Provider payload → Activity

Extensions on each DTO (e.g. `OnPhorgeTaskBundleDto`) encode how a Slack message or Phorge transaction reads in the unified feed — business interpretation stays in Domain; infrastructure only fetches/builds DTOs.

---

> [!CAUTION]
> If you are adding a new platform (e.g. GitHub), add **`IActivitySource<T>`** Infrastructure + DTO(s) here, **`toActivities`** on the DTO, then register **`TypedConnectorPair<T>`** in **`register_activity_connectors`**.
