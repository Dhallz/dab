# Local provider secrets (Bruno)

Use this folder after a **database reset** to repopulate Admin provider settings without hunting for tokens in the UI.

## Setup (one time)

1. Copy the template into the gitignored working folder:

   ```bash
   cp -R bruno/local-secrets.example bruno/local-secrets
   ```

2. Copy the secrets environment:

   ```bash
   cp bruno/environments/local-secrets.bru.example bruno/environments/local-secrets.bru
   ```

3. Edit `bruno/environments/local-secrets.bru` and fill in your real values.

4. In Bruno, select the **`local-secrets`** environment (or merge those vars into your existing `local` environment).

## Run order

Execute requests in `bruno/local-secrets/` **in sequence**:

| Step | Request | Purpose |
|------|---------|---------|
| 00 | Register | Bootstrap admin (skip if users already exist — use Login) |
| 01 | Login | Capture `accessToken` |
| 02 | Save system settings | `public_api_url`, timezone, domain gate |
| 03 | Pick target user | Sets `targetUserId` for identity linking |
| 04 | Webhook endpoints | Prints `*WebhookUrl` vars from `publicApiUrl` |
| 10–18 | Save *provider* | One request per provider you use |
| 20–28 | Link identity | Optional — map DAB users to provider external IDs |
| 90 | Verify configs | `GET /admin/configs` smoke check |
| 91 | Test all providers | Optional — `POST /admin/configs/test` per provider |

Provider save requests only touch providers you configure in the environment (empty optional fields are omitted).

### Webhook URLs

DAB does **not** store per-provider webhook endpoint URLs. They are **derived** from
`public_api_url` (step **02**) plus a fixed path (e.g. `/integrations/github/webhook`).
The Admin app shows that URL **read-only** in each provider’s Live section — configure
the URL on **GitHub/Slack/etc.**, and save only the **shared secret** in DAB.

After step **02** or **04**, Bruno sets copy-reference vars like `githubWebhookUrl`.
Each provider save request (10–16) logs the URL to the console. Discord has no HTTP webhook.

**Figma live webhooks** are registered in Figma (`POST /v2/webhooks`), not DAB.
After saving Figma config (step **18**), run `bruno/figma/create-webhook-file-comment`
then `create-webhook-file-update` with `local-secrets` selected. Set
`figmaWebhookWriteToken` (`webhooks:write`, short TTL), `figmaTeamId`,
`figmaWebhookSecret` (must match Admin Live), and `figmaWebhookUrl` (HTTPS).
Revoke the write token and clear `figmaWebhookWriteToken` after both requests succeed.

## Git safety

- `bruno/local-secrets/` and `bruno/environments/local-secrets.bru` are **gitignored**.
- Only `local-secrets.example/` and `local-secrets.bru.example` are committed (placeholders only).
