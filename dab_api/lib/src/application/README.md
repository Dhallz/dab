# Application layer

Coordinates Domain rules and Infrastructure through ports and repositories.

- **Services:** `UnifiedActivityFetcher`, `ConnectorRegistry`, `LiveIngestPersister`, `ActivityLivePublisher`, `IdentityDiscoveryService`.
- **Use cases:** One class per action; controllers call these only.
- **Registration:** `lib/src/service_locator.dart`. Connector pairs are registered as **`TypedConnectorPair<T>`** (`AbsIActivityPort<T>` + `providerId` + `mapItemToActivities`).

No SQL and no HTTP protocol encoding here. Mapping rules stay on Domain DTO extensions.

`ActivityLivePollScheduler` is retained so DI and start/stop stay stable. It does **not** publish authored poll rows into the live inbox.
