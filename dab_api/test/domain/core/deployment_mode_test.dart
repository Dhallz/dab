import 'package:dab_api/src/domain/core/deployment_mode.dart';
import 'package:test/test.dart';

void main() {
  test('canonical values stay managed and individual', () {
    expect(('managed').normalizeDeploymentMode(), kDeploymentModeManaged);
    expect(('individual').normalizeDeploymentMode(), kDeploymentModeIndividual);
  });

  test('legacy organization and personal map to the new names', () {
    expect(('organization').normalizeDeploymentMode(), kDeploymentModeManaged);
    expect(('personal').normalizeDeploymentMode(), kDeploymentModeIndividual);
    expect(('personal').isIndividualDeploymentMode, isTrue);
    expect(('organization').isIndividualDeploymentMode, isFalse);
  });

  test('unknown or empty values default to managed', () {
    expect(null.normalizeDeploymentMode(), kDeploymentModeManaged);
    expect(('').normalizeDeploymentMode(), kDeploymentModeManaged);
    expect(('weird').normalizeDeploymentMode(), kDeploymentModeManaged);
  });
}
