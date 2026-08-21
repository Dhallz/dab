import 'package:flutter/material.dart';

import '../../../../../domain/entities/user/user_provider_credential_summary.dart';
import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/styles/app_text_styles.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: OAuth connect/disconnect card for one provider in Settings.
class SettingsOauthProviderCard extends StatefulWidget {
  final String providerId;
  final String title;
  final UserProviderCredentialSummary? summary;
  final bool busy;
  final Future<String?> Function() onConnect;
  final Future<String?> Function() onDisconnect;
  final Widget? jiraPicker;

  const SettingsOauthProviderCard({
    super.key,
    required this.providerId,
    required this.title,
    required this.summary,
    required this.busy,
    required this.onConnect,
    required this.onDisconnect,
    this.jiraPicker,
  });

  @override
  State<SettingsOauthProviderCard> createState() =>
      _SettingsOauthProviderCardState();
}

class _SettingsOauthProviderCardState extends State<SettingsOauthProviderCard> {
  String? _message;
  bool _ok = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final connected = widget.summary?.isConnected == true;
    final identity =
        widget.summary?.externalUsername ?? widget.summary?.externalId;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(widget.title, style: AppTextStyles.titleSmall),
                ),
                if (connected)
                  Text(
                    identity == null
                        ? l10n.settingsCredentialConnected
                        : '@$identity',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _message!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: _ok
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(
                  onPressed: widget.busy
                      ? null
                      : () async {
                          setState(() {
                            _ok = true;
                            _message = l10n.settingsOauthOpened;
                          });
                          final error = await widget.onConnect();
                          if (!mounted) return;
                          setState(() {
                            _ok = error == null;
                            _message = error;
                          });
                        },
                  child: Text(l10n.settingsConnectWithProvider(widget.title)),
                ),
                if (connected)
                  TextButton(
                    onPressed: widget.busy
                        ? null
                        : () async {
                            final error = await widget.onDisconnect();
                            if (!mounted) return;
                            setState(() {
                              _ok = error == null;
                              _message =
                                  error ?? l10n.settingsCredentialDisconnected;
                            });
                          },
                    child: Text(l10n.settingsCredentialDisconnect),
                  ),
                if (widget.busy)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            if (widget.jiraPicker != null) ...[
              const SizedBox(height: 12),
              widget.jiraPicker!,
            ],
          ],
        ),
      ),
    );
  }
}
