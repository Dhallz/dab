import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/activity/activity_category.dart';
import 'package:dab_app/presentation/core/extensions/activity_extensions.dart';
import 'package:dab_app/presentation/core/extensions/string_extensions.dart';
import 'package:dab_app/presentation/core/styles/activity_category_styles.dart';
import 'package:dab_app/presentation/core/styles/app_icons.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Activity activity({
    String? senderUserId,
    String authorName = 'dhallz',
  }) {
    return Activity(
      id: 'a1',
      userId: 'u-recipient',
      senderUserId: senderUserId,
      title: 'Please take a look',
      content: 'Onboarding',
      createdAt: DateTime.utc(2026, 8, 18),
      authorName: authorName,
      commentCount: 1,
      provider: const FigmaFileProvider(
        fileKey: 'Abc123File',
        commentId: 'c-1',
      ),
    );
  }

  test('looksLikeOpaqueUserId detects Figma ids and UUIDs', () {
    expect('948500924847399940'.looksLikeOpaqueUserId, isTrue);
    expect(
      'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'.looksLikeOpaqueUserId,
      isTrue,
    );
    expect('dhallz'.looksLikeOpaqueUserId, isFalse);
    expect('Alice'.looksLikeOpaqueUserId, isFalse);
  });

  test('senderDisplayName prefers linked sender then handle', () {
    expect(
      activity(senderUserId: 'u-alice').senderDisplayName({
        'u-alice': 'Alice',
        'u-recipient': 'Bob',
      }),
      'Alice',
    );
    expect(
      activity(authorName: 'dhallz').senderDisplayName(const {}),
      'dhallz',
    );
    expect(
      activity(authorName: '948500924847399940').senderDisplayName(const {}),
      isEmpty,
    );
  });

  test('message category uses a generic chat icon not Slack', () {
    expect(
      ActivityCategoryStyles.dark().styleOf(ActivityCategory.message).icon,
      AppIcons.message,
    );
    expect(
      ActivityCategoryStyles.dark().styleOf(ActivityCategory.message).icon,
      isNot(AppIcons.slack),
    );
  });
}
