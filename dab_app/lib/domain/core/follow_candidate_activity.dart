import '../entities/activity/activity.dart';
import '../entities/user/follow_candidate.dart';
import 'activity_follow_key.dart';

/// [ARCH: DOMAIN]
/// ROLE: Maps a Follow/Reports picker row onto a synthetic [Activity].
/// CONTRACT: Stable id is `providerId|objectKey` so [reportSubjectKey]
/// collapses repeats. Used when adding a catalog task that has no feed event.
Activity activityFromFollowCandidate({
  required FollowCandidate candidate,
  required String userId,
  required DateTime occurredAt,
}) {
  return Activity(
    id: '${candidate.providerId}|${candidate.objectKey}',
    userId: userId,
    provider: activityProviderForFollow(
      providerId: candidate.providerId,
      objectKey: candidate.objectKey,
    ),
    title: candidate.title,
    content: '',
    authorName: '',
    commentCount: 0,
    url: candidate.url,
    createdAt: occurredAt.toUtc(),
  );
}
