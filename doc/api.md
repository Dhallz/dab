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

- **`dtos/`:** Provider-native shapes (e.g. `GitHubCommitDto`, `SlackMessageDto`, `PhorgeTaskBundleDto`). Sources return these; **`extension OnDto.toActivities(...)`** maps them to `Activity` — all without importing Infrastructure.

- **`contracts/`:** All outbound seams. **`ports/`** — I/O that is not our Postgres (`IActivitySource<T>`, `IDiscoverySource`, catalogs, `ILiveFeedStore` / `IPresenceBroadcaster` / `IAccessTokenIssuer`, `IWebhookRequestAuthenticator`, `IDiscordLiveIngestor`, plus `AbsIPhorgeGateway` for Phorge directory/sprint/task/revision facade). Other providers poll through `IActivitySource`, not a dedicated gateway. **`repositories/`** — abstract Postgres contracts (`AbsI*` / `I*`). Return `Either<Failure, T>` via `fpdart`. **`IUserRepository.getUser`** returns **`NotFoundFailure`** when the row is absent and **`DatabaseFailure`** on query errors.

- **DTO mapping extensions:** Business rules for transforming each provider payload type into a `DAB Activity`.

---

### 2. Infrastructure Layer (`lib/src/infrastructure/`)

**Key constraint:** Read-only. DAB is an observer. Providers must **never** implement mutation endpoints.

- **`IActivitySource` implementations (`sources/`):** Implement the domain port `IActivitySource<T>`; return `domain/dtos` types — never full domain `Activity` entities (mapping stays on Domain DTO extensions). Provider I/O that is not a poll source (catalogs, Discord Gateway) also lives here.

- **`protocols/`:** Outbound wire adapters. **Generic:** `JsonRestProtocol` (GitHub, GitLab, Bitbucket, Jira, Discord REST), `GraphqlProtocol` (Linear). **Provider-specific** when the envelope is unique: `ConduitProtocol` (Phorge), `SlackWebProtocol` (Slack `ok` JSON). Sources decide *what* to pull; protocols own *how* requests are encoded. Failures surface as `ProtocolException` subtypes — **no raw response bodies** on exceptions. Not protocols: watch-list parsers, webhook HMAC verifiers, OAuth token exchange, `IActivitySource`.

- **`persistence/`:** All durable/cache stores. **`postgres/`** — Drift schema, DAOs, `MigrationStrategy` (never hand-edit `*.g.dart`). **`redis/`** — live feed, Vegas clock, ingest dedup. **`repositories/`** — AbsI* implementations (TBT `leftOuterJoin` hydration, including `PostgresHealthRepository`).

- **`core/`:** Cross-cutting leftovers. **`config/`** — env loading. **`security/`** — JWT, bcrypt, HMAC primitives, `SettingsCipher`. **`http/`** — inbound payload helpers. **`adapters/`** — OAuth, credential overlay, identity probe, webhook authenticator. **`realtime/`** — `PresenceService`. **`logging/`** — structured logging plus the unused push-notification stub.

- **Relative URL Strategy:** Providers generate relative paths (e.g., `/T123`). The DAB app resolves full URLs using `baseUrl` from `ProviderConfig`.

---

### 3. Application Layer (`lib/src/application/`)

Orchestrates use cases. Use cases return `Either<Failure, T>` where failures matter; controllers map `Left` to HTTP status. **`UnifiedActivityFetcher`** logs per-connector errors via an injected log callback (e.g. `LoggingService.record`) without importing infrastructure types.

- **`ConnectorRegistry`:** Holds **`TypedConnectorPair<T>`** entries. **`register_activity_connectors.dart`** is the single bootstrap function that registers every source + mapper pair.

- **`UnifiedActivityFetcher`:** Orchestrates **parallel fetching** across all registered providers. If **`getConfigs()`** fails, emits a **WARNING** log and skips all connectors (empty active set). Per-connector failures still log WARNING and return an empty slice for that provider only.

