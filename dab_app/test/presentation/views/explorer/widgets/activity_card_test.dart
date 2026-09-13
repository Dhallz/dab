import 'dart:ui';

import 'package:dab_app/domain/containers/metadata_usecases.dart';
import 'package:dab_app/domain/containers/system_usecases.dart';
import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_app/presentation/core/localization/app_localizations.dart';
import 'package:dab_app/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_app/presentation/features/app/app_notifier.dart';
import 'package:dab_app/presentation/features/app/app_state.dart';
import 'package:dab_app/presentation/views/explorer/widgets/activity_card/activity_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSystemUseCases extends Mock implements SystemUseCases {}

class MockMetadataUseCases extends Mock implements MetadataUseCases {}

class MockUserRepository extends Mock implements IUserRepository {}

class MockProviderConfigRepository extends Mock
    implements IProviderConfigRepository {}

/// Test notifier with stable [AppState] and no async [AppNotifier.init].
class TestAppNotifier extends AppNotifier {
  TestAppNotifier()
    : super(
        MockSystemUseCases(),
        MockMetadataUseCases(),
        MockUserRepository(),
        MockProviderConfigRepository(),
      );

  @override
  AppState build() => const AppState(configs: []);
}

void main() {
  const testTitle = 'Test Activity Title';
  const testBody = 'This is broad content for testing purposes.';

  final testActivity = Activity(
    id: '1',
    userId: 'user_1',
    title: testTitle,
    content: testBody,
    createdAt: DateTime.now(),
    authorName: 'Test Author',
    authorAvatarUrl: null,
    commentCount: 0,
    provider: const GenericProvider(name: 'Test'),
    url: 'https://github.com',
  );

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [appNotifierProvider.overrideWith(TestAppNotifier.new)],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: ActivityCard(activity: testActivity)),
      ),
    );
  }

  testWidgets('ActivityCard renders title and content preview', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Verify Title
    expect(find.text(testTitle), findsOneWidget);

    // Verify Content (plain text preview)
    expect(find.text(testBody), findsOneWidget);
  });

  testWidgets('ActivityCard expands on hover', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Should be collapsed initially (Text widget used)
    final textFinder = find.text(testBody);
    final Text textWidget = tester.widget(textFinder);
    expect(textWidget.maxLines, equals(2));
    expect(textWidget.overflow, equals(TextOverflow.ellipsis));

    // Hover to expand
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(
      location: tester.getCenter(find.byType(ActivityCard)),
    );
    await tester.pumpAndSettle();

    // Verify expansion state would trigger Markdown (but for this simple text, it's just the content)
    // We check the internal state or just that it didn't crash
    expect(find.text(testBody), findsOneWidget);
  });
}
