import 'package:flutter/material.dart';

import '../../../../../domain/entities/user/user_provider_credential_summary.dart';
import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/styles/app_text_styles.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Conduit token connect/disconnect card for Phorge in Settings.
class SettingsPhorgeTokenCard extends StatefulWidget {
  final String title;
  final UserProviderCredentialSummary? summary;
  final bool busy;
  final Future<String?> Function(Map<String, dynamic> settings) onConnect;
  final Future<String?> Function() onDisconnect;

  const SettingsPhorgeTokenCard({
    super.key,
    required this.title,
    required this.summary,
    required this.busy,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  State<SettingsPhorgeTokenCard> createState() =>
      _SettingsPhorgeTokenCardState();
}

class _SettingsPhorgeTokenCardState extends State<SettingsPhorgeTokenCard> {
  final _token = TextEditingController();
  String? _message;
  bool _ok = false;

  @override
  void dispose() {
    _token.dispose();
    super.dispose();
  }

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
            const SizedBox(height: 4),
            Text(
              l10n.settingsPhorgeTokenHint,
              style: AppTextStyles.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _token,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Conduit API token',
                isDense: true,
              ),
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
                          final error = await widget.onConnect({
                            'api.token': _token.text.trim(),
                          });
                          if (!mounted) return;
                          setState(() {
                            _ok = error == null;
                            _message =
                                error ?? l10n.settingsCredentialConnected;
                          });
                        },
                  child: Text(l10n.settingsCredentialConnect),
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
                              if (error == null) _token.clear();
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
          ],
        ),
      ),
    );
  }
}
