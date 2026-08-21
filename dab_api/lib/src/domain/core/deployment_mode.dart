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

const kAllowedSystemSettingKeys = {
  'allowed_domain_enabled',
  'allowed_domain',
  'public_api_url',
  'system_timezone',
  kDeploymentModeSettingKey,
};

/// [ARCH: DOMAIN]
/// ROLE: Deployment-mode predicates on a stored or inbound string.
extension OnStringNullable on String? {
  /// True when [this] is the individual / small-team profile.
  bool get isIndividualDeploymentMode {
    final value = (this ?? '').trim().toLowerCase();
    return value == kDeploymentModeIndividual ||
        value == kDeploymentModePersonalLegacy;
  }

  /// Normalizes a stored or inbound value to one of the two canonical modes.
  String normalizeDeploymentMode() => isIndividualDeploymentMode
      ? kDeploymentModeIndividual
      : kDeploymentModeManaged;
}
