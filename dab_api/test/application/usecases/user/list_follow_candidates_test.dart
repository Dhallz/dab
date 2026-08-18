import 'package:dab_api/src/application/usecases/user/get_git_branch_list.dart';
import 'package:dab_api/src/application/usecases/user/get_git_watch_list.dart';
import 'package:dab_api/src/application/usecases/user/list_follow_candidates.dart';
import 'package:dab_api/src/domain/entities/user/follow_candidate.dart';
import 'package:dab_api/src/domain/entities/user/git_branch_list.dart';
import 'package:dab_api/src/domain/entities/user/git_watch_list.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_follow_candidate_catalog.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockCatalog extends Mock implements AbsIFollowCandidateCatalog {}

class _MockGitWatches extends Mock implements GetGitWatchList {}

class _MockGitBranches extends Mock implements GetGitBranchList {}

void main() {
  late _MockCatalog catalog;
  late _MockGitWatches gitWatches;
  late _MockGitBranches gitBranches;
  late ListFollowCandidates useCase;

  setUp(() {
    catalog = _MockCatalog();
    gitWatches = _MockGitWatches();
    gitBranches = _MockGitBranches();
    useCase = ListFollowCandidates([catalog], gitWatches, gitBranches);
  });

  test('empty query returns involved issues and skips git', () async {
    when(
      () => catalog.list(
        userId: any(named: 'userId'),
        query: any(named: 'query'),
      ),
    ).thenAnswer(
      (_) async => const Right([
        FollowCandidate(
          providerId: 'jira',
          objectKey: 'DAB-7',
          title: '[DAB-7] Inbox',
        ),
      ]),
    );

    final result = await useCase.execute(userId: 'u-1');
    final rows = result.getOrElse((_) => throw StateError('left'));
    expect(rows, hasLength(1));
    expect(rows.single.objectKey, 'DAB-7');
    verifyNever(
      () => gitWatches.execute(
        userId: any(named: 'userId'),
        providerId: any(named: 'providerId'),
      ),
    );
  });

  test('typed query includes matching git branches', () async {
    when(
      () => catalog.list(
        userId: any(named: 'userId'),
        query: any(named: 'query'),
      ),
    ).thenAnswer((_) async => const Right([]));
    when(
      () => gitWatches.execute(
        userId: any(named: 'userId'),
        providerId: any(named: 'providerId'),
      ),
    ).thenAnswer((invocation) async {
      final providerId = invocation.namedArguments[#providerId] as String;
      if (providerId != 'github') {
        return const Right(GitWatchList(available: [], selected: []));
      }
      return const Right(
        GitWatchList(available: ['acme/app'], selected: ['acme/app']),
      );
    });
    when(
      () => gitBranches.execute(
        userId: any(named: 'userId'),
        providerId: any(named: 'providerId'),
        repos: any(named: 'repos'),
      ),
    ).thenAnswer(
      (_) async =>
          const Right(GitBranchList(available: ['main', 'feature/foo'])),
    );

    final result = await useCase.execute(userId: 'u-1', query: 'foo');
    final rows = result.getOrElse((_) => throw StateError('left'));
    expect(rows, hasLength(1));
    expect(rows.single.kind, 'gitBranch');
    expect(rows.single.providerId, 'github');
    expect(rows.single.objectKey, 'acme/app|feature/foo');
    expect(rows.single.title, 'acme/app · feature/foo');
  });

  test('round-robins catalogs so one provider cannot fill the cap', () async {
    final jira = _MockCatalog();
    final linear = _MockCatalog();
    when(
      () => jira.list(
        userId: any(named: 'userId'),
        query: any(named: 'query'),
      ),
    ).thenAnswer(
      (_) async => Right([
        for (var i = 0; i < 40; i++)
          FollowCandidate(providerId: 'jira', objectKey: 'J-$i', title: 'J-$i'),
      ]),
    );
    when(
      () => linear.list(
        userId: any(named: 'userId'),
        query: any(named: 'query'),
      ),
    ).thenAnswer(
      (_) async => const Right([
        FollowCandidate(
          providerId: 'linear',
          objectKey: 'ENG-1',
          title: '[ENG-1] Inbox',
        ),
      ]),
    );
    useCase = ListFollowCandidates([jira, linear], gitWatches, gitBranches);

    final result = await useCase.execute(userId: 'u-1');
    final rows = result.getOrElse((_) => throw StateError('left'));
    expect(rows, hasLength(40));
    expect(rows.any((row) => row.providerId == 'linear'), isTrue);
    expect(rows.any((row) => row.providerId == 'jira'), isTrue);
  });
}
