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
| **Domain** | Pure business entities, interfaces, mapping extensions | **Zero** external or cross-layer imports |
| **Application** | Use cases, service orchestration | May import Domain; avoids importing Infrastructure (composition root / use-case specifics may still reference infrastructure types sparingly) |
| **Infrastructure** | DB, HTTP, caches, protocols | Implements Domain contracts; never leaks upward |
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
│   ├── entities/        ← Core model
│   ├── dtos/            ← Provider DTO shapes + extension OnDto → `toActivities`
│   ├── contracts/
│   │   ├── ports/       ← I/O seams: `IActivitySource`, `ILiveFeedStore`, `AbsIPhorgeGateway`, …
│   │   └── repositories/← Abstract Postgres persistence interfaces (`AbsI*`)
│   └── core/            ← Failures, org calendar, watch-list parsers, OAuth catalogs
├── application/
│   ├── usecases/        ← Single-responsibility use cases
│   ├── services/        ← UnifiedActivityFetcher, ConnectorRegistry, register_activity_connectors, LiveIngestPersister, …
│   └── containers/      ← Grouped use case aggregators
├── infrastructure/
│   ├── sources/         ← Provider I/O (IActivitySource, catalogs, Discord Gateway)
│   ├── protocols/       ← Outbound wire adapters (Conduit, JSON REST, GraphQL, Slack Web API)
│   ├── persistence/     ← postgres/ (Drift), redis/, repositories/ (AbsI* impls)
│   └── core/            ← config/, security/, http/, adapters/, realtime/, logging/
└── presentation/
    ├── controllers/     ← Relic HTTP controllers (8 controllers: activity, oauth, admin, auth, group, health, metadata, user)
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
| `Activity` | Normalized activity event (shared base). Carries `ActivityProvider` metadata. Live ingest sets `userId` to the **inbox recipient** and optional `senderUserId` to the linked actor. Includes a live-feed-only `archived` flag (default `false`) used by the Dashboard triage workflow, and `inboxLane` (`directed` \| `follow`) so Dashboard can show two independent rows when a user is both a directed recipient and a follower. Missing/legacy JSON is treated as directed. |
| `ActivityProvider` | Sealed hierarchy — discriminated union for provider-specific metadata (Phorge tasks/revisions, GitHub/GitLab/Bitbucket commits, Slack/Discord messages, Jira/Linear issues, …) |
| `User` | DAB user — `id`, `email`, `role` (`UserRole`), optional `linkedProviderIds` (non-secret Directory hint) |
| `UserIdentity` | Maps a DAB user to an external account. State tracked via `UserIdentityStatus` (`linked`, `pending`, `failed`). Self-connect whoami writes `linked` immediately. |
| `UserProviderCredential` | Per-user provider secrets (OAuth access/refresh tokens or PAT). Encrypted at rest. Fetch key, not a visibility ACL. Jira/Linear OAuth access tokens are refreshed from the stored refresh token when expired. |
| `JiraProject` / `JiraProjectWatchList` | Jira Cloud projects visible to a connected user, plus instance `projectKeys` used as the Explorer ingest allow-list (not Dashboard targeting). |
| `LinearTeam` / `LinearTeamWatchList` | Linear teams visible to a connected user, plus instance `teamKeys` used as the Explorer ingest allow-list. |
| `GitWatchList` | Per-user git watches (`watchedRepos` / `watchedBranches` on the user credential). Instance `repos` / `projects` remain the Admin ingest allow-list. Watched branches also feed Explorer git polling refs. |
| `GitBranchList` | Unique branch names listed from GitHub/GitLab/Bitbucket for the Settings searchable watch picker. |
| `ActivityFollow` | Per-user Dashboard object Follow pin (`providerId` + `objectKey`, plus optional `title` / `url` snapshot) for Phorge, Jira, Linear, Slack, and Discord. Git stays on `GitWatchList`. |
| `Group` | Team / organizational group |
| `Session` | Active auth session holding JWT + refresh token |
| `ProviderConfig` | Global config for an external provider (`name`, `baseUrl`, `iconUrl`, `configJson`) |
| `ProviderMetadata` | Metadata about a registered provider connector |

### App Entities (`dab_app/lib/domain/entities/`)

Contains API-aligned entities plus client-only domain models (for example `ActivitySearchQuery`, `ActivityCategory`, `SprintContext`, and `AppSettings`).
`AppSettings` stores persisted user preferences including `appThemeVariant` (`light`, branded `dab`, or grayscale-dark `greyscale` with neutral surfaces and the same DAB indigo primary as `dab`) and optional `localeCode`. An `islandBarSelections` map remains on the ObjectBox record (no schema migration) but is unused in the UI — home branches use per-view toolbars rather than those stored checkboxes.

The Dashboard additionally introduces:

| Entity | Description |
|---|---|
| `ActivityLiveEvent` | Sealed discriminated union over the WS live stream — `ActivityReceivedEvent`, `ActivityArchivedEvent`, `ActivityUnarchivedEvent`. |

ObjectBox records for cache/storage remain in the Infrastructure layer.

---

## 4. Cross-Package Data Flow

```
External Provider (Phorge, GitHub, Slack, …)
        │
        ▼
 IActivitySource (Infrastructure)
  ── fetches raw DTOs via HTTP ──
  ── ICredentialResolver: user OAuth/PAT overlay, else org ProviderConfig, else skip
  ── Slack/Discord: org bot token only ──
        │
        ▼
 DTO extensions (Domain, on `domain/dtos`)
  ── toActivities(...) maps rows to Activity entity ──
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
                          Riverpod notifiers ──► Flutter UI
```

