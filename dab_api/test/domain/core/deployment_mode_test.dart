import 'package:dab_api/src/domain/core/deployment_mode.dart';
import 'package:test/test.dart';

void main() {
  test('canonical values stay managed and individual', () {
    expect(normalizeDeploymentMode('managed'), kDeploymentModeManaged);
    expect(normalizeDeploymentMode('individual'), kDeploymentModeIndividual);
  });

  test('legacy organization and personal map to the new names', () {
    expect(normalizeDeploymentMode('organization'), kDeploymentModeManaged);
    expect(normalizeDeploymentMode('personal'), kDeploymentModeIndividual);
    expect(isIndividualDeploymentMode('personal'), isTrue);
    expect(isIndividualDeploymentMode('organization'), isFalse);
  });

  test('unknown or empty values default to managed', () {
    expect(normalizeDeploymentMode(null), kDeploymentModeManaged);
    expect(normalizeDeploymentMode(''), kDeploymentModeManaged);
    expect(normalizeDeploymentMode('weird'), kDeploymentModeManaged);
  });
}
