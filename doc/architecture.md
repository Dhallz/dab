# DAB — Cross-Package Architecture

> **Source of truth for layer boundaries, data flow, and cross-cutting patterns.**  
> Both `dab_api` and `dab_app` use Clean Architecture. This document describes the shared philosophy and how the two packages interact.

---

## 1. The Four Layers

```
Domain  ──►  Application  ──►  Infrastructure  ──►  Presentation
```

| Layer | Role | Import Constraint |
|---|---|---|
| **Domain** | Pure business entities, interfaces, mappers | **Zero** external or cross-layer imports |
| **Application** | Use cases, service orchestration | May import Domain; never imports Infrastructure directly |
| **Infrastructure** | DB, HTTP, caches, connectors | Implements Domain contracts; never leaks upward |
| **Presentation** | API controllers / Flutter UI | Delegates entirely to Application; holds no business logic |

Violating these import rules is an architectural failure — refactor the abstraction instead.

---

## 2. Package Responsibilities

```
dab/
├── dab_api/    ← Dart server. Ingestion, storage, REST + WebSocket API
└── dab_app/    ← Flutter client. Auth + shell navigation, dashboard, explorer, insights, admin, settings
```

### API Package Layer Map

```
dab_api/lib/src/
├── domain/
│   ├── entities/        ← Subject Folders: activity/, group/, provider/, user/
│   ├── repositories/    ← Abstract interfaces prefixed I*
│   ├── mappers/         ← IActivityMapper — transforms provider DTOs to domain Activity
│   └── services/        ← Domain-level service contracts
├── application/
│   ├── usecases/        ← Single-responsibility use cases
│   ├── services/        ← UnifiedActivityFetcher, ConnectorRegistry, PresenceService, IdentityDiscoveryService
│   └── containers/      ← Grouped use case aggregators
├── infrastructure/
│   ├── connectors/      ← Provider HTTP clients / DTO adapters (e.g., Phorge connector)
│   ├── sources/         ← IActivitySource implementations and raw fetchers
│   ├── repositories/    ← SQL repository implementations (Drift + PostgreSQL)
│   ├── database/        ← Drift schema, DAOs, migrations
│   ├── dtos/            ← Provider-specific Data Transfer Objects
│   ├── http/            ← HTTP client helpers
│   ├── security/        ← JWT, bcrypt
│   ├── config/          ← Config, env loading
│   ├── logging/         ← Structured logging
│   └── notifications/   ← WebSocket push logic
└── presentation/
    ├── controllers/     ← Relic HTTP controllers (7 controllers: activity, admin, auth, group, health, metadata, user)
    └── middlewares/     ← Vegas Middleware, JWT Middleware
```

### App Package Layer Map

```
dab_app/lib/
├── domain/
│   ├── entities/        ← Subject Folders: activity/, group/, provider/, user/
│   ├── repositories/    ← Abstract I*Repository interfaces
│   ├── usecases/        ← Atomic use cases per feature
│   ├── containers/      ← Use case aggregators (AuthUseCases, etc.)
│   └── core/            ← AppFailures (sealed), value objects
├── infrastructure/
│   ├── datasources/     ← Remote (Dio) + Local (ObjectBox)
│   ├── repositories/    ← Concrete repository implementations
│   └── core/            ← Dio interceptors, ObjectBox store setup
├── presentation/
│   ├── features/        ← Cross-cutting state (auth/, app/)
│   ├── views/           ← Screen modules — see View Hierarchy below
│   └── core/            ← navigation/ (AppRoute + AppRouter), shared widgets, theming
└── services/
    └── service_locator.dart  ← All DI registrations
```

---

## 3. Core Domain Entities

### API Entities (`dab_api/lib/src/domain/entities/`)

| Entity | Description |
|---|---|
| `Activity` | Normalized activity event (shared base). Carries `ActivityProvider` metadata. |
| `ActivityProvider` | Sealed hierarchy — discriminated union for provider-specific metadata (Phorge tasks/revisions, GitHub commits, Slack messages) |
| `User` | DAB user — `id`, `email`, `role` (`UserRole`), `groupId`, `isActive`, linked `UserIdentity` records |
| `UserIdentity` | Maps a DAB user to an external account. State tracked via `UserIdentityStatus` (`linked`, `pending`, `failed`). |
| `Group` | Team / organizational group |
| `Session` | Active auth session holding JWT + refresh token |
| `ProviderConfig` | Global config for an external provider (`name`, `baseUrl`, `iconUrl`, `configJson`) |
| `ProviderMetadata` | Metadata about a registered provider connector |

