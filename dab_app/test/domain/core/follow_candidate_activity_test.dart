import 'package:dab_app/domain/core/follow_candidate_activity.dart';
import 'package:dab_app/domain/core/report_subject_key.dart';
import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/user/follow_candidate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('catalog task keeps a stable report subject key', () {
    const candidate = FollowCandidate(
      providerId: 'phorge',
      objectKey: 'PHID-TASK-12',
      title: '[T12] Fix login',
      url: 'https://phorge.example.com/T12',
    );
    final activity = activityFromFollowCandidate(
      candidate: candidate,
      userId: 'u-1',
      occurredAt: DateTime.utc(2026, 8, 22),
    );
    expect(activity.provider, isA<PhorgeTaskProvider>());
    expect(activity.title, '[T12] Fix login');
    expect(activity.reportSubjectKey, 'phorge|PHID-TASK-12');
  });
}
