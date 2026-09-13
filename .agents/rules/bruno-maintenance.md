---
trigger: glob
description: Keep bruno/ collection in sync with API changes
globs: dab_api/lib/src/presentation/controllers/**/*.dart,dab_api/lib/src/domain/entities/**/*.dart,doc/openapi.yaml
---

# Bruno Maintenance Rule

The `bruno/` folder at the root of the DAB project contains the **canonical Bruno collection** for testing the DAB API. 

> [!IMPORTANT]
> **Primary Source of Truth**: Bruno is the definitive definition of the API's behavior and contracts. `doc/openapi.yaml` follows Bruno, never the other way around.

## When to Update the Collection

After completing any change that falls into the categories below, **you must update the relevant `.bru` file before declaring the task done**.

| Change Made | Action in `bruno/` |
|---|---|
| New API controller added | Create corresponding folder in `bruno/` |
| New endpoint/route added | Create new `.bru` request file in the correct folder |
| Request body or path changed | Update the `body:json` or `url` in the `.bru` file |
| New query parameter added | Update the `url` or `query` section in the `.bru` file |
| Auth requirements changed | Update the `auth` block (e.g., `inherit` or `bearer`) |
| Response schema changed | Update `script:post-response` or `tests` if they rely on the schema |

## 🔄 OpenAPI Synchronization

Whenever a Bruno definition is updated or created:
1.  **Reflect the change** in `doc/openapi.yaml`.
2.  Ensure `summary`, `description`, `requestBody`, and `examples` in OpenAPI match the Bruno definition.
3.  Verify the Swagger container picks up the change.

## How to Update

1.  **Mirror the Controllers:** The folder structure in `bruno/` should match the `dab_api/lib/src/presentation/controllers/` names (e.g., `admin/`, `auth/`, `activities/`).
2.  **Use Variables:** Always use `{{baseUrl}}` for the root URL. Never hardcode tokens or user-specific IDs; use variables like `{{accessToken}}` or `{{targetUserId}}`.
3.  **Variable Chaining:** If an endpoint returns an ID or token that is needed by other requests (e.g., login, create-item), use a `script:post-response` to set a variable:
    ```javascript
    bru.setEnvVar("targetId", res.body.data.id);
    ```
4.  **Descriptions & Examples**: Use the `docs` block in `.bru` files to provide a clear description of the endpoint. Use realistic examples in the `body:json` block.

## What Not to Do

- **Do not commit sensitive secrets.** Use environment variables and placeholders for actual secrets.
- **Do not use hardcoded local URLs** (e.g., `http://localhost:8080`). Use `{{baseUrl}}`.
- **Do not create "Duplicate" requests** for the same endpoint unless they serve a distinct, named test case.

## Collection Ownership

The collection is shared across the team. Major structural changes to the `collection.bru` or environment files should be flagged to the user.