### App Entities (`dab_app/lib/domain/entities/`)

Contains API-aligned entities plus client-only domain models (for example `ActivitySearchQuery`, `ActivityCategory`, `SprintContext`, and `AppSettings`). ObjectBox records for cache/storage remain in the Infrastructure layer.

---

## 4. Cross-Package Data Flow

```
External Provider (Phorge, GitHub, Slack, …)
        │
        ▼
 IActivitySource (Infrastructure)
  ── fetches raw DTOs via HTTP ──
        │
        ▼
 IActivityMapper (Domain)
  ── maps DTOs to Activity entity ──
        │
        ▼
 ConnectorRegistry (Application)
  ── fan-out across all registered providers ──
        │
        ▼
 SQL ActivityRepository (Infrastructure)
  ── persists Activity + provider child table (TBT) ──
        │
        ├─► Redis (Vegas version clock + materialized feeds)
        │
        └─► WebSocket push ──► DAB App
        │
        └─► (on user sync) IdentityDiscoveryService reconciliation
                                   │
                                   ▼
                          VegasInterceptor (Dio)
                           ── injects X-Sync-Token ──
                                   │
                                   ▼
                          ObjectBox (local cache)
                                   │
                                   ▼
                          BLoC / Cubit ──► Flutter UI
```

---

## 5. Key Shared Patterns

### Source / Mapper Pattern

```
IActivitySource  (Infrastructure)  ─── fetches raw DTOs ──►  IActivityMapper (Domain)
                                                                       │
                                                              maps to Activity entity
```

- `IActivitySource`: Handles raw I/O, auth, rate-limiting — no business logic.
- `IActivityMapper`: Pure transformation business rules — no I/O.
- `ConnectorRegistry`: Pairs one Source with one Mapper at boot via `service_locator.dart`.

### Vegas Sync Pattern

Every data mutation increments an atomic Redis counter (`INCR dab:version`).  
Clients embed the last seen `syncToken` in the `X-Sync-Token` request header on Vegas-enabled routes.  
The **Vegas Middleware** returns `304 Not Modified` when the token is current, bypassing the DB entirely.

```
Client request  ──►  Vegas Middleware
                          │
              ┌───────────┴───────────┐
              │ token fresh?          │ token stale?
              ▼                       ▼
        304 Not Modified       full DB query + response
```

### Table-Per-Type (TBT) Persistence

```
activities               ← shared fields (id, userId, title, content, createdAt)
activity_phorge          ← Phorge-specific metadata (taskPhid, revisionId, tags)
activity_github_commit   ← GitHub commit metadata (repo, branch)
activity_slack_message   ← Slack message metadata (workspace/channel/thread/message ids)
```

- Child tables reference `activities.id` with `CASCADE DELETE`.
- Hydration uses `leftOuterJoin` in SQL repositories.
- Never use JSON blob columns as a substitute for proper TBT columns.

Provider participation is identity-driven: connectors execute only for DAB users
with a linked `user_identities` row for that provider id (`status: linked`).
This keeps onboarding provider-agnostic (Jira-only / GitHub-only / Phorge-only
tenants).

### Envelope Response Pattern

Envelope responses are used on the data endpoints that expose structured `data/meta` payloads:

```json
{
  "data": { ... },
  "meta": {
    "syncToken": 42,
    "timestamp": "2026-04-08T00:00:00Z"
  }
}
```

When `meta.syncToken` is present, the client `VegasInterceptor` persists it locally.

---

## 6. API Controllers Reference

| Controller | Base Path | Responsibility |
|---|---|---|
| `ActivityController` | `/activities` | Fetch, search, paginate activities |
| `AdminController` | `/admin` | User management + identity review/link/resolve |
| `AuthController` | `/auth` | Register, login, refresh token |
| `GroupController` | `/groups` | Group management |
| `HealthController` | `/health` | API + DB health checks |
| `MetadataController` | `/metadata` | Provider configs, status, registry metadata, admin config test/save |
| `UserController` | `/users` | User profile, identity linking |

---

## 7. Dependency Injection

**API (GetIt):** All registrations live in `service_locator.dart`. Use `sl<T>()` to resolve.  
**App (custom ServiceLocator):** All registrations in `lib/services/service_locator.dart`.

Never instantiate services, repositories, or use cases manually inside business logic or controllers.
