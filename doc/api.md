# DAB API — Backend Architecture

> **Linear source:** [Dab Api](https://linear.app/dev-activity-board/document/dab-api-8608282c089c) · Last synced: 2026-04-08  
> **Package:** `dab_api/` · Runtime: Dart + Relic · DB: PostgreSQL (Drift) · Cache: Redis · SDK: `^3.9.2`

---

## Architecture Schema

```mermaid
graph TD
    subgraph "Presentation Layer"
        P_Cont[Controllers]
        P_Mid[Middleware]
    end
    subgraph "Application Layer"
        A_Sync[UnifiedActivityFetcher]
        A_Reg[ConnectorRegistry]
        A_Serv[ActivityService]
    end
    subgraph "Domain Layer"
        D_Map[IActivityMapper]
        D_Ent[Entities]
        D_Repo[Repository Interfaces]
    end
    subgraph "Infrastructure Layer"
        I_Prov[IActivitySource]
        I_Repo[Repository Impls]
        I_DB[Database]
    end
    P_Cont --> A_Serv
    A_Serv --> A_Sync
    A_Sync --> A_Reg
    A_Reg -->|resolves| D_Map
    A_Reg -->|resolves| I_Prov
    D_Map -->|transforms| D_Ent
    A_Serv --> D_Repo
    I_Repo -->|implements| D_Repo
    I_Repo --> I_DB
    I_Prov -->|reads from| Ext[External APIs]
```

---

## Layer Details

### 1. Domain Layer (`lib/src/domain/`)

The innermost layer. **Zero imports from Infrastructure or Application.**

- **Entities:** Pure data classes using `dart_mappable`. Current entities:
  - `Activity` — normalized event with `ActivityProvider` sealed metadata
  - `ActivityProvider` — sealed hierarchy for provider-specific payloads
  - `User` — DAB user with role (`admin`, `manager`, `standard`), group, and active state
  - `UserIdentity` — Maps a DAB user to an external platform. States: `linked`, `pending`, `failed`.
  - `Group` — organizational grouping
  - `Session` — active auth session (JWT + refresh token)
  - `ProviderConfig` — external tool configuration (`name`, `baseUrl`, `iconUrl`, `configJson`)
  - `ProviderMetadata` — registered connector metadata

- **Mappers (`IActivityMapper`):** Define the business rules for transforming provider-specific DTOs into a `DAB Activity`. Mappers live in Domain because they encode business meaning (e.g., "a Phorge transaction of type COMMENT becomes an Activity of type comment").

- **Repository Interfaces:** Abstract contracts prefixed with `I` (e.g., `IActivityRepository`). Return `Either<Failure, T>` via `fpdart`.

---

### 2. Infrastructure Layer (`lib/src/infrastructure/`)

**Key constraint:** Read-only. DAB is an observer. Providers must **never** implement mutation endpoints.

- **`IActivitySource` implementations (`connectors/`):** Specialized clients for each provider. Handle raw I/O, auth, rate-limiting, protocol specifics (e.g., Conduit API for Phorge). Each source returns provider-specific DTOs — never domain entities.

- **`sources/`:** Lower-level data fetchers used by sources.

- **`repositories/`:** Concrete SQL implementations using Drift + PostgreSQL. Implement Table-Per-Type polymorphism via `leftOuterJoin`.

- **`database/`:** Drift schema definitions, DAOs, and `MigrationStrategy`. Never hand-edit generated `*.g.dart` files.

- **`dtos/`:** Provider-specific Data Transfer Objects. Never leak outside Infrastructure.

- **`security/`:** JWT signing/verification (via `dart_jsonwebtoken`), bcrypt password hashing. All secrets come from `AppConfig`.

- **`config/`:** `AppConfig` — loads env vars at startup. Single source for all configuration.

- **Relative URL Strategy:** Providers generate relative paths (e.g., `/T123`). The DAB app resolves full URLs using `baseUrl` from `ProviderConfig`.

---

### 3. Application Layer (`lib/src/application/`)

Orchestrates use cases and coordinates Domain + Infrastructure without coupling to either.

- **`ConnectorRegistry`:** Single source of truth for all registered provider connectors. Pairs each `IActivitySource` with its corresponding `IActivityMapper` at boot.

- **`UnifiedActivityFetcher`:** Orchestrates **parallel fetching** across all registered providers. Aggregates results into a unified stream.

- **`ActivityService`:** Coordinates persistence, cache invalidation, WebSocket fan-out, and Vegas token increment after each ingestion cycle.

- **`AuthService`:** Handles auth workflows (login, token validation, refresh, logout).

---

### 4. Presentation Layer (`lib/src/presentation/`)

Thin entry points only. No business logic.

#### Controllers

| Controller | Path | Key Responsibilities |
|---|---|---|
| `ActivityController` | `GET /activities` | Paginated activity feed, user filtering |
| `AdminController` | `/admin/*` | Bootstrap lock, user management, provider config CRUD, **Identity Resolution (`POST /identities/resolve`)** |
| `AuthController` | `/auth/*` | Login, logout, refresh token |
| `GroupController` | `/groups/*` | Group management |
| `HealthController` | `GET /health`, `/health/db` | Pulse check, DB connectivity |
| `MetadataController` | `/metadata/*` | Provider configs list, connector metadata |
| `UserController` | `/users/*` | User profile, identity linking |

#### Middleware

- **Vegas Middleware:** Compares client `X-Sync-Token` against Redis version. Returns `304 Not Modified` on fresh token.
- **JWT Middleware:** Validates signed tokens on all protected sub-routes.
- **Domain Lockdown:** Rejects registrations outside `DAB_ALLOWED_DOMAIN`.

---

## Design Philosophy: Modular Provider Architecture

| Aspect | Modular (Current) | Monocore Connector (Rejected) |
|---|---|---|
| **Extensibility** | High — adding GitHub takes minutes | Low — hard-coded per provider |
| **Domain Purity** | High — mappers live in Domain | Low — logic bleeds into Infrastructure |
| **Parallelism** | Multi-source fan-out (concurrent) | Serial polling |
| **Maintainability** | Single-responsibility classes | God objects |

---

## Dependency Injection (GetIt)

All registrations in `lib/src/service_locator.dart`. Use `sl<T>()` to resolve.

| Category | Key Registrations |
|---|---|
| Application | `ConnectorRegistry`, `UnifiedActivityFetcher` |
| Services | `ActivityService`, `AuthService`, `PresenceService`, `LoggingService` |
| Repositories | `SqlActivityRepository`, `SqlAuthRepository` |

**Rule:** `singleton` for stateful services, `factory` for stateless use cases.

---

## Provider Roadmap

| Provider | Status | Protocol |
|---|---|---|
| Phorge | ✅ Active | Conduit REST API |
| GitHub | 🔜 Planned | REST + GraphQL |
| GitLab | 🔜 Planned | REST |
| Bitbucket | 🔜 Planned | REST |

---

## Development Commands

| Action | Command |
|---|---|
| Analyze | `dart analyze` |
| Run tests | `dart test` |
| Start server | `dart run bin/server.dart` |
| Start via Docker | `docker-compose up -d` |
| Regenerate code | `dart run build_runner build --delete-conflicting-outputs` |
| Health check | `curl http://localhost:8080/health` |
