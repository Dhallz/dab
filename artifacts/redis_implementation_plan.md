# Redis Implementation Plan 🏗️ 🚀

Implement Redis into the DAB API for extreme-performance caching, staleness-optimized synchronization (Vegas Pattern), and reliable background task scheduling (Redis Streams).

## 🎯 Purpose and Goals
The primary goal of integrating Redis is to transform DAB from a static relational aggregator into a **real-time, high-density observation platform**.

### 🛠️ Why Redis?
- **Speed**: PostgreSQL sub-millisecond queries are fast, but Redis memory-speed is required for 100+ concurrent UI heartbeats.
- **Bandwidth Efficiency**: Implementing the Vegas Pattern to prevent serving massive payloads when nothing has changed.
- **Reliability**: Decoupling ingestion (webhooks) from processing (DB writes) using Streams to handle traffic spikes without dropping data.

---

## 🏛️ Implementation Requirements (Exhaustive)
To achieve these goals, we will implement the following high-fidelity components, strictly adhering to the **Envelope Pattern** and **UI-First** sharding strategy:

### 1. The Global Version Clock (Vegas Strategy)
- **Goal**: O(1) staleness checks for high-density clients.
- **Implementation**: A single Redis key `dab:version` (`INCR`) incremented on *every* write.
- **Envelope Integration**: Served in `meta.syncToken`. If the client's header `X-Sync-Token` matches, service returns `304 Not Modified`.

### 2. Multi-Level Sharding ("The Fan-Out Pattern")
Every incoming activity is fanned out to three specialized structures simultaneously:
- **Global Feed (`activities:global`)**: `LPUSH` + `LTRIM`. Stores the last **1,000 - 5,000** activities (Team Heartbeat).
- **Per-User Feed (`activities:user:{id}`)**: Dedicated list for individual profile views and personal history.
- **Temporal Sharding (`activities:date:YYYY-MM-DD`)**: A **ZSET** where `score = timestamp`. Allows O(1) navigation for the entire day across the whole team.
- **DB Fallback**: For anything older than "Today," the API transparently queries PostgreSQL indexed tables.

### 3. Real-time Insights & Leaderboards (O(1) Statistics)
- **Daily Statistics (`insights:stats:YYYY-MM-DD`)**: A **Hash** (`HINCRBY`) tracking tool-specific counts (e.g., Slack, GitHub) for instant area charts.
- **Leaderboard Pattern (`insights:rankings:{date}:{category}`)**:
    - Uses **ZSETs** for automatic sorting.
    - **`ZINCRBY`**: Increments user score upon activity.
    - **`ZREVRANGE`**: Instant retrieval of "Top 3 Users" without complex SQL aggregations.

### 4. Tiered Visibility Strategy (Efficiency)
- **Dash-Burst**: Clients fetch the first **250-500** items from Redis for "Instant-Load" feel.
- **Historical Pagination**: For deeper archival scrolling, the app transitions to SQL-backed pagination to minimize network payload lag.

---

## Proposed Changes

### 🔧 DevOps & Configuration
- **[MODIFY] [docker-compose.yml](file:///Users/dhallz/git/dab/dab_api/docker-compose.yml)**: Add the `redis` service and link it to the `api` service.
- **[MODIFY] [pubspec.yaml](file:///Users/dhallz/git/dab/dab_api/pubspec.yaml)**: Add `redis: ^3.1.0` dependency.
- **[MODIFY] [.env](file:///Users/dhallz/git/dab/dab_api/.env)**: Add `REDIS_HOST`, `REDIS_PORT`, and `REDIS_PASS` variables.

---

### 🏛️ Infrastructure Layer
- **[NEW] `lib/src/infrastructure/database/redis/redis_client.dart`**: Implement a wrapper for the `redis` package to handle connection pooling and basic commands.
- **[NEW] `lib/src/infrastructure/database/redis/redis_service.dart`**: A higher-level service for logical operations (e.g., `incrementVersion`, `cacheActivities`, `addToStream`).

---

### ⛩️ Implementation Strategies

#### 🔄 Vegas Pattern (Sync)
- Increment `dab:version` on every database write in `ActivityRepository` and `AuthRepository`.
- Implement a middleware/interceptor to check the `syncToken` header against Redis.

#### 📡 Redis Streams (Tasks)
- Implement `XADD` logic for incoming webhooks.
- Implement specialized Isolates that consume the `dab:stream:events` using `XREADGROUP`.

---

### 💉 Dependency Injection
- Register `RedisClient` and `RedisService` in `service_locator.dart`.

## Verification Plan

### Automated Tests
- Integration tests for Redis connection and basic CRUD.
- Unit tests for the Vegas pattern versioning logic.

### Manual Verification
- Verify `docker-compose up` starts Redis correctly.
- Inspect Redis using `redis-cli` during activity ingestion to confirm key creation (`activities:global`, `dab:version`).
