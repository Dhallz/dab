/// [ARCH: DOMAIN]
/// ROLE: Deployment profile for managed vs individual credential UX.
library;

/// System setting key stored in `system_settings`.
const kDeploymentModeSettingKey = 'deployment_mode';

/// Admin-owned provider credentials (company / managed install).
const kDeploymentModeManaged = 'managed';

/// Individual or small team: Settings PATs, shared activity bus.
const kDeploymentModeIndividual = 'individual';

/// Legacy stored value accepted on read; [normalizeDeploymentMode] writes
/// [kDeploymentModeManaged].
const kDeploymentModeOrganizationLegacy = 'organization';

/// Legacy stored value accepted on read; [normalizeDeploymentMode] writes
/// [kDeploymentModeIndividual].
const kDeploymentModePersonalLegacy = 'personal';

/// Returns true when [raw] is the individual / small-team profile.
bool isIndividualDeploymentMode(String? raw) {
  final value = (raw ?? '').trim().toLowerCase();
  return value == kDeploymentModeIndividual ||
      value == kDeploymentModePersonalLegacy;
}

/// Normalizes a stored or inbound value to one of the two canonical modes.
String normalizeDeploymentMode(String? raw) => isIndividualDeploymentMode(raw)
    ? kDeploymentModeIndividual
    : kDeploymentModeManaged;
