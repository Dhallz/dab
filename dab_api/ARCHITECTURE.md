# DAB API: Architectural Manifesto 🏛️ ⚙️

This document serves as the **Supreme Source of Truth** for the DAB API architecture. All future AI agents and developers working on this project **MUST** strictly adhere to the patterns and constraints defined here.

---

## 🎨 Clean Architecture: The Core Layers

The DAB API is built on a strictly layered Clean Architecture, designed to decouple business rules (The "What") from infrastructure implementation (The "How").

### 1. Domain Layer (`lib/src/domain`)
- **Role**: Defines the absolute business logic and data contracts of the system.
- **Components**:
    - **Entities & provider DTOs**: Pure data models (Activity, User, ProviderMetadata). `dtos/` carry remote row shapes plus co-located **`extension OnDto`** mappings — **business interpretation only**, no infrastructure dependencies.
    - **Interfaces**: Abstract contracts (`AbsI*`) that define what the system needs without specifying how to fetch it.
- **STRICT CONSTRAINT**: **ZERO IMPORTS** from Infrastructure or Application layers. This layer is isolated and pure.

### 2. Application Layer (`lib/src/application`)
- **Role**: Coordinates the system's "Use Cases" and manages domain/infrastructure interaction.
- **Components**:
    - **Services**: Orchestration logic like `UnifiedActivityFetcher` and `ConnectorRegistry`.
    - **UseCases**: Encapsulate high-level application flows (e.g., `FetchRemoteActivities`).
- **STRICT CONSTRAINT**: No direct knowledge of databases or specific external APIs (that logic belongs in the Infrastructure layer).

### 3. Infrastructure Layer (`lib/src/infrastructure`)
- **Role**: Implements the contracts defined in Domain using specific technologies (PostgreSQL, Conduit, HTTP).
- **Components**:
    - **Sources**: Specialized fetchers (e.g., `PhorgeTaskSource`) that handle raw I/O and protocol management for a specific data type.
    - **Repositories**: Handle SQL persistence and polymorphic data hydration (Table-Per-Type).
- **STRICT CONSTRAINT**: **READ-ONLY Domain Purity**. DAB is an observer; write operations to external systems are strictly forbidden within the activity stream.

### 4. Presentation Layer (`lib/src/presentation`)
- **Role**: The "Entry Points" for external consumers (REST Controllers, WebSocket Middleware).
- **Components**:
    - **Controllers**: Thin wrappers that purely delegate to Application UseCases.
    - **Middleware**: Handles cross-cutting concerns like "Vegas Sync" (high-performance staleness checks).

---

## 🏗️ Core Architectural Patterns

### 🧩 The Source / payload-extension pattern
We separate the "Doing" (I/O) from the "Thinking" (Mapping) to ensure the system is **Open-Closed** for new data types.
1.  **IActivitySource** (Infrastructure): Fetches raw data from an API and returns it as a specialized DTO.
2.  **`extension OnXDto`** (Domain): Implements **`toActivities(List<User>)`** — transforms that payload into zero or more **`Activity`** values.
3.  **TypedConnectorPair** (+ **`providerId`**) / **ConnectorRegistry**: Registered in **`register_activity_connectors`** — binds Source + mapping + metadata id filtering.

### 🔄 The Vegas Pattern (Sync Protocol)
DAB avoids unnecessary database reads by using a Redis-backed versioning system:
1.  Every write increases a `syncToken`.
2.  Clients send their `syncToken` in the `X-Sync-Token` header.
3.  The **Vegas Middleware** compares the token. If nothing has changed, it returns `304 Not Modified` instantly.

### 🗄️ TBT (Table-Per-Type) Persistence
To avoid the "Big JSON Blob" anti-pattern, we use relational polymorphism:
- Base `activities` table holds shared fields.
- Child tables (e.g. `activity_phorge`) hold specific metadata.
- Repository implementations perform `leftOuterJoin` to hydrate the sealed `ActivityProvider` hierarchy.

---

## 🛡️ Guardrails for AI Agents

1.  **Don't Break Domain Purity**: Never add an infrastructure import to `lib/src/domain`.
2.  **Use the Service Locator**: Dependencies are managed via `GetIt` (`sl<T>()`). Do not instantiate services manually inside controllers or usecases.
3.  **Relative URLs Only**: External links must be relative (e.g. `/T123`). Full URL construction happens at the client level or is derived from provider config.
4.  **Follow the Mappable Pattern**: All entities must use `dart_mappable` for serialization and type-safe fan-out.

---

> [!IMPORTANT]
> **Reading this document is a requirement for all code modifications.** If an agent proposes a change that violates these principles, they have FAILED in their task.
