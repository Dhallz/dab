import 'package:dab_app/domain/entities/user/follow_candidate.dart';
import 'package:dab_app/presentation/core/localization/app_localizations.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/views/dashboard/dashboard_state.dart';
import 'package:dab_app/presentation/views/dashboard/widgets/dashboard_follow_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('choosing a suggestion Follows it before the overlay closes', (
    tester,
  ) async {
    FollowCandidate? picked;
    const candidate = FollowCandidate(
      providerId: 'phorge',
      objectKey: 'PHID-TASK-1',
      title: '[T1] Fix login',
    );
    final state = DashboardState(
      followSearchQuery: 'login',
      followSearchStatus: ViewStatus.success,
      followCandidates: const [candidate],
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 420,
            child: DashboardFollowSearch(
              state: state,
              onQueryChanged: (_) {},
              onFollow: (row) => picked = row,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.pump();

    expect(find.text('[T1] Fix login'), findsOneWidget);
    await tester.tap(find.text('[T1] Fix login'));
    await tester.pump();

    expect(picked, candidate);
  });
}
