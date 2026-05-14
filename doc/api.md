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
        A_Serv[LogActivity + Fetch/Search UseCases]
    end
    subgraph "Domain Layer"
        D_Ext[Payload → Activity (OnXDto.toActivities)]
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
    A_Reg -->|resolves mapping| D_Ext
    A_Reg -->|resolves| I_Prov
    D_Ext -->|transforms| D_Ent
    A_Serv --> D_Repo
    I_Repo -->|implements| D_Repo
    I_Repo --> I_DB
    I_Prov -->|reads from| Ext[External APIs]
```

---

## Layer Details

### 1. Domain Layer (`lib/src/domain/`)

The innermost layer. **No imports from Infrastructure or Application.**

- **Entities:** Pure data classes using `dart_mappable`. Current entities:
  - `Activity` — normalized event with `ActivityProvider` sealed metadata
  - `ActivityProvider` — sealed hierarchy for provider-specific payloads
  - `User` — DAB user with role (`admin`, `manager`, `standard`), group, and active state
  - `UserIdentity` — Maps a DAB user to an external platform. States: `linked`, `pending`, `failed`.
  - `Group` — organizational grouping
  - `Session` — active auth session (JWT + refresh token)
  - `ProviderConfig` — external tool configuration (`name`, `baseUrl`, `iconUrl`, `configJson`)
  - `ProviderMetadata` — registered connector metadata

- **`entities/provider_payloads/`:** Provider-native shapes (e.g. `GitHubCommitDto`, `SlackMessageDto`, `PhorgeTaskBundleDto`). Sources return these; **`extension OnDto.toActivities(...)`** maps them to `Activity` — all without importing Infrastructure.

- **`ports/`:** Cross-layer contracts implemented in Infrastructure (e.g. `IActivitySource<T>` for connector fetch, `IDiscoverySource` for identity lookups).
- **`gataways/`:** Per-provider outbound polling contracts. **`AbsIPhorgeGateway`** returns Conduit-decoded rows (`PhorgeUserDto` for active directory users, `PhorgeProjectDto` for sprint-scoped tags, bundled task + transactions, revisions); implementations orchestrate paging and multi-call flows but expose API-shaped types only—not secondary projections. GitHub and Slack gateways mirror their polled payloads the same way.

- **DTO mapping extensions:** Business rules for transforming each provider payload type into a `DAB Activity`.

- **Repository Interfaces:** Abstract contracts prefixed with `I` (e.g., `IActivityRepository`). Return `Either<Failure, T>` via `fpdart`. **`IUserRepository.getUser`** returns **`NotFoundFailure`** when the row is absent and **`DatabaseFailure`** on query errors.

---

### 2. Infrastructure Layer (`lib/src/infrastructure/`)

**Key constraint:** Read-only. DAB is an observer. Providers must **never** implement mutation endpoints.

- **`IActivitySource` implementations (`sources/`):** Implement the domain port `IActivitySource<T>`; return `provider_payloads` types — never full domain `Activity` entities (mapping stays on Domain DTO extensions).

- **`protocols/`:** Reusable outbound HTTP wire adapters (`ConduitProtocol`, `JsonRestProtocol`, `GraphqlProtocol`, `SlackWebProtocol`). Sources decide *what* to pull for DAB; protocols own *how* requests are encoded (Conduit form bodies, JSON REST, GraphQL envelope, Slack `ok`). Failures surface as `ProtocolException` subtypes — **no raw response bodies** on exceptions.

- **`repositories/`:** Concrete SQL implementations using Drift + PostgreSQL. Implement Table-Per-Type polymorphism via `leftOuterJoin`.

- **`database/`:** Drift schema definitions, DAOs, and `MigrationStrategy`. Never hand-edit generated `*.g.dart` files.

- **`dtos/`:** Leftover **wire** parse types (e.g. Phorge Conduit JSON helpers). **Mapper contract types** live under **`domain/entities/provider_payloads/`**.

- **`security/`:** JWT signing/verification (via `dart_jsonwebtoken`), bcrypt password hashing. All secrets come from `Config`.

- **`config/`:** `Config` — loads env vars at startup. Single source for all configuration.

- **Relative URL Strategy:** Providers generate relative paths (e.g., `/T123`). The DAB app resolves full URLs using `baseUrl` from `ProviderConfig`.

---

### 3. Application Layer (`lib/src/application/`)

Orchestrates use cases. Use cases return `Either<Failure, T>` where failures matter; controllers map `Left` to HTTP status. **`UnifiedActivityFetcher`** logs per-connector errors via an injected log callback (e.g. `LoggingService.record`) without importing infrastructure types.

- **`ConnectorRegistry`:** Holds **`TypedConnectorPair<T>`** entries. **`register_activity_connectors.dart`** is the single bootstrap function that registers every source + mapper pair.

- **`UnifiedActivityFetcher`:** Orchestrates **parallel fetching** across all registered providers. If **`getConfigs()`** fails, emits a **WARNING** log and skips all connectors (empty active set). Per-connector failures still log WARNING and return an empty slice for that provider only.

- **`LogActivity` use case:** Persists activity, increments Vegas version in Redis, and broadcasts over WebSocket via `PresenceService`.
- **Activity query use cases:** `GetRecentActivities`, `SearchActivities`, and `FetchRemoteActivities`.
- **`GetLiveActivities`:** Serves **`GET /activities/live`** from Redis lists only (no Postgres). Explorer historical browsing uses **`SearchActivities`** (**`GET /activities/search`**), not Redis.
- **Auth workflows:** Implemented through `AuthUseCases` (`RegisterUser`, `AuthenticateUser`, `RefreshUserToken`, etc.).

---

### 4. Presentation Layer (`lib/src/presentation/`)

Thin entry points only. No business logic.

#### Controllers

| Controller | Path | Key Responsibilities |
|---|---|---|
| `ActivityController` | `/activities*`, `/ws`, `/integrations/slack/events` | Historical feed (`/activities`), **dashboard `GET /activities/live`** is **Redis-backed only** (optional `?includeArchived=true`; no Postgres). Live-feed triage (`POST /activities/live/:id/archive`, `POST /activities/live/:id/unarchive`), Slack Events webhook (`/integrations/slack/events`), historical **`GET /activities/search`** (UnifiedActivityFetcher polling only — no Postgres merge), WebSocket `/ws`. Archived live entries stay in Redis (nightly purge). `ActivityPurgeScheduler`. |
| `AdminController` | `/admin/*` | Identity list/summary, manual link, resolve workflow, admin user role management |
| `AuthController` | `/auth/*` | Register, login, refresh token |
| `GroupController` | `/groups/*` | Group management |
| `HealthController` | `GET /health`, `/health/db` | Pulse check, DB connectivity |
| `MetadataController` | `/metadata/*`, `/admin/configs*` | Public bootstrap status/configs, provider metadata list, provider capability matrix (`/metadata/capabilities`), admin provider config save/test |
| `UserController` | `/users/*` | User profile, identity linking |

#### Middleware

- **Vegas Middleware:** Applies only to **`GET /activities`** under the `/activities` mount. Compares client `X-Sync-Token` against Redis version and returns **`304 Not Modified`** when unchanged. **`GET /activities/search`** and **`GET /activities/live`** skip this gate.
- **JWT Middleware:** Validates signed tokens on all protected sub-routes.
- **WebSocket auth guard:** `/ws` is protected by JWT middleware and uses request-context identity for scoped delivery.
- **Domain Lockdown:** Enforced by registration use cases (`RegisterUser` / bootstrap lock rules), not by HTTP middleware.
- **Admin middleware:** After bootstrap, authorizes `/admin/*` using the **database** user role (not only JWT) so promotions apply immediately.
- **`GET /metadata/status` `isSystemConfigured`:** `true` when there is at least one admin **and** at least one **active** provider config.
- **`GET /activities/search` query `startDate` / `endDate`:** Bare `YYYY-MM-DD` (no TZ) is parsed as UTC midnight; identical start/end expands one UTC day (`ActivityController`). **`dab_app`** sends `YYYY-MM-DD` derived from the **device local calendar** (`ActivitySearchQueryMapper.toRemoteQueryParameters`), matching Explorer date controls and Insight presets so the inferred UTC window aligns with client-side filtering. **`authoredOnly`:** **`dab_app`** Explorer keeps **`true`** for personal-scope browsing; **Insights** uses **`false`** for team analytics so connectors can apply broader retrieval (e.g. Phorge sprint/global paths).

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
| Application | `ConnectorRegistry`, `UnifiedActivityFetcher`, activity/auth use-case containers |
| Services | `PresenceService`, `LoggingService`, `IdentityDiscoveryService` |
| Repositories | `ActivityRepository`, `AuthRepository`, `UserRepository`, `ProviderConfigRepository` |
| Protocols | `ConduitProtocol`, `JsonRestProtocol`, `GraphqlProtocol`, `SlackWebProtocol` (`Http*` implementations, singletons) |

**Rule:** `singleton` for stateful services, `factory` for stateless use cases.

---

## Provider Roadmap

| Provider | Status | Protocol |
|---|---|---|
| Phorge | ✅ Active | Conduit REST API |
| GitHub | ✅ Active (Commits v1) | REST (+ push webhook) |
| Slack | ✅ Active (Messages v1) | Slack Web API |
| Jira | 🧪 Scaffolded | REST |
| Linear | 🧪 Scaffolded | GraphQL |
| Teams | 🧪 Scaffolded | REST |
| Discord | 🧪 Scaffolded | REST |
| GitLab | 🔜 Planned | REST |
| Bitbucket | 🔜 Planned | REST |

GitHub v1 ingestion is commits-only and uses provider-linked identities from
`user_identities` (`provider_id: github`) to scope attribution. Saved provider
settings may include **`webhookSecret`** (matching the secret configured on the
repository webhook in GitHub) for **`POST /integrations/github/webhook`**. The
configured repo allow-list (`owner`/`repo`, `repos` list — same shaping as polling)
gates which repositories may deliver push events into DAB; the unified fetcher continues to backfill commits via polling when configured.

Bootstrap remains local-first for the first admin; teams can onboard with any provider
afterward (no Phorge prerequisite).

Slack v1 ingestion is message-only and strictly identity-based (`provider_id:
slack`). Connector execution and attribution require linked Slack user IDs in
`user_identities.external_id`; there is no email fallback during mapping. The
admin test-connection endpoint validates Slack credentials using `auth.test`,
and expected settings are `botToken` plus optional `channels` and `apiBaseUrl`.

Provider live-ingestion capabilities are exposed via `GET /metadata/capabilities`
to support dashboard strategy selection (webhook/websocket first, polling
fallback).

Slack true-live ingestion is handled via `POST /integrations/slack/events`
(Events API webhook). The endpoint validates Slack signatures, acknowledges
quickly, and processes event callbacks asynchronously into DB + Redis live keys
and scoped WebSocket delivery. Message routing is mention-targeted: activities
are created per recipient when a message includes direct user mentions (`<@U...>`),
broadcast mentions (`@all`, `<!channel>`, `<!here>`, `<!everyone>`), or Slack
user-group mention tokens (`<!subteam^...>`). Messages without target mentions
are ignored for live-feed ingestion.

For local webhook testing, generate signature headers from the exact raw request
body using:
`./scripts/generate_slack_signature.sh "$SLACK_SIGNING_SECRET" /path/to/body.json`

GitHub sends the JSON body as either **raw JSON** (`Content-Type:
application/json`) or **URL-encoded** (`application/x-www-form-urlencoded` with a
`payload` form field). Both are accepted; HMAC is always over the **exact raw
request bytes** GitHub posts.
configured allow-list fork into one activity per commit whose webhook author
login matches a **linked** `user_identities` row (`provider_id: github`), then the
pipeline matches Slack: Postgres + Redis **`fanOutActivity`** +
**`PresenceService`** (`ACTIVITY_RECEIVED`). **`ping`** is acknowledged without
persisting commits. Other event types return success but perform no ingestion.

---

## Development Commands

| Action | Command |
|---|---|
| Analyze | `dart analyze` |
| Run tests | `dart test` |
| Start server | `dart run bin/dab_api.dart` |
| Start via Docker | `cd dab_api && docker-compose up -d` |
| Regenerate code | `dart run build_runner build --delete-conflicting-outputs` |
| Health check | `curl http://localhost:9080/health` |
