import 'package:dab_api/src/application/usecases/user/get_git_watch_list.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_credential_resolver.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockResolver extends Mock implements AbsICredentialResolver {}

class _MockConfigs extends Mock implements AbsIProviderConfigRepository {}

void main() {
  late _MockResolver resolver;
  late _MockConfigs configs;
  late GetGitWatchList useCase;

  final github = ProviderConfig(
    id: 'github',
    name: 'GitHub',
    baseUrl: 'https://github.com',
    isActive: true,
    settings: const {'owner': 'Acme', 'repo': 'app'},
  );

  setUp(() {
    resolver = _MockResolver();
    configs = _MockConfigs();
    useCase = GetGitWatchList(resolver, configs);
    when(() => configs.getConfigs()).thenAnswer((_) async => Right([github]));
  });

  test('inherits instance repos when the user has not saved watches', () async {
    when(
      () => resolver.getUserSettings(userId: 'u-1', providerId: 'github'),
    ).thenAnswer((_) async => <String, dynamic>{});

    final out = await useCase.execute(userId: 'u-1', providerId: 'github');
    final watch = out.getOrElse((_) => throw StateError('left'));
    expect(watch.selected, ['Acme/app']);
    expect(watch.available, ['Acme/app']);
    expect(watch.branches, isEmpty);
  });

  test('empty watchedRepos means no git inbox', () async {
    when(
      () => resolver.getUserSettings(userId: 'u-1', providerId: 'github'),
    ).thenAnswer((_) async => {'watchedRepos': <String>[]});

    final out = await useCase.execute(userId: 'u-1', providerId: 'github');
    final watch = out.getOrElse((_) => throw StateError('left'));
    expect(watch.selected, isEmpty);
    expect(watch.available, ['Acme/app']);
  });

  test('maps unexpected throws to a validation failure', () async {
    when(() => configs.getConfigs()).thenThrow(StateError('boom'));
    when(
      () => resolver.getUserSettings(userId: 'u-1', providerId: 'github'),
    ).thenAnswer((_) async => <String, dynamic>{});

    final out = await useCase.execute(userId: 'u-1', providerId: 'github');
    expect(out.isLeft(), isTrue);
    expect(
      out.getLeft().toNullable()?.message,
      'Could not load git inbox watches',
    );
  });
}
