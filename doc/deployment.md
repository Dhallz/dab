# DAB — Deployment

> Local Docker Compose and Railway share one config path: `DATABASE_URL` /
> `REDIS_URL` when set, otherwise discrete `DB_*` / `REDIS_*` vars. Postgres
> TLS is **off** unless the URL has `sslmode=require` (or `DAB_DB_SSL=true`).
> Redis `AUTH` runs only when a password is present.

The Flutter client defaults to local Compose. Point it at a hosted API with
`--dart-define=DAB_API_BASE=https://<host>`.

---

## Local Docker

```bash
cd dab_api
docker compose up -d
```

| Service | URL |
|---|---|
| API + WebSocket | `http://localhost:9080` · `ws://localhost:9080/ws` |
| Swagger | `http://localhost:9081` |
| Postgres (host) | `localhost:5433` |
| Redis (host) | `localhost:6379` |

Compose sets `DB_HOST=db` and `REDIS_HOST=redis` with **no TLS** and **no Redis
password**. Do not set `DATABASE_URL` with `sslmode=require` against the Alpine
Postgres image — it does not speak TLS.

Flutter (same machine):

```bash
cd dab_app
flutter run
```

No dart-define is required. See [infrastructure.md](./infrastructure.md) for
VM-service debugging.

---

## Railway

The API is a **long-running** process (Discord Gateway, daily live-feed purge, `/ws`).
`ActivityLivePollScheduler` is started at boot but does not refill the inbox.
Use **one replica**, never sleep / scale-to-zero.

### Project

1. New Railway project. Service **root directory:** `dab_api`. **Builder:** Dockerfile (`dab_api/Dockerfile`, AOT `scratch` image).
2. Add **PostgreSQL** and **Redis** plugins (Redis is required).
3. Replicas **1**. HTTP healthcheck: `GET /health`. Set a spend limit.
4. Do **not** deploy Swagger or expose Postgres/Redis publicly.

### Environment (API service)

Railway injects `DATABASE_URL` and `REDIS_URL`. Prefer those over copying
`DB_HOST`. Typical variables:

| Variable | Local Compose | Railway |
|---|---|---|
| `DATABASE_URL` | unset | plugin (include `sslmode=require` on the public URL) |
| `REDIS_URL` | unset | plugin **`redis://`** (private). `rediss://` is not supported |
| `DB_*` / `REDIS_HOST` | set by Compose | omit if URLs are set |
| `DAB_DB_SSL` | unset (off) | unset if the URL has `sslmode=require`; `true` if TLS is needed without that query |
| `REDIS_PASSWORD` | unset | omit if `REDIS_URL` has a password |
| `PORT` | `8080` in container | injected by Railway |
| `APP_ENV` | unset / `development` | `production` (rejects the default `JWT_SECRET`) |
| `JWT_SECRET` | Compose dev value | long random; never the compiled default |
| `DAB_CREDENTIALS_KEY` | optional (falls back to JWT) | set once; changing it invalidates stored user tokens |
| `DAB_INITIAL_ADMIN_EMAIL` | optional | bootstrap admin |
| `DAB_*_OAUTH_CLIENT_ID` / `_SECRET` | as needed | `DAB_{PROVIDER}_OAUTH_*` for GitHub, GitLab, Bitbucket, Jira, Linear, Figma |
| `FCM_SERVICE_ACCOUNT_JSON` | unset (wake is a no-op) | Google service-account JSON **or** a file path. Required only to send data-only inbox wakes when the user has no WebSocket session. Tokens are still stored via `PUT /users/me/device-tokens`. Wake payloads never include activity title or body. |

After the first healthy deploy:

1. Confirm `GET /health` and `GET /health/db`.
2. In Admin → Security set **`public_api_url`** to `https://<your-service>.up.railway.app` (no trailing slash).
3. Register that origin’s `/integrations/<provider>/oauth/callback` and webhook URLs with GitHub, Jira, etc.

### Flutter against Railway

```bash
cd dab_app
flutter run --dart-define=DAB_API_BASE=https://<your-service>.up.railway.app
```

That sets REST to HTTPS and the live socket to `wss://<host>/ws`.

---

## What not to do

- Two API replicas — Discord Gateway and schedulers are in-process.
- Cloud Run / Lambda / scale-to-zero — they drop `/ws` and background work.
- `SslMode.require` against local Compose Postgres without enabling TLS on the database.
- Committing Railway URLs or secrets.

`dab_api/docker-compose.prod.yml` is **not** the Railway path (it still omits Redis). Use this document plus the `dab_api/Dockerfile`.
