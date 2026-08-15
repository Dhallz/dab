# DAB: Application Layer 🔗

The Application layer is the **Glue Layer**. It coordinates Domain business rules and Infrastructure technical services.

---

## 🏗️ Core Responsibilities

1. **Services**: Orchestrate cross-provider logic (`UnifiedActivityFetcher`, `ConnectorRegistry`, `LiveIngestPersister`). This is where high-level state and fan-out happen.
2. **UseCases**: Encapsulate specific application flows (FetchRemoteActivities, SyncPhorgeUsers).
3. **Dependency Management**: Centralized registration in `service_locator.dart`.

---

## 🛡️ Architectural Guardrails (STRICT)

- **🚫 NO SQL / NO HTTP**: This layer must **NEVER** contain direct SQL queries or HTTP protocol logic (those are Infrastructure). Prefer injecting narrow callbacks (e.g. structured logging) instead of importing infrastructure service types.
- **🚫 NO BUSINESS RULES**: Mapping and categorization rules live in the Domain. This layer only coordinates their usage.
- **✅ ISOLATE-SAFE**: Use `Isolate.run()` or `Compute` for heavy processing (fan-out, data transformation) to keep the main event loop responsive.
- **✅ USECASES**: All controller actions MUST delegate to a UseCase. No complex logic is allowed in controllers.

---

## 🧩 The Coordination Strategy

When a client requests activities, the `UnifiedActivityFetcher` coordinates with the `ConnectorRegistry` to trigger all registered Sources (Infrastructure) in parallel and maps each fetched row via its DTO **`toActivities`** extension (Domain).

---

> Connector pairs are registered as **`TypedConnectorPair<T>`** (`IActivitySource<T>`, **`providerId`**, **`mapItemToActivities`**). **`ConnectorRegistry.register`** immediately wraps each into a **`RegisteredConnectorPair`** with Object?-typed fetch/map so iteration never uses unsound `TypedConnectorPair<dynamic>` (Dart function contravariance on the row parameter).

---

> [!TIP]
> This is where you register new Connector pairs. If a Source is not in the `ConnectorRegistry`, it does not exist for the system.
