import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/views/admin/models/provider_connection_status.dart';
import 'package:dab_app/presentation/views/dashboard/models/dashboard_provider_health.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const slack = ProviderConfig(
    id: 'slack',
    name: 'Slack',
    baseUrl: 'https://slack.example.com',
    isActive: true,
  );
  const github = ProviderConfig(
    id: 'github',
    name: 'GitHub',
    baseUrl: 'https://github.example.com',
    isActive: true,
  );
  const jiraInactive = ProviderConfig(
    id: 'jira',
    name: 'Jira',
    baseUrl: 'https://jira.example.com',
    isActive: false,
  );

  test('lists every active provider even with no activities', () {
    final health = deriveDashboardProviderHealth(
      configs: [slack, github, jiraInactive],
      connectionStatuses: const {
        'slack': ProviderConnectionStatus(status: ViewStatus.success),
        'github': ProviderConnectionStatus(status: ViewStatus.success),
      },
      activities: const [],
    );

    expect(health.map((row) => row.providerName), ['GitHub', 'Slack']);
    expect(
      health.map((row) => row.status),
      everyElement(DashboardProviderHealthStatus.live),
    );
    expect(health.every((row) => row.lastEventAt == null), isTrue);
  });

  test('quiet successful provider stays live', () {
    final health = deriveDashboardProviderHealth(
      configs: [github],
      connectionStatuses: const {
        'github': ProviderConnectionStatus(status: ViewStatus.success),
      },
      activities: const [],
    );

    expect(health.single.status, DashboardProviderHealthStatus.live);
  });

  test('unknown connection status is treated as live', () {
    final health = deriveDashboardProviderHealth(
      configs: [slack],
      connectionStatuses: const {},
      activities: const [],
    );

    expect(health.single.status, DashboardProviderHealthStatus.live);
  });

  test('maps warning to degraded and failure to offline', () {
    final health = deriveDashboardProviderHealth(
      configs: [slack, github],
      connectionStatuses: const {
        'slack': ProviderConnectionStatus(status: ViewStatus.warning),
        'github': ProviderConnectionStatus(status: ViewStatus.failure),
      },
      activities: const [],
    );

    expect(
      health.firstWhere((row) => row.providerName == 'GitHub').status,
      DashboardProviderHealthStatus.offline,
    );
    expect(
      health.firstWhere((row) => row.providerName == 'Slack').status,
      DashboardProviderHealthStatus.degraded,
    );
  });

  test('attaches lastEventAt from matching live activities', () {
    final lastSlack = DateTime.utc(2026, 8, 15, 16);
    final health = deriveDashboardProviderHealth(
      configs: [slack, github],
      connectionStatuses: const {
        'slack': ProviderConnectionStatus(status: ViewStatus.success),
        'github': ProviderConnectionStatus(status: ViewStatus.success),
      },
      activities: [
        Activity(
          id: 'a-1',
          userId: 'u-1',
          provider: const SlackMessageProvider(channelId: 'C1'),
          title: 'hi',
          content: 'hello',
          authorName: 'Alice',
          commentCount: 0,
          createdAt: lastSlack,
        ),
      ],
    );

    expect(
      health.firstWhere((row) => row.providerName == 'Slack').lastEventAt,
      lastSlack,
    );
    expect(
      health.firstWhere((row) => row.providerName == 'GitHub').lastEventAt,
      isNull,
    );
    expect(
      health.firstWhere((row) => row.providerName == 'GitHub').status,
      DashboardProviderHealthStatus.live,
    );
  });
}
