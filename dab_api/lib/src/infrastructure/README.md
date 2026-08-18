# DAB: Infrastructure Layer ⚙️

The Infrastructure layer is responsible for the **How** and the **Where**. it handles all raw protocol interactions, database persistence, and external API clients.

Top-level folders:

| Folder | Contents |
|---|---|
| `sources/` | Provider I/O (`AbsIActivitySource`, catalogs, Discord Gateway) |
| `protocols/` | Outbound wire adapters (Conduit, JSON REST, GraphQL, Slack Web API) |
| `persistence/` | `postgres/` (Drift), `redis/`, `repositories/` (AbsI* impls) |
| `core/` | `config/`, `security/`, `http/`, `adapters/`, `realtime/`, `logging/` |

---

## 🏗️ Core Responsibilities

1. **Sources (`AbsIActivitySource`)**: Specialized fetchers (e.g., `PhorgeTaskSource`) that handle raw I/O and protocol management for a specific data type.
2. **Repositories (`I...Repository`)**: Implement the interfaces defined in the Domain using PostgreSQL/Drift. They handle the Table-Per-Type (TBT) relational mapping and polymorphic hydration.
3. **Clients**: Specialized HTTP or Conduit clients that handle rate manipulation and low-level mapping.

---

## 🛡️ Architectural Guardrails (STRICT)

- **🚫 NO BUSINESS LOGIC**: This layer must **NEVER** define "What a Sprint is" or "How to interpret a status". It only knows how to fetch and persist data.
- **🚫 READ-ONLY CONSTRAINT**: DAB never writes to external systems. Providers must strictly use read-only queries.
- **✅ TABLE-PER-TYPE**: All polymorphic metadata MUST be stored in dedicated relational tables, never in generic JSONB blobs.
- **✅ RELATIVE URLS**: Links generated here (e.g. `/T123`) must be relative to the specific provider's base URL.

---

## 🧩 The Source Strategy

Sources are data-type specific (e.g., Task, Revision). If you are adding a new platform, implement its raw API logic in a new `AbsIActivitySource` and link it to its corresponding Domain Mapper in the `ConnectorRegistry`.

---

> [!WARNING]
> DO NOT implement business mapping rules here. If you find yourself checking if a status equals "Done," that logic belongs in a Mapper in the Domain layer.
