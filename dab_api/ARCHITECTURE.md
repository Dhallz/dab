# DAB API architecture

Canonical detail lives in **[doc/architecture.md](../doc/architecture.md)** and
**[doc/api.md](../doc/api.md)**. This file is a package-local summary only.

---

## Layers

```
Domain → Application → Infrastructure → Presentation
```

| Layer | Path | Role |
|---|---|---|
| Domain | `lib/src/domain` | Entities, `dtos/` + `OnXDto.toActivities`, `contracts/ports` + `contracts/repositories`. **Zero** imports from Application or Infrastructure. |
| Application | `lib/src/application` | Use cases and orchestration (`UnifiedActivityFetcher`, `ConnectorRegistry`, `LiveIngestPersister`). No SQL or HTTP protocol code. |
| Infrastructure | `lib/src/infrastructure` | **Sources** implement domain **Ports**. Protocols, Drift, Redis, adapters. Read-only toward external providers. |
| Presentation | `lib/src/presentation` | Thin Relic controllers and middleware. |

DI is GetIt (`sl<T>()`) in `lib/src/service_locator.dart`.

---

## Port / Source / DTO

1. **`AbsIActivityPort<T>`** (Domain) — fetch contract.
2. **Source** (Infrastructure) — implements the port; returns DTOs.
3. **`extension OnXDto.toActivities`** (Domain) — maps to `Activity`.
4. **`TypedConnectorPair<T>`** in `register_activity_connectors` — composition root.

Vegas (`X-Sync-Token` → 304) applies only to **`GET /activities`**. Live inbox
and Explorer search skip it. TBT child tables hydrate `ActivityProvider`;
`archived` / `inboxLane` live on Redis JSON, not Postgres columns.

`ActivityLivePollScheduler` is started at boot and does **not** publish authored
poll rows into the Dashboard inbox.
