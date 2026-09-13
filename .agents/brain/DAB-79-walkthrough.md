# DAB-79 walkthrough — Jira Cloud polling

## Summary

Delivered **read-only Jira Cloud** issue ingestion for **`GET /activities/search`** (`UnifiedActivityFetcher` → `JiraIssueSource`): JQL **`updated`** window, **`JiraIssueDto` → `Activity`**, sealed **`JiraIssueProvider`**, **`activity_jira_issue`** Drift/TBT (+ migration **v13**), repository hydration/joins, **`IDiscoverySource`** via **`/rest/api/3/user/search`**, **`dab_app`** provider mirroring + provider filter/`jira` category defaults.

## Configure

Admin **`provider_configs`** row **`jira`** (active):

- **`baseUrl`:** `https://<your-site>.atlassian.net`
- **`settings.api.email`**, **`settings.api.token`** (Atlassian Cloud API token)
- **`settings.projectKeys`:** comma/newline-separated keys (e.g. `DAB,OPS`)
- Optional **`settings.extraJql`** (appended as `AND (…)`)

Link users with **`user_identities`** `provider_id: jira`, `external_id` = Atlassian account id.

## Verification

- `dart analyze` + `dart test` in **`dab_api`**
- `flutter test test/infrastructure/datasources/activity_search_query_mapper_test.dart` for client mapping

## Artifact index

| Path | Purpose |
|---|---|
| `.agents/brain/DAB-79-implementation_plan.md` | Design decisions |
| `.agents/brain/DAB-79-task.md` | Checklist |
