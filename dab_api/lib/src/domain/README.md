# Domain layer

Business rules and contracts. **No** imports from `application/` or `infrastructure/`.

| Folder | Contents |
|---|---|
| `entities/` | Core models (`Activity`, `User`, provider configs, follows, credentials, …) |
| `dtos/` | Provider-native shapes plus co-located **`extension OnXDto.toActivities`** |
| `contracts/ports/` | Non-Postgres I/O (`AbsIActivityPort`, catalogs, live feed, OAuth, `AbsIPhorgeFacade`, `AbsIPushWakeClient`) |
| `contracts/repositories/` | Postgres `AbsI*` / `I*` interfaces |
| `core/` | Failures, org calendar, watch-list parsers, OAuth catalogs |

Adding a provider: Domain port + DTO + `toActivities` → Infrastructure Source → `TypedConnectorPair` in `register_activity_connectors`.