- **`LogActivity` use case:** Persists activity, increments Vegas version in Redis, and broadcasts over WebSocket via `IPresenceBroadcaster`.
- **Live ingest:** Provider ingest use cases share `IngestionResult` and `LiveIngestPersister` (SQL insert + Redis fan-out + ingest-success timestamp). Application talks to Redis/Presence/JWT through `ILiveFeedStore`, `IPresenceBroadcaster`, and `IAccessTokenIssuer`.
- **Activity query use cases:** `GetRecentActivities`, `SearchActivities`, and `FetchRemoteActivities`.
- **`GetLiveActivities`:** Serves **`GET /activities/live`** from Redis lists only (no Postgres). Explorer historical browsing uses **`SearchActivities`** (**`GET /activities/search`**), not Redis.
- **Auth workflows:** Implemented through `AuthUseCases` (`RegisterUser`, `AuthenticateUser`, `RefreshUserToken`, etc.).

---

### 4. Presentation Layer (`lib/src/presentation/`)

Thin entry points only. No business logic.

#### Controllers

| Controller | Path | Key Responsibilities |
|---|---|---|
| `ActivityController` | `/activities*`, `/ws`, `/integrations/*/webhook`, `/integrations/slack/events` | Historical feed (`/activities`), **dashboard `GET /activities/live`** is **Redis-backed only** (optional `?includeArchived=true`; omit `scope` for the signed-in user's inbound inbox). Live-feed triage (`POST /activities/live/:id/archive`, `POST /activities/live/:id/unarchive`), provider push receivers (`/integrations/slack/events`, `/integrations/{github,phorge,jira,linear,gitlab,bitbucket}/webhook`) — HMAC/shared-secret via `IWebhookRequestAuthenticator`, then ingest use case. Historical **`GET /activities/search`** (UnifiedActivityFetcher polling only — no Postgres merge), WebSocket `/ws`. Archived live entries stay in Redis (nightly purge). `ActivityPurgeScheduler`. `ActivityLivePollScheduler` is retained for DI but does **not** publish authored poll rows into the live inbox. |
| `OauthController` | `GET /integrations/{provider}/oauth/callback` | Public (no JWT) OAuth redirect. Validates Redis `oauth:state:{id}`, exchanges the code, persists via `SaveUserProviderCredential`. Returns HTML. Never includes tokens. |
| `AdminController` | `/admin/*` | Identity list/summary, manual link, resolve workflow, delete link (`DELETE /admin/identities/:id`), admin user creation (`POST /admin/users`) and role management |
| `AuthController` | `/auth/*` | Bootstrap-only register (open while zero users exist; first user becomes admin), login, refresh token |
| `GroupController` | `/groups/*` | Group management |
| `HealthController` | `GET /health`, `/health/db` | Pulse check, DB connectivity |
| `MetadataController` | `/metadata/*`, `/admin/configs*`, `/admin/system-settings` | Public bootstrap status/configs (includes `deploymentMode`), provider metadata list, provider capability matrix (`/metadata/capabilities`), admin provider config save/test (`POST /admin/configs/test` returns Core/Live/Polling section report; Live green = Redis `live:last_ingest:{providerId}` within 7 days), system settings (domain validation toggle + allowed domain + `public_api_url` for OAuth callbacks and webhooks + `deployment_mode`) |
| `UserController` | `/users/*` | User directory plus self-serve credentials (`GET/PUT/DELETE /users/me/credentials`, `POST /users/me/credentials/:provider/test`, `POST /users/me/credentials/:provider/oauth/start`, `GET/PUT /users/me/credentials/{jira,linear,github,gitlab,bitbucket}/projects` for Jira/Linear instance allow-lists and personal git inbox watches, `GET /users/me/credentials/{github,gitlab,bitbucket}/branches` for the Settings branch picker) and Dashboard object Follow pins (`GET/PUT/DELETE /users/me/follows` with `{ providerId, objectKey }` for Phorge, Jira, Linear, Slack, Discord). Secrets are encrypted at rest (`DAB_CREDENTIALS_KEY`); list/test/oauth-start never echo tokens. OAuth tokens are stored as the existing provider secret keys plus `tokenType=oauth`. Jira Cloud access tokens expire in about an hour; listing projects refreshes them via `offline_access` before calling Jira. Slack/Discord bots are instance `ProviderConfig` fields (Admin), not per-user Settings paste. |

#### Middleware

- **Vegas Middleware:** Applies only to **`GET /activities`** under the `/activities` mount. Compares client `X-Sync-Token` against Redis version and returns **`304 Not Modified`** when unchanged. **`GET /activities/search`** and **`GET /activities/live`** skip this gate.
- **JWT Middleware:** Validates signed tokens on all protected sub-routes.
- **WebSocket auth guard:** `/ws` is protected by JWT middleware and uses request-context identity for scoped delivery.
- **Account creation rules:** Enforced by use cases, not HTTP middleware. `RegisterUser` is bootstrap-only (rejects once any user exists; honors the `DAB_INITIAL_ADMIN_EMAIL` bootstrap lock). `CreateUserByAdmin` (behind `POST /admin/users`) is the only creation path afterwards and applies the allowed-domain guard when the `allowed_domain_enabled` system setting is on (domain from the `allowed_domain` setting, `DAB_ALLOWED_DOMAIN` env fallback). Existing accounts outside the domain are grandfathered — the toggle never blocks login.
- **Admin middleware:** After bootstrap, authorizes `/admin/*` using the **database** user role (not only JWT) so promotions apply immediately.
- **`GET /metadata/status` `isSystemConfigured`:** `true` when there is at least one admin **and** at least one **active** provider config (a first OAuth connect or PAT save activates that row).
- **Credential waterfall:** each PAT/OAuth provider fetch uses the target user's `UserProviderCredential` overlaid onto org `ProviderConfig` settings (`ICredentialResolver`), else the org token, else skip. Slack and Discord use the instance **bot** token only (no per-user overlay). Tokens are fetch keys, not a visibility ACL.

| Kind | Providers | Fetch credentials |
|---|---|---|
| OAuth / PAT | GitHub, GitLab, Bitbucket, Jira, Linear, Phorge | User secret overlay, else org settings |
| Workspace bot | Slack, Discord | Org `botToken` only |
- **`GET /activities/search` query `startDate` / `endDate`:** Bare `YYYY-MM-DD` (no TZ) is interpreted as **organization calendar days** in the configured `system_timezone` (default `UTC`), converted to UTC instants for provider polling and DB queries (`ActivityController` + `OrgCalendar`). **`dab_app`** sends the same `YYYY-MM-DD` strings derived from Explorer/Insights picker dates in the org timezone (`ActivitySearchQueryMapper.toRemoteQueryParameters`), and client-side filtering uses the same org-day semantics. **`authoredOnly`:** **`dab_app`** Explorer keeps **`true`** for personal-scope browsing; **Insights** uses **`false`** for team analytics so connectors can apply broader retrieval (e.g. Phorge sprint/global paths).

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

| Provider | Status | Explorer (polling) | Dashboard (live) |
|---|---|---|---|
| Phorge | ✅ Active | Conduit REST API | Herald webhook (HMAC-SHA256) |
| GitHub | ✅ Active (Commits v1) | REST | Push webhook (`X-Hub-Signature-256`) |
| Slack | ✅ Active (Messages v1) | Slack Web API | Events API webhook |
| Jira | ✅ Active (issues v1) | REST + discovery | Webhook (`X-Hub-Signature` HMAC) |
| Linear | ✅ Active (issues + comments v1) | GraphQL + discovery | Webhook (`linear-signature` HMAC) |
| Discord | ✅ Active (messages v1) | REST + discovery | Gateway WebSocket client (`MESSAGE_CREATE`) |
| GitLab | ✅ Active (commits v1) | REST + discovery | Push Hook webhook (`X-Gitlab-Token`) |
| Bitbucket | ✅ Active (commits v1) | REST + discovery | `repo:push` webhook (`X-Hub-Signature` HMAC) |
| Teams | 🔜 Planned (removed from v1; Graph change notifications operationally heavy) | Microsoft Graph REST | — |

GitHub v1 ingestion is commits-only and uses provider-linked identities from
`user_identities` (`provider_id: github`) to scope attribution. Saved provider
settings may include **`webhookSecret`** (matching the secret configured on the
repository webhook in GitHub) for **`POST /integrations/github/webhook`**. The
configured repo allow-list (`owner`/`repo`, `repos` list — same shaping as polling)
gates which repositories may deliver push events into DAB. Dashboard git inbox
rows fan out to users who **watch** that repo/branch on their credential
(`watchedRepos` / `watchedBranches`), excluding the committer. Missing
`watchedRepos` inherits the instance allow-list; an empty list means no git
inbox. The unified fetcher continues to backfill commits via polling when
configured.

**Bruno — GitHub historical polling:** run the `bruno/github-polling-flow/` folder in order (login → load config → pick linked user → test polling → search → optional direct GitHub API probe). Set `githubSearchStartDate` / `githubSearchEndDate` in the environment to a window with known commits. Step **07 Probe GitHub API Direct** calls `GET https://api.github.com/repos/{owner}/{repo}/commits` with the same `since`/`until`/`sha`/`author` params DAB uses — use it to tell whether empty search results come from GitHub or from DAB mapping.

**Bruno — local provider restore (after DB reset):** copy `bruno/local-secrets.example/` to `bruno/local-secrets/` and `bruno/environments/local-secrets.bru.example` to `bruno/environments/local-secrets.bru`, fill secrets, select the `local-secrets` environment, then run requests in order (register/login → system settings → webhook endpoints → save providers → optional identity links → verify). Step **04 Webhook Endpoints** derives `*WebhookUrl` vars from `public_api_url` for pasting into provider webhook consoles. The working copies are gitignored.

Bootstrap remains local-first for the first admin; teams can onboard with any provider
afterward (no Phorge prerequisite).

Slack v1 ingestion is message-only and strictly identity-based (`provider_id:
slack`). Connector execution and attribution require linked Slack user IDs in
`user_identities.external_id`; there is no email fallback during mapping. The
admin test-connection endpoint validates Slack credentials using `auth.test`,
and expected settings are `botToken` plus optional `channels` and `apiBaseUrl`.

Jira Cloud ingestion is read-only and event-oriented: `JiraIssueSource` queries
`/rest/api/3/search/jql` with a time-bounded JQL **`updated`** window and then
hydrates full issue comments via `/rest/api/3/issue/{key}/comment` (comment rows
are not hard-trimmed by a second UTC-only filter, so client-side local-date
filtering remains authoritative). It maps
issue snapshots plus in-window comment events into the unified activity feed so
Explorer can stack multiple events under one Jira issue card. Activate the
connector with **`ProviderConfig.baseUrl`** pointing at `https://<site>.atlassian.net`
(and set **`settings.api.email`** plus **`settings.api.token`** — Atlassian API
token). **`settings.projectKeys`** is a comma- or newline-separated list of
project keys (e.g. `DAB,OPS`); optional **`settings.extraJql`** appends an `AND`
fragment. **`authoredOnly`** adds `reporter` / `assignee` / `creator` filters using
linked `user_identities` rows (`provider_id: jira`, `external_id` = Jira account id).
Discovery uses **`GET /rest/api/3/user/search`**.

Provider live-ingestion capabilities are exposed via `GET /metadata/capabilities`
to support dashboard strategy selection (webhook/websocket first, polling
fallback).

Slack true-live ingestion is handled via `POST /integrations/slack/events`
(Events API webhook). The endpoint validates Slack signatures, acknowledges
quickly, and processes event callbacks asynchronously into DB + Redis live keys
and scoped WebSocket delivery. Message routing is mention-targeted: activities
are created per recipient when a message includes direct user mentions (`<@U...>`),
broadcast mentions (`@all`, `<!channel>`, `<!here>`, `<!everyone>`), or Slack
user-group mention tokens (`<!subteam^...>`). An explicit user mention, including
a self-@, still creates a row for that recipient. Broadcast mentions
(`@channel` / `@here` / `@everyone`) omit the sender. Users who **Follow** that
thread (`workspaceId|channelId|thread root ts`) also receive later messages,
including their own. Messages without target mentions and without followers
are ignored for live-feed ingestion. `Activity.userId` is the
recipient; `senderUserId` is the linked actor.

For local webhook testing, generate signature headers from the exact raw request
body using:
`./scripts/generate_slack_signature.sh "$SLACK_SIGNING_SECRET" /path/to/body.json`

Phorge live ingestion uses Herald webhooks (`POST /integrations/phorge/webhook`)
for `TASK` and `DREV`. Herald payloads are thin (object PHID + transaction PHIDs),
so `IngestPhorgeWebhook` hydrates the object via Conduit before mapping.
Recipients are subscribers/CC, reviewers, new assignee/owner, and Remarkup
`@username` / `{@PHID}` mentions. Standing task owner is **not** automatic.
An explicit self-@, self-assign, or adding yourself as CC/reviewer still
creates a Dashboard row. Users who **Follow** the task PHID also receive later
updates, including untagged comments and their own actions. Signature is
HMAC-SHA256 of the raw body in `X-Phabricator-Webhook-Signature`, keyed by the
provider setting **`webhookHmacKey`**; dedup is per transaction PHID via Redis.

Jira live ingestion (`POST /integrations/jira/webhook`) handles
`jira:issue_created` / `jira:issue_updated` and `comment_created` /
`comment_updated`. Jira Cloud admin webhooks sign the
raw body with HMAC-SHA256 in the `X-Hub-Signature` header (`sha256=<hex>`) when
a **Secret** is configured on the webhook (Atlassian “Secure admin webhooks”).
DAB verifies that signature against **`webhookSecret`**. Plain
`X-Webhook-Secret` / `?secret=` are accepted only as a Bruno simulation
fallback. Comment events are distinct activity ids
(`jira|{host}|{issueKey}|comment|{commentId}|{recipient}`) so Dashboard live-publishes them;
Explorer still groups by issue key. Live comments fan out only to **linked ADF
mentions**; issue updates fan out only when changelog **assignee became me**.
Users who **Follow** the issue key also receive untagged comments and later
status updates, including their own. Unlinked mentions are dropped. When instance **`projectKeys`** is set (Settings
project picker after Connect, seeded from whoami), both polling and live
webhooks skip other projects — that list is an ingest allow-list, not inbox
targeting. Events map through the same `JiraIssueDto.toActivities` path as
polling.

Linear ingestion is issue-oriented: `LinearIssueSource` queries the GraphQL API
(`issues` filtered by an `updatedAt` window and, with `authoredOnly`, by linked
assignee/creator identities) using the provider **`apiKey`** setting; comments
in the same window are merged onto those issues. When instance **`teamKeys`**
is set (Settings team picker after Connect; ingest allow-list, not inbox
targeting), both polling and live webhooks skip other Linear teams. Discovery
resolves Linear user ids by email. Live ingestion (`POST /integrations/linear/webhook`)
handles `Issue` and `Comment` create/update payloads, verifying the
`linear-signature` HMAC-SHA256 header against **`webhookSecret`** and deduping
on the `linear-delivery` id. Live comments fan out to **linked `@[Name](userId)`
mentions**; issue updates fan out only when **assignee became me**. Users who
**Follow** the issue identifier (`ENG-123`) also receive untagged comments and
later updates, including their own. Each
comment is a distinct activity id (`linear|{issue}|comment|{commentId}|{recipient}`)
so Dashboard live-publishes it; Explorer still groups by issue identifier.

Discord has no outbound webhooks for messages, so live ingestion uses
`DiscordGatewayService` — an outbound Gateway WebSocket client (IDENTIFY with
the **`botToken`**, `GUILD_MESSAGES`/`MESSAGE_CONTENT` intents, heartbeat +
RESUME reconnect). `MESSAGE_CREATE` dispatches flow through
`IDiscordLiveIngestor` (`IngestDiscordMessage`) into the same persist/fan-out
pipeline. Live messages fan out like Slack: Gateway `mentions[].id` and
`@everyone`/`@here` (when `mention_everyone`) to linked Discord identities.
An explicit user mention, including a self-@, still lands for that recipient;
`@everyone`/`@here` omit the author. Users who **Follow** the conversation
(`guildId|channelId|root message id`) also receive later replies, including
their own. Unmentioned messages without followers are ignored. The service
starts on boot when the Discord config is active and reloads on config save.
Explorer backfill polls `GET /channels/{id}/messages` per configured
**`channels`** id; attribution requires linked identities
(`provider_id: discord`).

GitLab ingestion is commit-oriented: `GitLabCommitSource` polls
`GET /projects/:id/repository/commits` per configured **`projects`** entry
(token auth via **`apiToken`**, instance URL from `baseUrl`/**`instanceUrl`**),
attributing commits by `author_email` against user emails and linked
identities. Live ingestion (`POST /integrations/gitlab/webhook`) handles Push
Hook events authenticated with the plain shared **`webhookSecret`** in
`X-Gitlab-Token` (constant-time compare; GitLab does not sign payloads). After
the instance `projects` allow-list, commits fan out to users watching that
project on their credential, excluding the committer.

Bitbucket ingestion mirrors GitLab: `BitbucketCommitSource` polls
`GET /repositories/{workspace}/{repo}/commits` (Basic auth with **`username`** +
app password **`apiToken`**, **`workspace`** + **`repos`** allow-list),
preferring `account_id` from linked identities with email fallback from the raw
commit signature. Live ingestion (`POST /integrations/bitbucket/webhook`)
handles `repo:push` events verified with HMAC-SHA256 (`X-Hub-Signature`,
`sha256=<hex>`) against **`webhookSecret`**, deduping on `X-Request-UUID`.
After the instance `repos` allow-list, commits fan out to credential watchers,
excluding the committer.

Microsoft Teams support was removed from the active codebase and returned to
the roadmap: Graph change notifications require tenant-wide admin consent,
encrypted payload handling, and short-lived subscription renewal, which makes
live ingestion operationally heavy for self-hosted deployments. Historical
Teams rows remain in the orphaned `activity_teams_message` table and are hidden
by the Deep Deactivation join (the `teams` provider config row is deleted in
schema v16).

GitHub sends the JSON body as either **raw JSON** (`Content-Type:
application/json`) or **URL-encoded** (`application/x-www-form-urlencoded` with a
`payload` form field). Both are accepted; HMAC is always over the **exact raw
request bytes** GitHub posts. Allowed-list pushes fan out one activity per
watcher (stable id includes the recipient) after excluding the committer;
login still maps to a **linked** `user_identities` row (`provider_id: github`)
for `senderUserId`. Then the pipeline matches Slack: Postgres + Redis
**`fanOutActivity`** + **`PresenceService.broadcastToUser`** (`ACTIVITY_RECEIVED`).
**`ping`** is acknowledged without persisting commits. Other event types return
success but perform no ingestion.

### Admin provider connectivity (Live ingest signal)

Successful webhook/event ingest paths call `RedisService.recordLiveIngestSuccess(providerId)` with a **7-day TTL** (`live:last_ingest:{providerId}`). `POST /admin/configs/test` Live section is green when that timestamp is within the window (Discord also requires `DiscordGatewayService` connected). If no recent ingest exists, **Try** runs an internal **webhook test delivery** that validates Live signing secrets (HMAC round-trip or shared-secret check) and records the same Redis key — so Live can turn green without waiting for a real provider event. New installs should configure Live secrets and click **Try**.

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
