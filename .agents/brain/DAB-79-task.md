# DAB-79 task tracking

- [x] Plan artifact (`DAB-79-implementation_plan.md`)
- [x] Db: `activity_jira_issue` + schema 13 + repository joins/insert/hydrate
- [x] Domain: `JiraIssueProvider` + `JiraIssueDto` / `toActivities` + codegen
- [x] Infra: `JiraIssueSource` + `jira_jql.dart` + DI + discovery
- [x] dab_app: `JiraIssueProvider` + codegen + explorer/insights + `providerFilterKey`
- [x] Unit tests (`jira_jql`, `OnJiraIssueDto`, client mapper)
- [x] `dart analyze`; `dart test` (dab_api); targeted `flutter test` (dab_app)
- [x] Walkthrough (`DAB-79-walkthrough.md`)
- [x] `doc/` updates (`architecture`, `api`, `overview`)
