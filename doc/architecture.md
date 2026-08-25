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
│   │   ├── ports/       ← I/O seams: `AbsIActivityPort`, `AbsILiveFeedStore`, `AbsIPhorgeFacade`, …
│   │   └── repositories/← Abstract Postgres persistence interfaces (`AbsI*`)
│   └── core/            ← Failures, org calendar, watch-list parsers, OAuth catalogs
├── application/
│   ├── usecases/        ← Single-responsibility use cases
│   ├── services/        ← UnifiedActivityFetcher, ConnectorRegistry, register_activity_connectors, LiveIngestPersister, …
│   └── containers/      ← Grouped use case aggregators
├── infrastructure/
│   ├── sources/         ← Provider I/O (`*_source`, `*_catalog`, `DiscordGatewayClient`, `PhorgeFacade`)
│   ├── protocols/       ← Outbound wire adapters (Conduit, JSON REST, GraphQL, Slack Web API)
│   ├── persistence/     ← postgres/ (Drift), redis/, repositories/ (AbsI* impls)
│   └── core/            ← config/, security/, http/, adapters/, realtime/, logging/
└── presentation/
    ├── controllers/     ← Relic HTTP controllers (8): Activity, Oauth, Admin, Auth, Group, Health, Metadata, User
    └── middlewares/     ← Global error handler, request logger, JWT, Vegas, Admin role
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
| `Activity` | Normalized event. Live ingest sets `userId` to the **inbox recipient** and optional `senderUserId` to the linked actor. `archived` (default `false`) and `inboxLane` (`directed` \| `follow`) are **live-feed JSON fields** stored in Redis, not Postgres columns. Missing/legacy JSON is treated as directed. |
| `ActivityProvider` | Sealed hierarchy — Phorge tasks/revisions, GitHub/GitLab/Bitbucket commits, Slack/Discord messages, Jira/Linear issues, Figma files |
| `User` | DAB user — `id`, `name`, `email`, `role` (`UserRole`), optional legacy `phorgePhid` / `phorgeUsername`. |
| `UserIdentity` | Maps a DAB user to an external account. `UserIdentityStatus`: `linked`, `pending`, `failed`. Self-connect whoami writes `linked` immediately. |
| `UserProviderCredential` | Per-user provider secrets (OAuth access/refresh or PAT). Encrypted at rest. Fetch key, not a visibility ACL. Jira/Linear OAuth access tokens refresh from the stored refresh token when expired. |
| `UserDeviceToken` | Per-user FCM/APNs registration (`platform` `android` \| `ios`, token). Used for data-only inbox wakes when no WebSocket session exists. |
| `JiraProject` / `JiraProjectWatchList` | Jira Cloud projects visible to a connected user, plus instance `projectKeys` used as the Explorer ingest allow-list (not Dashboard targeting). |
| `LinearTeam` / `LinearTeamWatchList` | Linear teams visible to a connected user, plus instance `teamKeys` used as the Explorer ingest allow-list. |
| `GitWatchList` | Per-user git watches (`watchedRepos` / `watchedBranches` on the user credential). Instance `repos` / `projects` remain the Admin ingest allow-list. Watched branches also feed Explorer git polling refs. |
| `GitBranchList` | Unique branch names listed from GitHub/GitLab/Bitbucket for the Settings searchable watch picker. |
| `FollowCandidate` | One Dashboard Following-picker row (`providerId`, `objectKey`, `title`, optional `url`, `kind` `issue` \| `gitBranch` \| `file`). |
| `ActivityFollow` | Per-user Dashboard object Follow pin (`providerId` + `objectKey`, optional `title` / `url` snapshot) for Phorge, Jira, Linear, Slack, Discord, Figma `file_key`, and a GitHub/GitLab/Bitbucket **repo + branch** (`owner/repo\|branch`). Settings `watchedRepos` / `watchedBranches` stay Directed. |
| `DailyReport` | Personal org-calendar daily report (`userId` + `date` `YYYY-MM-DD`, `includeFollowing`). Notes stay in DAB. |
| `DailyReportLine` | Curated report row: `subjectKey` (provider + object + **occurrence** — commit sha / comment id / message ts, not git Follow `owner/repo\|branch` alone), `included`, `note`, `role` (`directed` \| `authored` \| `both`), snapshot `title` / `url` / `occurredAt` / `providerId`. |
| `FigmaFileMeta` | File name / folder snapshot used when mapping Figma comments and last-edited heartbeats. |
| `SprintContext` | Optional sprint metadata attached to provider payloads (Phorge). |
| `ProviderConnectivityReport` | Admin **Try** result: Core / Live / Polling section statuses. |
| `Group` | Team / organizational group (`GroupType`). Membership is `group_members`. |
| `Session` | Active auth session (JWT + refresh token). |
| `ProviderConfig` | Global config for an external provider (`name`, `baseUrl`, `iconUrl`, `configJson` / `settings`). |
| `ProviderMetadata` | Registered connector metadata for `/metadata/providers`. |

