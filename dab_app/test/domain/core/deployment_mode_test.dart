import 'package:dab_app/domain/core/deployment_mode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('legacy personal is treated as individual', () {
    expect(isIndividualDeploymentMode('personal'), isTrue);
    expect(normalizeDeploymentMode('personal'), kDeploymentModeIndividual);
    expect(normalizeDeploymentMode('organization'), kDeploymentModeManaged);
  });
}
