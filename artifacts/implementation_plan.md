# API Unit Testing Completion Plan

### [NEW] [test_factories.dart](file:///Users/dhallz/git/dab/dab_api/test/test_factories.dart)
A central location for "Object Mother" pattern factories to generate realistic test data.

## Phase 41: Test Data Infrastructure 🏗️
- [ ] Create `TestData` class with static factories for:
    - [ ] `User` entities with realistic roles and metadata.
    - [ ] `Activity` entities for Slack, Phorge, and GitHub.
    - [ ] `AuthToken` pairs for controller testing.
- [ ] Refactor existing tests to use `TestData` factories.

## Proposed Changes

### Application Layer (Services)

#### [NEW] [logging_service_test.dart](file:///Users/dhallz/git/dab/dab_api/test/application/logging_service_test.dart)
- Test `RequestLogger` middleware behavior.
- Verify `X-Request-ID` propagation.

#### [NEW] [presence_service_test.dart](file:///Users/dhallz/git/dab/dab_api/test/application/presence_service_test.dart)
- Mock `RelicWebSocket`.
- Test session management (`addSession`, `removeSession`).
- Verify `broadcast` calls `trySendText` on all sessions.

#### [NEW] [push_notification_service_test.dart](file:///Users/dhallz/git/dab/dab_api/test/application/push_notification_service_test.dart)
- Mock `NotificationProvider`.
- Test `notify` with provider (delegation).
- Test `notify` without provider (safe drop).

### Presentation Layer (Controllers)

#### [NEW] [auth_controller_test.dart](file:///Users/dhallz/git/dab/dab_api/test/presentation/controllers/auth_controller_test.dart)
- Mock `AuthService`.
- Test `register` (success, failure, validation).
- Test `login` (success, unauthorized, validation).

#### [NEW] [activity_controller_test.dart](file:///Users/dhallz/git/dab/dab_api/test/presentation/controllers/activity_controller_test.dart)
- Mock `ActivityService`, `PresenceService`, and `RedisService`.
- Test `getActivities` (Envelope pattern, syncToken).
- Test `createMock`.

#### [NEW] [health_controller_test.dart](file:///Users/dhallz/git/dab/dab_api/test/presentation/controllers/health_controller_test.dart)
- Test `check` behavior (mock `PostgresClient` if possible, or verify response structure).

## Verification Plan

### Automated Tests
- Run all tests using:
  ```bash
  dart test
  ```
- Verify 100% pass rate.