### App Entities (`dab_app/lib/domain/entities/`)

Contains API-aligned entities plus client-only models (`ActivitySearchQuery`, `ActivityCategory`, `SprintContext`, `AppSettings`, `SystemStatus`, `ExplorerCacheClearRequest`, `Presence`, `AuthResponse`, `ActivityFollow`, `FollowCandidate`, `DailyReport`, `DailyReportLine`, git/Jira/Linear watch lists). Client `User` includes `linkedProviderIds` (Directory hint; not a secret).

`AppSettings` stores `appThemeVariant` (`light`, branded `dab`, or grayscale-dark `greyscale`), optional `localeCode`, and `inboxNotificationsEnabled` (default **on** — OS banners for Directed and Following while the desktop window is unfocused). An `islandBarSelections` map remains on the ObjectBox record but is unused — home branches use per-view toolbars.

| Entity | Description |
|---|---|
| `ActivityLiveEvent` | Sealed WS union — `ActivityReceivedEvent`, `ActivityArchivedEvent`, `ActivityUnarchivedEvent`. |

ObjectBox records for cache/storage remain in the Infrastructure layer.

---

## 4. Cross-Package Data Flow

```
External Provider (Phorge, GitHub, Slack, …)
        │
        ▼
 AbsIActivityPort (Domain)
  ── implemented by infrastructure Sources ──
  ── fetches raw DTOs via HTTP ──
  ── AbsICredentialResolver: user OAuth/PAT overlay, else org ProviderConfig, else skip
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

The polling flow above powers Explorer (historical backfill). Figma poll keys
come from Admin **file URLs/keys** and Follow pins — Connect OAuth cannot list
a team. Explorer poll refreshes the Figma user access token before comments
and retries once on HTTP 401. `POST /mock/demo-day` unions typed screenshot
rows into that search path from Redis `demo:search:{userId}:{date}` so Explorer
can render without linked identities or provider HTTP. Dashboard is a
**personal inbound inbox**: live ingest fans out one row per recipient
(`Activity.userId`), records the linked actor as `senderUserId`, and delivers
`ACTIVITY_RECEIVED` with `broadcastToUser(recipient)`. The app hydrates
`GET /activities/live` without `scope=global`. Archive flags live natively on
`activities:user:{id}`. `ActivityLivePollScheduler` does **not** refill the
inbox with authored poll rows; inbound rows come from webhooks / Gateway.
Identity linking is required — unlinked mentions are dropped. Followable
providers (Phorge, Jira, Linear, Slack, Discord, Figma files, and git **repo+branch** pins)
emit a **second** live row
for users who Follow that object key (`inboxLane: follow`, id seed suffixed
`|follow`) instead of unioning followers into the directed recipient set.
A user who is mentioned **and** Follows the object gets two inbox items with
independent archive flags. Untagged later updates and the follower's own
actions land on the Follow pane until Unfollow. Settings git watches stay
Directed; an explicit branch Follow is the only git path onto Following.
Standing ownership or channel membership is not automatic.
Jira issue
activities include `updatedAt` in their id so a status move is a new live
event; Jira comments use a stable `jira|{host}|{issueKey}|comment|{commentId}`
id (plus recipient on fan-out).

```
Provider push (webhook / Gateway WebSocket)
        │
        ▼
 ActivityController (Presentation)
  ── AbsIWebhookRequestAuthenticator, fast ACK ──
        │
        ▼
 Ingest use case (Application)
  ── Redis dedup + business filter + DTO mapping ──
        │
        ▼
 SQL ActivityRepository ──► LiveIngestPersister (Redis fan-out + AbsIPresenceBroadcaster ACTIVITY_RECEIVED)
