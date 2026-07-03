# DAB Infrastructure — Technical Blueprint

> **Linear source:** [Dab Infrastructure](https://linear.app/dev-activity-board/document/dab-infrastructure-339365576c10) · Last synced: 2026-04-08  
> **Stack:** Dart + Relic · PostgreSQL + Drift · Redis (Vegas) · WebSocket · Docker Compose

---

## System Topology & Event Fan-Out

DAB is built on a high-availability "Push" architecture using the **Vegas Internal Sync Pattern** to handle large data bursts with minimal bandwidth.

```mermaid
graph TD
    subgraph "External Providers"
        S1[Phorge Provider]
        S2[GitHub Provider]
        S3[Slack Web API]
    end
    subgraph "DAB Core Stack"
        API[Relic API]
        MW[[Vegas Middleware]]
        DB[(PostgreSQL / Drift)]
        RED[(Redis / Versional Clock)]
    end
    subgraph "Real-time Clients"
        CL1[DAB App 1]
        CL2[DAB App N]
    end
    S1 & S2 & S3 --> API
    API -->|1. Persistent Store| DB
    API -->|2. Version Clock| RED
    API --> MW
    MW -->|3. Staleness Check| CL1 & CL2
    API -->|4. WebSocket Event| CL1 & CL2
```

### Scalability & Performance Targets

| Metric | Target |
|---|---|
| Developer density | 100+ concurrent developers per instance |
| Feed latency | < 50ms end-to-end (ingestion → dashboard) |
| Sync overhead | Near-zero on unchanged data (Vegas 304 short-circuit) |

---

## Database Architecture (PostgreSQL + Drift)

DAB implements **Table-per-Type (TBT)** polymorphic schema to ensure strict metadata integrity without JSON blob anti-patterns.

### Schema Overview

```
activities                  ← Base table: id, userId, providerName, title, content, author, createdAt
  └── activity_phorge            ← Phorge metadata: taskPhid, revisionId, tags
  └── activity_github_commit    ← GitHub commit metadata: repo, branch
  └── activity_gitlab_commit    ← GitLab commit metadata: project, branch
  └── activity_bitbucket_commit ← Bitbucket commit metadata: repo, branch
  └── activity_jira_issue       ← Jira issue metadata: issueKey, projectKey, status
  └── activity_linear_issue     ← Linear issue metadata: identifier, teamKey, status
  └── activity_slack_message    ← Slack metadata: workspaceId, channelId, threadTs, messageTs
  └── activity_discord_message  ← Discord metadata: guildId, channelId, messageId, replyToId
```

- **Relational integrity:** Child tables reference `activities.id` with `CASCADE DELETE`.
- **Hydration:** `leftOuterJoin` in repository implementations — never duplicate base fields.
- **Migrations:** Fully automated via Drift's `MigrationStrategy`. Never hand-edit `*.g.dart` files.

### Key Tables

| Table | Purpose |
|---|---|
| `activities` | Normalized activity base |
| `activity_phorge` | Phorge-specific metadata |
| `activity_github_commit` | GitHub commit-specific metadata |
| `activity_gitlab_commit` | GitLab commit-specific metadata |
| `activity_bitbucket_commit` | Bitbucket commit-specific metadata |
| `activity_jira_issue` | Jira issue-specific metadata |
| `activity_linear_issue` | Linear issue-specific metadata |
| `activity_slack_message` | Slack message-specific metadata |
| `activity_discord_message` | Discord message-specific metadata |
| `users` | DAB user accounts |
| `user_identities` | External provider account linkage |
| `sessions` | Active auth sessions |
| `groups` | Organizational groups |
| `provider_configs` | External provider configuration |
| `system_settings` | System-wide settings stored as key-value pairs (`allowed_domain_enabled`, `allowed_domain`, `public_api_url`, `system_timezone`) |

Identity linkage (`user_identities`) is the runtime source of provider
participation for activity fetchers. Legacy tenants with historical
`users.phorge_phid` data should run a one-time backfill into
`user_identities(provider_id='phorge')` before enabling identity-only fetch.

Slack ingestion is read-only and identity-gated: only messages authored by
linked Slack identities (`provider_id='slack'`) are attributed. Provider
credentials are stored in `provider_configs.settings` (`botToken`, optional
`channels`, optional `apiBaseUrl`).

---

## Caching & Synchronization (Redis)

Redis serves as the high-speed **versional clock** and fan-out engine.

### 1. The Vegas Pattern

| Step | Mechanism |
|---|---|
| **Global clock** | `INCR dab:version` — atomic increment on every write |
| **Sync tokens** | Vegas-enabled data responses embed the current `syncToken` in `meta` |
| **Client request** | `dab_app` sends `X-Sync-Token` **only** on **`GET /activities`** (historical list); **`/activities/search`** and **`/activities/live`** do not participate in Vegas 304 short-circuit. |
| **Vegas Middleware** | Mounted on the `/activities` prefix but **only evaluates** tokens for **`GET /activities`**; **`/activities/search`** and **`/activities/live`** always call through. Compares token; returns `304 Not Modified` if client is current. |

### 2. Materialized Feed Keys

| Redis Key | Type | Use Case |
|---|---|---|
| `activities:global` | LIST | Rolling dashboard feed (last 500 items) |
| `activities:user:{id}` | LIST | Personal activity feed (last 100 items) |
| `activities:date:{yyyy-mm-dd}` | ZSET | Temporal sharding for date-range queries |
| `insights:stats:{yyyy-mm-dd}` | HASH | Real-time counts per provider category |
| `insights:rankings:{yyyy-mm-dd}:{category}` | ZSET | Category leaderboard by contribution |
| `insights:rankings:{yyyy-mm-dd}:total` | ZSET | Global team leaderboard by contribution |
| `dab:stream:events` | STREAM | Raw provider event ingestion stream |

The **dashboard** `GET /activities/live` response is built exclusively from Redis live keys (`activities:global` and `activities:user:{id}`); it never queries Postgres. Explorer uses **`GET /activities/search`**, which aggregates **provider APIs via `UnifiedActivityFetcher`** (no Postgres in that handler).

Live events reach these keys through provider push receivers: Slack Events API
(`POST /integrations/slack/events`), signed push webhooks for GitHub, GitLab,
Bitbucket, Phorge (Herald), Jira, and Linear
(`POST /integrations/{provider}/webhook`), and — for Discord, which has no
message webhooks — the outbound `DiscordGatewayService` WebSocket client. The
Gateway service connects to the Discord Gateway with the configured bot token
(`GUILD_MESSAGES`/`MESSAGE_CONTENT` intents), maintains the heartbeat loop with
sequence tracking, and reconnects with RESUME + exponential backoff. It starts
at boot when the Discord provider is active and reloads on config save.

**Webhook dedupe**: short-TTL Redis keys (`SET NX EX`, per-provider prefixes
such as `slack:event:{eventId}`, `github:delivery:{delivery}`, and
`ingest:{provider}:{fingerprint}` for the newer receivers) prevent replayed
provider deliveries from double-writing during the TTL window.

**Live feed window.** A background job runs at **organization-timezone midnight** (from `system_timezone`, default `UTC`) and rewrites
materialized lists `activities:user:*` and `activities:global`, removing entries
that are **archived** or whose `createdAt` is **before** the current UTC day.
The `GET /activities/live` handler applies the same UTC-day filter so clients
never see prior days if a purge was missed.

---

## WebSocket Real-Time Layer

- **Endpoint:** `ws://host:9080/ws` (same API service port by default)
- **Auth:** JWT-authenticated upgrade; request identity is used for scoped delivery
- **Protocol:** Clients upgrade HTTP → WebSocket on connect.
- **Payloads:** `ACTIVITY_RECEIVED` events pushed on every new ingestion.
- **Graceful Degradation:** If WebSocket is unavailable, clients fall back to polling with Vegas sync tokens.

---

## Docker Deployment

```bash
# Start all services (API + PostgreSQL + Redis)
cd dab_api && docker-compose up -d

# Production deployment
cd dab_api && docker-compose -f docker-compose.prod.yml up -d
```

### Service Map

| Service | Host Port (default) | Container Port | Env Override | Role |
|---|---|---|---|---|
| `api` (`relic`) | `9080` | `8080` | `API_PUBLIC_PORT` / `PORT` | REST API + WebSocket (`/ws`) |
| `api` (Dart VM) | `9181` | `8181` | `DART_VM_PUBLIC_PORT` | Dart VM service (dev attach on host; auth codes disabled in compose) |
| `swagger` | `9081` | `8080` | `SWAGGER_PUBLIC_PORT` | Swagger UI (serves `doc/openapi.yaml`) |
| `db` (`postgres`) | `5433` | `5432` | `DB_PUBLIC_PORT` | Primary database |
| `redis` | `6379` | `6379` | `REDIS_PUBLIC_PORT` | Cache + versional clock |

> Host-side defaults for the API, Swagger, and Dart VM service moved from the
> `808x` range to `90xx/91xx` so DAB can coexist with other local APIs that
> already bind `8080`. Only the host mapping changed; inside the container the
> API still listens on `8080`. Override any of them via `dab_api/.env`.

### Debugging (API in Docker, app on host)

Dev `docker-compose.yml` exposes the Dart VM service on host port **9181** with
`--disable-service-auth-codes` so the attach URI stays stable:
`http://127.0.0.1:9181/`. The API source tree is bind-mounted into the container
so breakpoints in `dab_api/` resolve correctly.

In VS Code / Cursor (workspace `.vscode/launch.json`):

| Configuration | Use |
|---|---|
| **DAB API (Docker + Attach)** | Starts `docker compose` (db, redis, api), waits for `/health` and the VM port, then attaches the debugger (`vmServiceUri` → port 9181). |
| **DAB App (Debug)** | Start the Flutter client yourself when ready (separate debug session). |

Compose `environment:` overrides `.env` for service hostnames (e.g. `REDIS_HOST=redis`).
The app targets `http://localhost:9080` and `ws://localhost:9080/ws` (Docker dev defaults in `service_locator.dart`).

---

## Configuration Guardrails

| Guardrail | Mechanism |
|---|---|
| **Auth enforcement** | JWT Middleware on all protected routes |
| **Domain lockdown** | Rejects registrations outside `DAB_ALLOWED_DOMAIN` |
| **Bootstrap lock** | Platform locked until first admin completes setup (`AdminController`) |
| **Envelope pattern** | All responses wrapped in `{ data, meta }` — never raw JSON |

### Required Environment Variables (`.env`)

```
DB_HOST=
DB_PORT=5432
DB_NAME=
DB_USER=
DB_PASS=
REDIS_HOST=
REDIS_PORT=6379
JWT_SECRET=
JWT_EXPIRY_MINUTES=60
DAB_ALLOWED_DOMAIN=
PORT=8080
DAB_INITIAL_ADMIN_EMAIL=
```
Production compose currently configures DB + API; if Redis is not in compose, provide an external Redis and set `REDIS_HOST` / `REDIS_PORT`.

---

## Health Check Endpoints

| Check | Endpoint | Expected Response |
|---|---|---|
| API Pulse | `GET /health` | `{"status":"healthy","timestamp":"..."}` |
| DB Health | `GET /health/db` | `{"status":"healthy|degraded","database":"connected|disconnected","timestamp":"..."}` |
| WS Stream | `ws://host:9080/ws` | Successful upgrade + `ACTIVITY_RECEIVED` payloads |

---

## Test Infrastructure

- **`TestRequest`:** Bypass utility for creating Relic `Request` objects (normally private) for isolated controller testing.
- **`TestData` (Object Mother):** Centralized factory library generating high-fidelity mock entities (Phorge tasks, GitHub commits, admin users) for consistent test scenarios.
- **Integration tests:** Tagged `@Tags(['integration'])`. Require live PostgreSQL + Redis. Excluded from unit CI runs.
