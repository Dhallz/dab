import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/localization/l10n_extension.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_theme.dart';
import '../../core/styles/app_text_styles.dart';
import '../../core/styles/app_icons.dart';
import '../../core/widgets/dab_mesh_background.dart';
import '../../features/auth/auth_notifier.dart';
import '../../features/auth/auth_state.dart';
import 'splash_route_resolution.dart';

/// Minimum time the splash branding stays visible before routing (auth may take longer).
const Duration _kSplashMinimumHold = Duration(seconds: 1);

/// [ARCH: PRESENTATION_VIEW]
/// ROLE: Cold-start screen with fixed DAB branding, build identity, and auth handoff.
/// CONTRACT: Always uses [AppTheme.dab] regardless of user theme preference. Navigation
/// runs only after [_kSplashMinimumHold] and once [AuthState] is ready to route.
class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  bool _minimumHoldComplete = false;
  bool _didNavigate = false;
  Timer? _holdTimer;
  String? _versionLabel;

  @override
  void initState() {
    super.initState();
    _holdTimer = Timer(_kSplashMinimumHold, () {
      if (!mounted) return;
      setState(() => _minimumHoldComplete = true);
      _tryNavigate();
    });
    unawaited(_loadVersion());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _tryNavigate();
    });
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {
        _versionLabel = '${info.version}+${info.buildNumber}';
      });
    } catch (_) {
      // [MissingPluginException] until a full restart/rebuild after adding
      // package_info_plus (hot reload does not register the channel). Omit footer.
    }
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  void _tryNavigate() {
    if (!mounted || _didNavigate || !_minimumHoldComplete) return;
    final next = splashDestinationPath(ref.read(authNotifierProvider));
    if (next == null) return;
    _didNavigate = true;
    context.go(next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      _tryNavigate();
    });

    return Theme(
      data: AppTheme.dab,
      child: Scaffold(
        // Opaque DAB surface — transparent would flash the app Material theme first frame.
        backgroundColor: AppColors.surface,
        body: DabMeshBackground(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      AppIcons.brand,
                      size: 72,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.appBrandShortName,
                      style: AppTextStyles.displaySmall.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: 6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.brandTagline,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              if (_versionLabel != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      child: Text(
                        '${l10n.settingsVersionLabel} $_versionLabel',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
