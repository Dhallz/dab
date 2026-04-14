# DAB — Dev Activity Board · Documentation

> **The Open-Source, Self-Hosted Event Bus for Modern Engineering Teams**

This folder is the **single source of truth** for all project documentation.  
It is maintained as part of the codebase and must be kept up to date with every meaningful change.

---

## 📚 Document Index

| File | Description |
|---|---|
| [overview.md](./overview.md) | What DAB is, the problem it solves, and the high-level design |
| [architecture.md](./architecture.md) | Full cross-package architecture, layer rules, and data flow |
| [api.md](./api.md) | DAB API (backend) — layers, patterns, endpoints, DI |
| [app.md](./app.md) | DAB App (Flutter client) — layers, BLoC, routing, design system |
| [infrastructure.md](./infrastructure.md) | Infrastructure stack — PostgreSQL, Redis, WebSocket, Docker |
| [conventions.md](./conventions.md) | Coding standards and naming rules for both packages |
| [openapi.yaml](./openapi.yaml) | OpenAPI contract aligned with Bruno API definitions |

---

## 🔄 Doc Maintenance Rule

Documentation in this folder is **living code**.  
After any change that affects architecture, public API contracts, entities, or conventions, the relevant doc file **must** be updated in the same commit / PR.

See [`.agents/rules/doc-maintenance.md`](../.agents/rules/doc-maintenance.md) for the enforced agent rule.

---

## 🔗 Canonical Sources

- **Linear Project**: [DAB – Dev Activity Board](https://linear.app/dev-activity-board/project/dab-dev-activity-board-724c38eaef1b)
- **Linear Documents** (master copies synced into this folder):
  - [Dab Infrastructure](https://linear.app/dev-activity-board/document/dab-infrastructure-339365576c10)
  - [Dab API](https://linear.app/dev-activity-board/document/dab-api-8608282c089c)
  - [Dab Client](https://linear.app/dev-activity-board/document/dab-client-05e24723cfe7)
  - [Code Conventions](https://linear.app/dev-activity-board/document/code-conventions-d237039dad44)
