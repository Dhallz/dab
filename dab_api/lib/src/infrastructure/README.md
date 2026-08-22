# Infrastructure layer

Implements Domain contracts. No business mapping (status interpretation belongs on Domain DTO extensions).

| Folder | Contents |
|---|---|
| `sources/` | Provider I/O: `*_source` implements `AbsIActivityPort`; catalogs; `DiscordGatewayClient`; `PhorgeFacade` |
| `protocols/` | Outbound wire adapters (Conduit, JSON REST, GraphQL, Slack Web API) |
| `persistence/` | `postgres/` (Drift), `redis/`, `repositories/` (`AbsI*` impls) |
| `core/` | `config/`, `security/`, `http/`, `adapters/`, `realtime/`, `logging/` |

DAB is a **read-only observer** of external systems. Links generated here stay relative to the provider `baseUrl`.
