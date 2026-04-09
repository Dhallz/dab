---
trigger: glob
globs: /postman/
---

# Postman — Folder-Specific Rules

> These rules are additive to the global rules in `/dab/.agents/rules.md`.  
> When in conflict, the global rules take precedence.

---

## 📦 Folder Identity

This folder contains all Postman workspace artefacts for the DAB API, organized for use with the **Postman MCP server**.

```
postman/
├── collections/    ← Exported Postman collections (JSON)
├── environments/   ← Environment variable sets (local, staging, prod)
├── flows/          ← Postman Flows definitions
├── globals/        ← Workspace-level global variables
├── mocks/          ← Mock server definitions
└── specs/          ← OpenAPI / AsyncAPI specification files
```

---

## 🧪 Collections

- Collections are versioned alongside the API code. When an endpoint changes in `dab_api`, update the corresponding collection request.
- All requests must use **environment variables** for base URL, tokens, and UUIDs — no hardcoded values.
- Group requests into folders that mirror the API controller structure (e.g., `Auth`, `Activities`, `Admin`, `Providers`).
- Every request should have at least one **test script** asserting the expected status code.
- Use `pm.environment.set()` in response scripts to chain tokens/IDs between requests (e.g., store `access_token` after login).

---

## 🌍 Environments

| Environment | Base URL variable | Notes |
|---|---|---|
| `local` | `http://localhost:8080` | Docker Compose stack |
| `staging` | TBD | When a staging server exists |

- Never commit real credentials. Use descriptive placeholder values (e.g., `<your-token-here>`).
- The `local` environment is the primary development environment.

---

## 📄 Specs

- The canonical OpenAPI spec is `dab_api/openapi.yaml` at the API root. The copy in `postman/specs/` is a mirror for Postman Spec Hub sync.
- When updating the spec, keep both in sync or use the MCP `syncSpecWithCollection` / `syncCollectionWithSpec` tools.
- Spec type: `OPENAPI:3.0`.

---

## 🤖 Agent Behaviour (Postman-Specific)

- Use the **Postman MCP server tools** (`createCollection`, `updateCollectionRequest`, `runCollection`, etc.) rather than manually editing JSON files.
- When asked to test an endpoint, run the relevant collection or request via `runCollection` and report the results.
- When creating new collections, use the workspace ID from the existing DAB workspace — do not create stray personal workspace collections.
- Exported JSON files in `postman/collections/` are the source of truth for offline/CI use. Keep them up to date after any MCP-side changes by exporting.
