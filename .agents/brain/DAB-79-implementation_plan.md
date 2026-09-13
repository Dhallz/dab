# DAB-79 Implementation plan — Jira Cloud polling

Linear: [DAB-79](https://linear.app/dev-activity-board/issue/DAB-79/api-jira-cloud-issue-polling-source-map-persistence-discovery)

## Context

Implement read-only **Jira Cloud REST API v3** issue search polling through existing **`IActivitySource` / `ConnectorRegistry` / `UnifiedActivityFetcher`** path. Anchor reference: **`GitHubCommitSource`** (config + identities + JSON REST + attribution on DTO).

## Decisions

- **Timestamps:** JQL constrains **`updated`** with UTC literals `yyyy-MM-dd HH:mm`.
- **Auth:** Basic auth (**Atlassian email** + **API token**) from provider `settings` (`api.email`, `api.token`); Site URL from `ProviderConfig.baseUrl` (normalized `*.atlassian.net`).
- **Scope:** **`projectKeys`** in settings (`"PROJ,OPS"` comma-separated); optional **`extraJql`** appended with `AND` (must never start with trailing AND from user typo).
- **Category:** **`ActivityCategory.task`** / domain category **`task`** — avoids new enum value across Insights/Explorer switches.
- **Stable activity id:** `Uuid.v5(Namespace.url, '$siteHost|$issueKey')`.

## Layers

| Area | Actions |
|---|---|
| Infrastructure | New `activity_jira_issue_table`, migration **13**, `ActivityRepository` inserts + joins |
| Domain | Add `JiraIssueProvider`; expand `JiraIssueDto` + `OnJiraIssueDto.toActivities` |
| Infrastructure | Implement `JiraIssueSource`; pure `buildIssuesSearchJql` in `jira_jql.dart` |
| App | Mirror `ActivityProvider`; `providerFilterKey` + `_categoriesForProvider('jira')` |
| Docs | `doc/architecture.md`, `doc/api.md` — Jira config keys + ingestion |
