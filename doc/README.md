# DAB — Documentation

This folder is the **single source of truth** for project documentation. Package
READMEs (`README.md`, `dab_api/README.md`, `dab_app/README.md`) are onboarding
only; they must not contradict these files.

---

## Document index

| File | Contents |
|---|---|
| [overview.md](./overview.md) | Product problem, solution, provider status |
| [architecture.md](./architecture.md) | Clean Architecture, entities, cross-package data flow |
| [api.md](./api.md) | `dab_api` layers, controllers, provider ingestion |
| [app.md](./app.md) | `dab_app` layers, views, Riverpod, design system |
| [infrastructure.md](./infrastructure.md) | PostgreSQL, Redis, WebSocket, Docker |
| [deployment.md](./deployment.md) | Local Compose and Railway |
| [conventions.md](./conventions.md) | Naming, stack, testing |
| [openapi.yaml](./openapi.yaml) | HTTP contract (aligned with `bruno/` and `dab_api` routes) |

---

## Maintenance

After a change that affects architecture, public API, entities, views, or
conventions, update the matching file in the same PR. See
[`.agents/rules/doc-maintenance.md`](../.agents/rules/doc-maintenance.md).

Do not add ad-hoc docs outside `doc/`. Plans and working notes belong in
`.agents/brain/`, not here.

---

## Related sources

- **Linear project:** [DAB – Dev Activity Board](https://linear.app/dev-activity-board/project/dab-dev-activity-board-724c38eaef1b)
- **Linear documents** (historical copies; **this folder wins** if they diverge):
  - [Dab Infrastructure](https://linear.app/dev-activity-board/document/dab-infrastructure-339365576c10)
  - [Dab API](https://linear.app/dev-activity-board/document/dab-api-8608282c089c)
  - [Dab Client](https://linear.app/dev-activity-board/document/dab-client-05e24723cfe7)
  - [Code Conventions](https://linear.app/dev-activity-board/document/code-conventions-d237039dad44)
