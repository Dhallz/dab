# DAB (Dev Activity Board) Overview 🍱 🚀

DAB is a centralized dashboard designed to aggregate and visualize developer activities across multiple platforms in a unified, chronological feed, specifically designed to **reduce "window clutter"** and foster team transparency.

## 🎯 Core Purpose & UX Philosophy
- **Transparency**: Provide 100% real-time visibility into team activity.
- **Efficiency**: Significantly reduce "status check" friction and manual coordination.
- **Focus**: Consolidate multiple tools (Slack, Jira, GitHub, Phorge) into a single feed to preserve screen real estate.
- **Visual Excellence**: Built with a **Glassmorphic** aesthetic, prioritizing depth, vibrant gradients, and staggered micro-animations to make high-density data feel accessible.
## 🏗️ Technology Pillars
1.  **Relic Framework**: A server-side Dart framework for high-performance, isolate-driven request handling.
2.  **Extreme-Perf Cache (Redis)**: Sub-50ms latencies for real-time dashboards using the **Vegas Sync Pattern**.
3.  **Clean Architecture**: A strictly layered codebase that separates domain entities from infrastructure concerns.
4.  **Drift ORM**: Type-safe relational persistence with AOT-generated row classes.

## 🏛️ Business Rules & Principles (Exhaustive)
- **Read-Only Principle**: DAB strictly functions as a data aggregator. It **never** writes, updates, deletes, or inserts data into external providers.
- **Team Transparency**: By default, activity from shared company resources (Slack channels, public repos, Jira boards) is visible to all authorized DAB users.
- **Domain Lockdown**: Restricted to a single organizational domain (e.g., `@acme.com`).
- **Normalization**: Every incoming event (Git Commit, Slack Message, Phorge Task) is mapped to a unified `Activity` entity with provider-specific metadata stored in relational child tables.
- **Archive Policy**: DAB "Cold Stores" daily metadata summaries for ephemeral providers (Slack/Teams) to ensure history persists beyond provider deletion/hiding windows.
- **Backend-First Methodology**: All features must have completed API endpoints and database migrations before UI work begins.

---

## 🔐 User Accounts & Initialization Flow

### 1. Initialization: The "First Admin" Pattern
To avoid complex bootstrap scripts, DAB uses a secure auto-promotion logic:
1.  **Env Config**: Deployment includes `DAB_INITIAL_ADMIN_EMAIL`.
2.  **Registration**: When a user registers with this exact email, the system automatically assigns the `Admin` role.
3.  **Handoff**: Any subsequent admin management occurs through the **Admin Console**.

### 2. Roles & Permissions Matrix
| Role | Goal | Key Permissions |
| :--- | :--- | :--- |
| **Viewer** | Passive Monitoring | Dashboard view, Stats view. |
| **Standard** | Daily Workflow | personal connections, custom alerts, history explorer. |
| **Team Lead** | Coordination | Team-level filters, team-wide alerts, cross-user history. |
| **Admin** | System Health | User lifecycle, global connector keys, audit logs. |

---

## 📡 Provider Specifications & Integration Strategy

### 1. Unified Connection Specs
DAB requires the following high-fidelity credentials for stable integration:
- **Phorge**: Conduit API Token + Base URL. Uses `maniphest.search` for task tracking.
- **Jira**: Site URL + Account Email + API Token. Uses JQL for filtered ingestion.
- **GitHub**: Personal Access Token (PAT) with `repo:read` and `user:read` scopes.
- **Slack**: Bot User OAuth Token (`xoxb-`). Requires `channels:history` and `groups:history` scopes.
- **Discord**: Bot Token with Gateway Intents for message tracking.

### 2. Phorge-Specific Business Logic (Historical Context)
- **ownerPHIDs**: DAB maps the Phorge `ownerPHID` directly to the `userId` in the DAB environment.
- **Filtering**: Default ingestion excludes "Closed" or "Archived" tasks unless specifically queried in the Historical Explorer.
- **Identity Mapping**: Users must link their Phorge PHID in settings for "Personal Backlog" views.
- **Migration 005**: Implements the `phorge_phid` and `phorge_username` fields in the `users` table for exact mapping.

---

## 🚀 Product Roadmap: The Evolution of DAB

### Phase 1: Foundation (COMPLETED)
- Real-time Activity Feed (WebSockets).
- Unified Auth (JWT) & Registration.
- Phorge & Slack basic connectors.

### Phase 2: Personal Workspace (IN PROGRESS)
- **Personal Backlog**: Dedicated widget for a user's own assigned tasks.
- **Multi-Filter Tabs**: Toggle between "My Feed", "Team Feed", and "Tool-Specific" views.

### Phase 3: Team Insights & Admin Console
- **Analytics Engine**: Velocity charts and tool usage statistics.
- **Team Management**: Leads can define "Squads" and aggregate feed per squad.
- **Global Audit**: Admin dashboard for system health and connector status.

---

## 📈 Scalability Parameters & Performance Targets
- **Worker Isolates**: Webhook processing is offloaded to background Dart isolates to prevent UI/API lag.
- **Redis Streams**: Used for reliable background task scheduling (e.g., periodic history polling).
- **Vegas Pattern**: Ensuring O(1) staleness checks for high-density clients.
- **Latency Target**: Sub-50ms end-to-end event propagation.
- **Concurrency**: Tested for 100+ concurrent developers per Relic instance.

