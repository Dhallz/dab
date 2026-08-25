import 'package:dab_api/src/application/usecases/metadata/save_system_settings.dart';
import 'package:dab_api/src/domain/core/daily_report_lock_policy.dart';
import 'package:dab_api/src/domain/core/deployment_mode.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_system_settings_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockSettings extends Mock implements AbsISystemSettingsRepository {}

void main() {
  late _MockSettings repo;
  late SaveSystemSettings useCase;

  setUp(() {
    repo = _MockSettings();
    useCase = SaveSystemSettings(repo);
    when(
      () => repo.setSetting(any(), any()),
    ).thenAnswer((_) async => const Right(null));
  });

  test('writes allowlisted keys including deployment_mode', () async {
    final result = await useCase.execute({
      kDeploymentModeSettingKey: kDeploymentModeIndividual,
      'public_api_url': 'https://dab.example',
    });
    expect(result.isRight(), isTrue);
    verify(
      () =>
          repo.setSetting(kDeploymentModeSettingKey, kDeploymentModeIndividual),
    ).called(1);
    verify(
      () => repo.setSetting('public_api_url', 'https://dab.example'),
    ).called(1);
  });

  test('normalizes daily-report deadline keys', () async {
    final result = await useCase.execute({
      kDailyReportLockOffsetDaysKey: '1',
      kDailyReportLockTimeKey: '9:05',
    });
    expect(result.isRight(), isTrue);
    verify(() => repo.setSetting(kDailyReportLockOffsetDaysKey, '1')).called(1);
    verify(() => repo.setSetting(kDailyReportLockTimeKey, '09:05')).called(1);
  });

  test('ignores unknown keys', () async {
    final result = await useCase.execute({'not_a_real_key': 'nope'});
    expect(result.isRight(), isTrue);
    verifyNever(() => repo.setSetting(any(), any()));
  });

  test('normalizes unknown deployment_mode values to managed', () async {
    await useCase.execute({kDeploymentModeSettingKey: 'weird'});
    verify(
      () => repo.setSetting(kDeploymentModeSettingKey, kDeploymentModeManaged),
    ).called(1);
  });

  test('rewrites legacy personal to individual on save', () async {
    await useCase.execute({
      kDeploymentModeSettingKey: kDeploymentModePersonalLegacy,
    });
    verify(
      () =>
          repo.setSetting(kDeploymentModeSettingKey, kDeploymentModeIndividual),
    ).called(1);
  });
}