```

Every provider has a push path: webhooks for GitHub, GitLab, Bitbucket, Phorge
(Herald), Jira, Linear, Figma (JSON passcode), and Slack (Events API); Discord uses the outbound
`DiscordGatewayClient` WebSocket client since Discord has no message webhooks.
Insights with `authoredOnly=false` uses an org token when present; otherwise
Sources union per-user authored fetches (work not attributed to a connected
identity is omitted). `ActivityLivePollScheduler` is started at boot for DI
stability; it does **not** publish authored poll rows into the live inbox.

---

## 5. Key Shared Patterns

### Port / Source / DTO extension

```
AbsIActivityPort (Domain)  ← implemented by Sources (Infrastructure) ─── fetches raw DTOs ──►  extension OnXDto → toActivities [Domain]
                                                                              │
                                                                     maps to Activity entity
```

- **`AbsIActivityPort`:** Domain interface for provider fetch. Infrastructure **Sources** handle raw I/O, auth, rate-limiting — no business mapping.
- **`extension OnXDto`:** Pure `toActivities` — no I/O.
- **`TypedConnectorPair` (+ `providerId`):** Registered in `register_activity_connectors` at composition root. `ConnectorRegistry` stores type-erased `RegisteredConnectorPair` so fetch iteration does not widen mappers to `dynamic`.

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
activities               ← shared fields (id, userId recipient, senderUserId, title, content, createdAt). `archived` and `inboxLane` are **not** SQL columns; they live on Redis live-feed JSON.
activity_phorge            ← Phorge-specific metadata (taskPhid, revisionId, tags)
activity_github_commit     ← GitHub commit metadata (repo, branch)
activity_gitlab_commit     ← GitLab commit metadata (project, branch)
activity_bitbucket_commit  ← Bitbucket commit metadata (repo, branch)
activity_slack_message     ← Slack message metadata (workspace/channel/thread/message ids)
activity_discord_message   ← Discord message metadata (guild/channel/message ids)
activity_jira_issue        ← Jira issue metadata (issue key, project key, status snapshot)
activity_linear_issue      ← Linear issue metadata (identifier, team key, status snapshot)
activity_figma_file        ← Figma file metadata (file key, comment id, last-touched handle)
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

Envelope responses are used on **data** endpoints that expose structured `data` / `meta` payloads (`GET /activities`, `/activities/search`, `/activities/live`, directory lists, configs). Health checks, OAuth callback HTML, webhook ACKs, and some error bodies are not envelopes.

When `meta.syncToken` is present, the client `VegasInterceptor` persists it locally.

---

## 6. API Controllers Reference

| Controller | Base Path | Responsibility |
|---|---|---|
| `ActivityController` | `/activities`, `/ws`, `/integrations/slack/events`, `/integrations/{github,phorge,jira,linear,gitlab,bitbucket,figma}/webhook`, `/mock/*` | Historical feed, Redis live inbox (`GET /activities/live`), archive/unarchive, provider push receivers, Explorer search (`GET /activities/search`), screenshot seed (`POST /mock/demo-day`), authenticated `/ws` |
| `OauthController` | `GET /integrations/{provider}/oauth/callback` | Public OAuth redirect; HTML response; no tokens in the page |
| `AdminController` | `/admin` | User management + identity review/link/resolve |
| `AuthController` | `/auth` | Bootstrap register, login, refresh token |
| `GroupController` | `/groups` | Group management |
| `HealthController` | `/health` | API + DB health (plain JSON, not the data envelope) |
| `MetadataController` | `/metadata`, `/admin/system-settings`, `/admin/configs` | Provider configs, status (includes daily-report lock), capabilities, admin config test/save, system settings |
| `UserController` | `/users` | Directory, credentials, git watches/branches, Follow pins + candidates, personal daily reports (`GET /users/me/day-reports` and `GET /users/:id/day-reports` list dates; `GET /users/:id/day-reports/:date` for manager/admin), device tokens |

---

## 7. Dependency Injection

**API (GetIt):** All registrations live in `service_locator.dart`. Use `sl<T>()` to resolve.  
**App (custom ServiceLocator):** All registrations in `lib/services/service_locator.dart`.

Never instantiate services, repositories, or use cases manually inside business logic or controllers.
