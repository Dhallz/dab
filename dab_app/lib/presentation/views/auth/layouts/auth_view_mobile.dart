import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/widgets/dab_mesh_background.dart';
import '../../../core/widgets/dab_glass_surface.dart';
import '../widgets/auth_form_panel.dart';

/// Mobile auth screen — static chrome is a [StatelessWidget]; only the form
/// subtree watches [authFormNotifierProvider].
class AuthViewMobile extends StatelessWidget {
  const AuthViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DabMeshBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.appBrandShortName,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.brandTagline,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 48),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: const DabGlassSurface(
                    padding: EdgeInsets.all(32),
                    child: AuthFormPanel(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
