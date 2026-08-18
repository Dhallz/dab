# DAB — Project Overview

> **The Open-Source, Self-Hosted Event Bus for Modern Engineering Teams**

---

## 1. The Problem: The "Alt-Tab" Tax

As developers, "Flow State" is our most valuable asset. Currently, that asset is fragmented across 5–7 different communication and project tools.

- **The Cost of Re-indexing:** Switching between Jira, Slack, Teams, Zoom, Phorge, and Linear takes ~20 minutes to mentally re-index after an interruption.
- **Desktop Fragmentation:** Running multiple Electron apps simultaneously consumes gigabytes of RAM and crowds out your IDE, Terminal, and Debugger.
- **Notification Fatigue:** Critical PR approvals are buried under Slack "FYIs" because there is no unified priority queue.

---

## 2. The Solution: A Unified Event Hub

DAB is a centralized engine that aggregates every signal a developer needs into a single, high-performance interface.

- **Normalization:** Disparate data schemas (a Jira ticket, a Slack @mention, a Phorge revision) are mapped into a **Unified Activity Schema**.
- **Universal Access:** Native clients for Desktop (Windows, Mac, Linux) and Mobile (Android, iOS).
- **Real Estate Recovery:** One lean app replaces 7+ background applications, reclaiming 90% of the screen for actual work.

---

## 3. Technical Architecture: Sovereignty by Design

DAB is **not a SaaS** — it is private-first infrastructure that you own and audit.

- **Deployment:** Fully self-hosted via Docker Compose (`cd dab_api && docker-compose up -d`). No hidden cloud dependencies.
- **Data Security:** Provider credentials and operational data stay inside your infrastructure. TLS/encryption-at-rest policies are deployment-controlled.
- **Hybrid Ingestion Logic:**
  - **Push (Webhooks):** Real-time triggers for modern stacks (GitHub, Slack).
  - **Pull (Adaptive Polling):** Configurable polling for legacy or firewalled tools (Phorge, on-prem Bitbucket).
- **The Live Bus:** The API and clients stay synced via a WebSocket layer (dev: `ws://`, production typically `wss://`) for sub-second event propagation.

---

## 4. Engineering Intelligence: Automated Activity Logs

DAB transforms "Noise" into a searchable "Narrative." It automates the "What did I do today?" question for devs and leads alike.

- **Activity Attribution:** Automatically generates a chronological work log based on real-time events.
- **Visibility Without Micro-management:** Leads can monitor team velocity and meeting ROI using objective, sovereign data.

### Example Activity Log (March 3, 2026 — @John)
| Time | Provider | Activity |
|---|---|---|
| 09:12 | Phorge | Commented on **T2222** (*"Refactored event bus"*) |
| 11:34 | Jira | Updated **T1258** (*"Blocked by API latency"*) |
| 14:05 | Slack | Huddle — 24m with @Jenny (Topic: Schema Migration) |
| 16:22 | Teams | Meeting with @Robert (*"Includes searchable transcription"*) |

---

## 5. Open Source & The "Thermal" Roadmap

- **Auditability:** Open-source allows your security team to verify encryption primitives and data handling.
- **Temperature-Based Prioritization:** Features are sorted by "Temperature" (Community Heat):
  - **Hot:** High-demand integrations (Linear, GitHub Actions) or critical bug fixes.
  - **Cold:** Niche UI tweaks or rare provider requests.
- **Extensibility:** Adding a custom internal tool is as simple as implementing **`AbsIActivitySource<T>`**, defining the payload shape under **`domain/dtos/`**, adding **`extension OnTDto`** with **`toActivities`**, and registering a **`TypedConnectorPair<T>`**.

---

## 6. Tech Stack Summary

| Concern | Technology |
|---|---|
| API Runtime | Dart + Relic HTTP framework |
| API DB | PostgreSQL (via Drift ORM) |
| API Cache | Redis (Vegas versional clock) |
| API Transport | WebSocket (WSS) + REST |
| App Framework | Flutter |
| App State | flutter_riverpod (`Notifier` / `NotifierProvider`) |
| App Navigation | go_router |
| App Local Storage | ObjectBox |
| App Networking | Dio + WebSocket (`web_socket_channel`) |
| Serialization | dart_mappable (both packages) |
| Error Handling | fpdart `Either<Failure, T>` |
| Deployment | Docker Compose |

---

## 7. Provider Roadmap

| Provider | Status | Notes |
|---|---|---|
| Phorge | ✅ Active | Maniphest Tasks + Differential Revisions; Herald webhook live path |
| GitHub | ✅ Active (Commits v1) | Issues/PR timeline still planned; push webhook live path |
| GitLab | ✅ Active (Commits v1) | REST polling + Push Hook webhook live path |
| Bitbucket | ✅ Active (Commits v1) | REST polling + `repo:push` webhook live path |
| Slack | ✅ Active (Messages v1) | Identity-scoped Slack message ingestion; Events API live path |
| Jira | ✅ Active (issues + comments v1) | REST `/rest/api/3/search/jql` polling + identity discovery (`DAB-79`); webhook live path |
| Linear | ✅ Active (issues + comments v1) | GraphQL polling + signed webhook live path |
| Discord | ✅ Active (messages v1) | REST polling + Gateway WebSocket live path |
| Microsoft Teams | 🔜 Planned | Removed from v1; Graph change notifications operationally heavy |
