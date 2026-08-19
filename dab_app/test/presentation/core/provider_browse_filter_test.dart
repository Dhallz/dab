import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/core/provider_browse_filter.dart';
import 'package:dab_app/presentation/views/admin/models/provider_connection_status.dart';
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

  test('includes every active provider regardless of connection health', () {
    final result = browsableProviderConfigs([
      slack,
      github.copyWith(isActive: false),
      const ProviderConfig(
        id: 'jira',
        name: 'Jira',
        baseUrl: 'https://jira.example.com',
        isActive: true,
      ),
    ], {
      'slack': const ProviderConnectionStatus(status: ViewStatus.success),
      'jira': const ProviderConnectionStatus(status: ViewStatus.failure),
    });

    expect(result.map((config) => config.id), ['slack', 'jira']);
  });

  test('keeps untested, loading, and warning providers visible', () {
    final result = browsableProviderConfigs([
      slack,
      github,
    ], {
      'github': const ProviderConnectionStatus(status: ViewStatus.loading),
      'slack': const ProviderConnectionStatus(status: ViewStatus.warning),
    });

    expect(result.map((config) => config.id), ['slack', 'github']);
  });
}
