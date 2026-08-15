/// [ARCH: DOMAIN]
/// ROLE: Deployment profile for org-admin vs personal/small-team credential UX.
library;

/// System setting key stored in `system_settings`.
const kDeploymentModeSettingKey = 'deployment_mode';

/// Company / Admin-owned provider credentials.
const kDeploymentModeOrganization = 'organization';

/// Solo or small team: personal PATs in Settings, shared activity bus.
const kDeploymentModePersonal = 'personal';

const kAllowedSystemSettingKeys = {
  'allowed_domain_enabled',
  'allowed_domain',
  'public_api_url',
  'system_timezone',
  kDeploymentModeSettingKey,
};

/// Returns true when [raw] is the personal/small-team profile.
bool isPersonalDeploymentMode(String? raw) =>
    (raw ?? '').trim().toLowerCase() == kDeploymentModePersonal;

/// Normalizes a stored value to one of the two canonical modes.
String normalizeDeploymentMode(String? raw) =>
    isPersonalDeploymentMode(raw)
    ? kDeploymentModePersonal
    : kDeploymentModeOrganization;
