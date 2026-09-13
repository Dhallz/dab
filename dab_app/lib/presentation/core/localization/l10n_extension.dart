import 'package:flutter/widgets.dart';
import 'app_localizations.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Extension to provide easy access to localizations from [BuildContext].
/// USAGE: `context.l10n.translateKey`
extension L10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
