import 'package:dab_app/presentation/core/localization/app_localizations.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'admin_section.mapper.dart';

@MappableEnum()
enum AdminSection { providers, identities, security }

/// Sections shown in the Admin shell. Individual mode hides Identities.
List<AdminSection> adminSectionsFor({required bool isIndividual}) {
  if (isIndividual) {
    return const [AdminSection.security, AdminSection.providers];
  }
  return AdminSection.values;
}

extension OnAdminSection on AdminSection {
  /// Localized section title for admin shell headers and selectors.
  String localizedTitle(AppLocalizations l10n) => switch (this) {
    AdminSection.providers => l10n.adminSectionProvidersTitle,
    AdminSection.identities => l10n.adminSectionIdentitiesTitle,
    AdminSection.security => l10n.adminSectionSecurityTitle,
  };

  /// Localized subtitle shown under the section title.
  String localizedSubtitle(AppLocalizations l10n) => switch (this) {
    AdminSection.providers => l10n.adminSectionProvidersSubtitle,
    AdminSection.identities => l10n.adminSectionIdentitiesSubtitle,
    AdminSection.security => l10n.adminSectionSecuritySubtitle,
  };
}
