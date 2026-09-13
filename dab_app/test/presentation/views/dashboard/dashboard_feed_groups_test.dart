import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/activity/activity_category.dart';
import 'package:dab_app/presentation/views/dashboard/models/dashboard_feed_group.dart';
import 'package:dab_app/presentation/views/dashboard/models/dashboard_provider_health.dart';
import 'package:flutter_test/flutter_test.dart';

Activity _activity({
  required String id,
  required ActivityProvider provider,
  bool archived = false,
}) {
  return Activity(
    id: id,
    userId: 'u-1',
    provider: provider,
    title: id,
    content: id,
    authorName: 'Alice',
    commentCount: 0,
    createdAt: DateTime.utc(2026, 1, 1, 10),
    archived: archived,
  );
}

void main() {
  test('category groups keep every type, including quiet ones', () {
    final slack = _activity(
      id: 's-1',
      provider: const SlackMessageProvider(channelId: 'C1'),
    );
    final github = _activity(
      id: 'g-1',
      provider: const GitHubCommitProvider(repo: 'org/app', branch: 'main'),
    );
    final slackLater = _activity(
      id: 's-2',
      provider: const SlackMessageProvider(channelId: 'C1'),
    );

    final groups = deriveCategoryFeedGroups([slack, github, slackLater]);

    expect(groups.map((g) => g.category), ActivityCategory.values);
    expect(
      groups
          .firstWhere((g) => g.category == ActivityCategory.commit)
          .activities
          .map((a) => a.id),
      ['g-1'],
    );
    expect(
      groups
          .firstWhere((g) => g.category == ActivityCategory.message)
          .activities
          .map((a) => a.id),
      ['s-1', 's-2'],
    );
    expect(
      groups.where(
        (g) =>
            g.category != ActivityCategory.commit &&
            g.category != ActivityCategory.message,
      ),
      everyElement(predicate<DashboardFeedGroup>((g) => g.isEmpty)),
    );
  });

  test('category groups stay visible with no activities', () {
    final groups = deriveCategoryFeedGroups(const []);
    expect(groups.map((g) => g.category), ActivityCategory.values);
    expect(groups.every((g) => g.isEmpty), isTrue);
  });

  test('provider groups keep quiet activated providers', () {
    final slack = _activity(
      id: 's-1',
      provider: const SlackMessageProvider(channelId: 'C1'),
    );

    final groups = deriveProviderFeedGroups(
      visible: [slack],
      providerHealth: const [
        DashboardProviderHealth(providerName: 'GitHub'),
        DashboardProviderHealth(providerName: 'Slack'),
      ],
    );

    expect(groups.map((g) => g.providerName), ['GitHub', 'Slack']);
    expect(groups.first.isEmpty, isTrue);
    expect(groups.last.activities.map((a) => a.id), ['s-1']);
  });

  test('provider groups match names case-insensitively and add extras', () {
    final github = _activity(
      id: 'g-1',
      provider: const GenericProvider(name: 'github'),
    );
    final discord = _activity(
      id: 'd-1',
      provider: const DiscordMessageProvider(channelId: '1'),
    );

    final groups = deriveProviderFeedGroups(
      visible: [github, discord],
      providerHealth: const [DashboardProviderHealth(providerName: 'GitHub')],
    );

    expect(groups.map((g) => g.providerName), ['Discord', 'GitHub']);
    expect(
      groups.firstWhere((g) => g.providerName == 'GitHub').activities.single.id,
      'g-1',
    );
    expect(
      groups
          .firstWhere((g) => g.providerName == 'Discord')
          .activities
          .single
          .id,
      'd-1',
    );
  });
}
