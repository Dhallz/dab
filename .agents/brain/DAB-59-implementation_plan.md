---

## issue: DAB-59

title: "[API] Implement GitHub activity provider"
request_feedback: true
linear_url: [https://linear.app/dev-activity-board/issue/DAB-59/api-implement-github-activity-provider](https://linear.app/dev-activity-board/issue/DAB-59/api-implement-github-activity-provider)
status: Backlog

# DAB-59 — GitHub activity provider (implementation plan)

## Summary

Ship a **read-only** GitHub connector using the existing **Source + Mapper** pattern, persist commit metadata via a new **table-per-type (TBT)** child table, hydrate `GitHubCommitProvider` from the database, wire **DI** and (where needed) **admin config / connectivity test**, and align **docs + Bruno + OpenAPI**. **v1 scope:** commits only; PRs/issues remain follow-up unless PO expands in-issue.

**Multi-provider rule:** Activity fetching does **not** assume Phorge. Any tenant may use **only** Jira, **only** GitHub, etc. **Linked `user_identities`** are the **sole** way a DAB user participates in a connector’s fetch; there is **no** special-case fallback to `User.phorgePhid` in the fetcher or sources.

**How this maps to “a list of links”:** Each DAB `[User](dab_api/lib/src/domain/entities/user/user.dart)` has **zero or more** `[UserIdentity](dab_api/lib/src/domain/entities/user/user_identity.dart)` rows — one per **provider** they have linked (e.g. `provider_id: 'phorge'`, `external_id: <PHID>`; `provider_id: 'github'`, `external_id: <login>`; etc.). The Phorge PHID is **one such row**, not a separate activity-time source of truth.

**No `LinkedUser` / `LinkedId` type (v1):** Keep `[IActivitySource.fetchRawData](dab_api/lib/src/infrastructure/sources/i_activity_source.dart)` as `List<User>`. The fetcher **narrows** that list to users who have a **linked** identity for the connector’s `provider_id`; each **source** resolves `external_id` via injected `**IUserRepository`**, preferably using a **single batch** query per provider (`getIdentitiesForUsersAndProvider` or equivalent) to avoid N round-trips. Introduce a dedicated `(User, externalId)` DTO **only** if this becomes unwieldy in a later refactor.

**Follow-up (separate ticket):** After registration/admin flows read/write Phorge solely via `user_identities`, **remove `phorgePhid` and `phorgeUsername` from the `User` entity** (and DB columns) to avoid duplication and confusion.

## Current codebase anchors

- **Registry:** `ConnectorRegistry` + registrations in `dab_api/lib/src/service_locator.dart` — GitHub is **not** registered today; scaffolds (Slack, Linear, …) are registered but see **provider id mismatch** below.
- **Hydration gap:** `ActivityRepository._mapRowToActivity` uses `const GitHubCommitProvider()` for `provider_name == 'github'`, ignoring metadata; `createActivity` has no GitHub branch (comment says “Add more providers”).
- **Fetcher gate (blocker):** `UnifiedActivityFetcher.fetchAll` sets `validUsers = users.where((u) => u.phorgePhid != null)`. That incorrectly ties **all** connectors to Phorge PHIDs. Replacement: scope by **DAB user IDs** (the `User` list already resolved upstream) and use `**user_identities`** (`provider_id` + `external_id`, `UserIdentityStatus.linked`) as the link to each provider.
- **Provider config:** Seed row `id: 'github'` exists in `app_database.dart` `beforeOpen`; settings stored as JSON on `provider_configs.settings`.
- **Domain/API model:** `GitHubCommitProvider` already has `repo`, `branch` (`dab_api` / `dab_app`). Optional **v1 addition:** `sha` (nullable) for stable deep links — aligns with `doc/architecture.md` / `doc/infrastructure.md` “sha” mentions; coordinate naming with TBT columns.
- **Docs today:** `doc/architecture.md` / `doc/infrastructure.md` reference `activity_github` as **planned**; issue text prefers `activity_github_commit` — **pick one table name** and update both docs for consistency.

## Proposed changes by component

### 1. Application — `UnifiedActivityFetcher` (DAB users + identities)

**Contract**

- **Input scope:** The `users` argument is already the set of **DAB users** to consider (typically from `SearchActivities` resolving `targetUserIds`). The fetcher does **not** gate the whole pipeline on `User.phorgePhid`; it **narrows** that list **per connector** using `**user_identities`**.

**Per-connector filtering**

1. After resolving `activeProviderIds` from `provider_configs`, for each `ConnectorPair` whose `mapper.providerName` matches an active config id (normalize casing if needed — see cleanup below).
2. **Build** `usersForConnector` = DAB users in `users` who have a `**user_identities`** row for `provider_id == mapper.providerName` (same string as `provider_configs.id`, e.g. `github`, `phorge`) with `**UserIdentityStatus.linked`** (exclude `pending`/`failed` unless product explicitly allows).
3. If `usersForConnector` is **empty**, **skip** that pair’s `fetchRawData` (treat as `[]` for that connector).
4. Pass `**usersForConnector`** as `List<User>` into `fetchRawData` (signature unchanged). Each source loads `**external_id`** values via `**IUserRepository`** (batch API preferred); no new wrapper type.

**No Phorge-first legacy in the activity pipeline**

- **Phorge** is the same as any other provider: a user is eligible **only** if they have a **linked** `user_identities` row with `provider_id == 'phorge'` (same canonical id as `provider_configs` seeds in `app_database.dart`) and `external_id` = Phorge PHID. `**PhorgeTaskSource` / `PhorgeRevisionSource` must use that `external_id` only** — do not read `User.phorgePhid` for fetch eligibility or API constraints.
- `**User.phorgePhid` / `phorgeUsername`:** May remain temporarily for registration/sync helpers while those paths are migrated to identities; **UnifiedActivityFetcher and all `IActivitySource` implementations must not use them.** Track removal under a **follow-up issue** (see Summary).
- **Existing deployments:** Users who historically have `users.phorge_phid` populated but **no** `user_identities` row need a **one-time backfill** (migration or admin script) so Phorge fetch keeps working after this change. Document in `doc/infrastructure.md` or release notes.

**Error handling**

- **Pragmatic v1:** keep `IActivitySource.fetchRawData` as `Future<List<T>>`; sources should not throw out of the fetcher boundary (or retain fetcher-level `try/catch`). Optional later: `Either` / `AppFailure` on sources.

### 2. Domain

- `**IActivityMapper` implementation:** `GitHubCommitMapper` (or `GitHubCommitActivityMapper`) in e.g. `lib/src/domain/mappers/github/`.
  - `providerName` **must** be `'github'` (lowercase) to match `provider_configs.id` and `UnifiedActivityFetcher`’s `activeProviderIds.contains(pair.mapper.providerName)`.
- `**GitHubCommitProvider`:** Add optional `sha` if we persist it (recommended for URLs and dedup). Regenerate `*.mapper.dart` (both API and App if App entity changes).
- **Pure mapping:** Map infrastructure DTO → `Activity` + `GitHubCommitProvider`; set `**userId`** by matching the commit author to the **DAB user** (same `usersForConnector` / identity `external_id` set the source used, or **email** fallback when GitHub exposes it — see table below). `IActivityMapper.mapToActivities` keeps receiving `List<User>` consistent with that filtered set.

### 3. Infrastructure — GitHub source + DTOs

- **New folder:** `dab_api/lib/src/infrastructure/sources/github/`
  - `github_commit_source.dart` implementing `IActivitySource<GitHubCommitDto>` (exact DTO name TBD).
  - Colocated `@MappableClass` DTOs for API payloads (e.g. commit list item, author, commit meta) under `infrastructure/dtos/github/` **or** colocated per package rule — mirror `linear/` / `phorge/` layout.
- **Config injection:** Source needs **token and scope** from admin config, not env. Inject `AbsIProviderConfigRepository` (or a narrow `GitHubConfigReader` port implemented in infra). At `fetchRawData` start: load `github` config; if inactive or missing token, return `[]`.
- **Suggested `settings` keys** (document in `doc/api.md`):
  - `api.token` or `token` — PAT (reuse Phorge-style dual key pattern from `metadata_controller` if helpful).
  - `owner` + `repo` for **single-repo v1**, **or** `repos` as structured list for multi-repo — **trade-off** in open questions.
  - Optional: `apiBaseUrl` default `https://api.github.com`.
- **GitHub REST (read-only):** e.g. `GET /repos/{owner}/{repo}/commits` with `since` / `until` mapped from `start`/`end`, and `author` when `authoredOnly` and login known.
- **No writes** to GitHub (comments, merges, status) — verify no POST/PATCH/DELETE.

### 4. Infrastructure — Drift / PostgreSQL

- **New table** `activity_github_commit` (name per issue; update docs if we keep `activity_github` instead):
  - `activity_id` PK/FK → `activities.id` ON DELETE CASCADE (mirror `activity_phorge`).
  - Columns: `repo`, `branch` (nullable if unknown), `sha` (recommended), `created_at` / `updated_at` per Drift rules.
- `**AppDatabase`:** Register table, bump `schemaVersion`, add `onUpgrade` migration (and raw SQL if needed for existing deployments).
- `**ActivityRepository`:**
  - `createActivity`: when `provider is GitHubCommitProvider`, insert child row.
  - `getRecentActivities` / `getActivitiesByUser`: second `leftOuterJoin` to `activity_github_commit` (Drift may need careful aliasing / multiple joins — mirror pattern used elsewhere or use separate read helpers).
  - `_mapRowToActivity`: if `pName == 'github'` and child row present, `GitHubCommitProvider(repo: …, branch: …, sha: …)`; if missing child row, fallback to generic or empty metadata (define behavior in tests).

### 5. DI & discovery

- `**service_locator.dart`:**
  - Construct `GitHubCommitSource` with required deps.
  - Register `GitHubCommitMapper`.
  - `registry.register(githubCommitSource, githubCommitMapper)`.
- `**IdentityDiscoveryService`:** Add `'github':` entry when implementing `IDiscoverySource` for GitHub so admins can **discover** candidate `external_id` (login) from name/email; linking still goes through existing **link identity** flows. Commits-only v1 can still **attribute** activities using email when the API returns it, but **authored-only fetch** should rely on **linked** identities for `author=` filters.

### 6. Presentation — admin / metadata

- `**metadata_controller.dart` `testConfig`:** For `config.id == 'github'`, call `GET https://api.github.com/user` with `Authorization: Bearer <token>`, return success message with login (no token in response body). Align with Phorge branch style (timeout, clear errors).
- **Thin controllers only** — no new business logic beyond parsing and delegation.

### 7. Client (`dab_app`)

- Only if API JSON shape for `provider` changes (e.g. new `sha` on `GitHubCommitProvider`): run `build_runner`, verify `provider_styles` / `activity_card` / tests (`activity_card_test.dart` already uses `GitHubCommitProvider`).

### 8. Documentation & API artifacts

- `**doc/api.md`:** Provider roadmap — GitHub from “Planned” to shipped; document `settings` keys and behavior.
- `**doc/architecture.md`:** Data flow + entity/TBT description; align table name and columns.
- `**doc/infrastructure.md`:** Schema section — replace “planned” with actual columns.
- `**bruno/`** + `**doc/openapi.yaml`:** Update if `testConfig` or any public contract changes (e.g. new example fields in provider config).

## Identity & authored vs explorer (design)

**Principle:** External systems are reached using `**user_identities.external_id`** keyed by `**provider_id`** equal to the connector / `provider_configs.id`. The fetcher’s job is to **restrict to DAB users in scope** who have a **linked** identity for that provider; sources/mappers use that mapping for API parameters and attribution. **No provider is special-cased:** a Jira-only org never needs Phorge fields; Phorge-only activity requires the same identity link as GitHub.


| Mode                                   | Proposed v1 behavior                                                                                                                                                                                                                                                                                                                                                             |
| -------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **authoredOnly**                       | **Fetcher** passes only users with **linked** `github` identity. **Source** uses each user’s `external_id` as GitHub **login** for `author=` (or equivalent) on the commits API. **Mapper** sets `Activity.userId` to the DAB user whose `external_id` matches the commit author login; optional email fallback when GitHub returns `author.email` and it matches `User.email`.  |
| **Explorer (`authoredOnly == false`)** | List commits for configured repo(s) in the window **without** an author filter; **mapper** attributes to a DAB user when commit author login matches a **linked** `external_id` for one of the **target** users (same ID set as the search). If no match, either omit from results or use an explicit **unattributed** policy — **product decision** (document in `doc/api.md`). |


Document identity requirements (“users must link GitHub before authored search returns their commits”) in `**doc/api.md`** / `**doc/architecture.md`**.

## Related cleanup (recommended in same PR or tiny follow-up)

- **Scaffold mappers** use `providerName` values like `'Slack'`, `'Linear'` while `provider_configs` seeds use lowercase ids (`slack`, `linear`). `activeProviderIds.contains(pair.mapper.providerName)` is **false** for those pairs today. Either normalize mapper names to **lowercase ids** or normalize comparison — **fix alongside GitHub** to avoid repeating the bug.

## Files to touch (expected)


| Action      | Path                                                                                                                                                                                                                    |
| ----------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Create      | `dab_api/lib/src/infrastructure/sources/github/github_commit_source.dart`                                                                                                                                               |
| Create      | `dab_api/lib/src/infrastructure/dtos/github/*.dart` (DTOs)                                                                                                                                                              |
| Create      | `dab_api/lib/src/domain/mappers/github/github_commit_mapper.dart`                                                                                                                                                       |
| Create      | `dab_api/lib/src/infrastructure/database/tables/activity_github_commit_table.dart` (name final TBD)                                                                                                                     |
| Modify      | `dab_api/lib/src/infrastructure/database/app_database.dart`                                                                                                                                                             |
| Modify      | `dab_api/lib/src/infrastructure/repositories/activity_repository.dart`                                                                                                                                                  |
| Modify      | `dab_api/lib/src/application/services/unified_activity_fetcher.dart` — inject `IUserRepository` (or narrow port); per-pair filter by linked identities; optional batch identity API                                     |
| Modify      | `dab_api/lib/src/domain/repositories/abs_i_user_repository.dart` + `user_repository.dart` — optional `getIdentitiesForUsersAndProvider` (or equivalent) to avoid N lookups                                              |
| Modify      | `dab_api/lib/src/service_locator.dart`                                                                                                                                                                                  |
| Modify      | `dab_api/lib/src/presentation/controllers/metadata_controller.dart`                                                                                                                                                     |
| Modify      | `dab_api/lib/src/infrastructure/sources/phorge/phorge_task_source.dart` (and revision source) — use **only** PHID from `**user_identities`** for passed-in users (fetcher already filtered to linked Phorge identities) |
| Modify      | `doc/api.md`, `doc/architecture.md`, `doc/infrastructure.md`                                                                                                                                                            |
| Optional    | `dab_api/lib/src/application/services/identity_discovery_service.dart` + register GitHub discovery                                                                                                                      |
| Conditional | `dab_app/lib/domain/entities/activity/activity_provider.dart` + generated mapper if `sha` added                                                                                                                         |
| Tests       | New unit tests: mapper, source (mock HTTP or repo), repository mapping with join                                                                                                                                        |


## Verification steps

1. `cd dab_api && dart analyze` — zero issues.
2. `dart run build_runner build --delete-conflicting-outputs` after Drift / mappable changes.
3. `dart test` — full package; new tests with **mocktail** + `**TestData`** factories.
4. Manual: activate `github` in admin, set PAT + owner/repo, run **Test connection**; call activity **search** with date range including known commits; confirm JSON `provider` includes `repo`/`branch`/`sha` as designed.
5. Manual: insert activity via path that uses `createActivity` with `GitHubCommitProvider` (e.g. `LogActivity` if wired) and confirm **GET /activities** hydrates child metadata.
6. If Bruno/OpenAPI updated, spot-check collection runs against local API.

## Open questions / trade-offs

1. **Table name:** `activity_github_commit` (issue) vs `activity_github` (existing doc) — single canonical name for SQL + docs.
2. **Multi-repo v1:** Single `owner/repo` vs list — affects settings schema and API rate limits.
3. **Explorer mode attribution** when no user matches — needs product default.
4. `**IActivitySource` + `UnifiedActivityFetcher` error model:** keep `Future<List<T>>` + no throw from sources, or migrate to `Either` (cross-cutting).
5. **Normalize `providerName` for all mappers** in this ticket vs separate **DAB-xx** chore.
6. **Persistence of search results:** Search endpoint currently returns remote results without writing to `activities`. Confirm whether “persist” in acceptance criteria means **TBT on write paths only** or requires a **sync-to-DB** step (out of scope unless PO confirms).
7. **Canonical Phorge `provider_id`:** Use a single id everywhere (`phorge` matches seeds and `register_user`); avoid `phabricator` unless you rename consistently across DB + code.
8. **Backfill:** Script or migration to create linked `user_identities` from legacy `users.phorge_phid` where missing — scope as part of this change or a prerequisite ticket so existing tenants are not broken.

---

**Next step:** Please review / approve this plan or note changes (especially v1 repo scope, explorer attribution, and TBT naming). Implementation should not start until you sign off per `@plan` workflow.