### Live push ingestion (Dashboard)

The polling flow above powers Explorer (historical backfill). Dashboard is a
**personal inbound inbox**: live ingest fans out one row per recipient
(`Activity.userId`), records the linked actor as `senderUserId`, and delivers
`ACTIVITY_RECEIVED` with `broadcastToUser(recipient)`. The app hydrates
`GET /activities/live` without `scope=global`. Archive flags live natively on
`activities:user:{id}`. `ActivityLivePollScheduler` does **not** refill the
inbox with authored poll rows; inbound rows come from webhooks / Gateway.
Identity linking is required — unlinked mentions are dropped. Followable
providers (Phorge, Jira, Linear, Slack, Discord) emit a **second** live row
for users who Follow that object key (`inboxLane: follow`, id seed suffixed
`|follow`) instead of unioning followers into the directed recipient set.
A user who is mentioned **and** Follows the object gets two inbox items with
independent archive flags. Untagged later updates and the follower's own
actions land on the Follow pane until Unfollow. Git watches stay directed
only. Standing ownership or channel membership is not automatic.
Jira issue
activities include `updatedAt` in their id so a status move is a new live
event; Jira comments use a stable `jira|{host}|{issueKey}|comment|{commentId}`
id (plus recipient on fan-out).

```
Provider push (webhook / Gateway WebSocket)
        │
        ▼
 ActivityController (Presentation)
  ── IWebhookRequestAuthenticator, fast ACK ──
        │
        ▼
 Ingest use case (Application)
  ── Redis dedup + business filter + DTO mapping ──
        │
        ▼
 SQL ActivityRepository ──► LiveIngestPersister (Redis fan-out + IPresenceBroadcaster ACTIVITY_RECEIVED)
```

Every provider has a push path: webhooks for GitHub, GitLab, Bitbucket, Phorge
(Herald), Jira, Linear, and Slack (Events API); Discord uses the outbound
`DiscordGatewayService` WebSocket client since Discord has no message webhooks.
Insights with `authoredOnly=false` uses an org token when present; otherwise
sources union per-user authored fetches (work not attributed to a connected
identity is omitted).

---

## 5. Key Shared Patterns

### Source / payload extension pattern

```
IActivitySource  (Infrastructure)  ─── fetches raw DTOs ──►  extension OnXDto → toActivities [Domain]
                                                                              │
                                                                     maps to Activity entity
```

- `IActivitySource`: Handles raw I/O, auth, rate-limiting — no business logic.
- `extension OnXDto`: Pure transformation (`toActivities`) — no I/O.
- `TypedConnectorPair` (+ `providerId`): Registered in `register_activity_connectors` at composition root; binds a Source row type to mapping + config id filtering. `ConnectorRegistry` stores the type-erased `RegisteredConnectorPair` so fetch iteration does not widen mappers to `dynamic` (avoids Dart contravariance runtime errors).

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
activities               ← shared fields (id, userId recipient, senderUserId, title, content, createdAt)
activity_phorge            ← Phorge-specific metadata (taskPhid, revisionId, tags)
activity_github_commit     ← GitHub commit metadata (repo, branch)
activity_gitlab_commit     ← GitLab commit metadata (project, branch)
activity_bitbucket_commit  ← Bitbucket commit metadata (repo, branch)
activity_slack_message     ← Slack message metadata (workspace/channel/thread/message ids)
activity_discord_message   ← Discord message metadata (guild/channel/message ids)
activity_jira_issue        ← Jira issue metadata (issue key, project key, status snapshot)
activity_linear_issue      ← Linear issue metadata (identifier, team key, status snapshot)
```

The orphaned `activity_teams_message` table remains on installs upgraded from
schema ≤ 15 (Teams support was retired in v16); it is no longer mapped by Drift.

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
| `ActivityController` | `/activities`, `/ws`, `/integrations/slack/events`, `/integrations/{github,phorge,jira,linear,gitlab,bitbucket}/webhook` | Fetch historical feed, fetch **Redis-only** live feed (`/activities/live`, user-scoped inbound inbox), receive provider push webhooks (Slack Events, GitHub/GitLab/Bitbucket push, Phorge Herald, Jira, Linear), search activities (**polling-only** via `GET /activities/search` for Explorer; no Postgres merge), and serve authenticated realtime stream |
| `AdminController` | `/admin` | User management (creation + roles) + identity review/link/resolve |
| `AuthController` | `/auth` | Register, login, refresh token |
| `GroupController` | `/groups` | Group management |
| `HealthController` | `/health` | API + DB health checks |
| `MetadataController` | `/metadata`, `/admin/system-settings` | Provider configs, status, provider capability metadata, admin config test/save, system settings (domain validation toggle + allowed domain) |
| `UserController` | `/users` | User profile, identity linking, self-serve credentials, git watches, git branch listing, and Dashboard object Follow pins (`/users/me/follows`) |

---

## 7. Dependency Injection

**API (GetIt):** All registrations live in `service_locator.dart`. Use `sl<T>()` to resolve.  
**App (custom ServiceLocator):** All registrations in `lib/services/service_locator.dart`.

Never instantiate services, repositories, or use cases manually inside business logic or controllers.
