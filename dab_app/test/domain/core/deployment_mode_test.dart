import 'package:dab_app/domain/core/deployment_mode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('legacy personal is treated as individual', () {
    expect(('personal').isIndividualDeploymentMode, isTrue);
    expect(('personal').normalizeDeploymentMode(), kDeploymentModeIndividual);
    expect(('organization').normalizeDeploymentMode(), kDeploymentModeManaged);
  });
}
