import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/l10n_extension.dart';
import '../../core/navigation/app_route.dart';
import '../../core/styles/app_icons.dart';
import '../../core/styles/app_layout.dart';
import '../../core/styles/app_spacing.dart';
import '../../core/styles/app_text_styles.dart';
import '../../core/widgets/dab_mesh_background.dart';
import '../home/widgets/home_logo.dart';
import 'layouts/settings_view_desktop.dart';
import 'layouts/settings_view_mobile.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DabMeshBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.l,
                  vertical: AppSpacing.s,
                ),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: context.l10n.settingsClose,
                      onPressed: () =>
                          context.go(AppRoute.homeDashboard.path),
                      icon: Icon(
                        AppIcons.back,
                        size: AppLayout.iconMedium,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s),
                    const HomeLogo(),
                    const Spacer(),
                    Text(
                      context.l10n.settingsTitle,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 900) {
                    return const SettingsViewDesktop();
                  }
                  return const SettingsViewMobile();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
