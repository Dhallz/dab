import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/views/admin/models/provider_connection_status.dart';
import 'package:flutter/material.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Pulsing status icon for provider connectivity (main + section lights).
class LivePulsingIcon extends StatefulWidget {
  final ProviderConnectionStatus? status;
  final bool compact;
  final bool enablePulse;

  const LivePulsingIcon({
    super.key,
    required this.status,
    this.compact = false,
    this.enablePulse = true,
  });

  @override
  State<LivePulsingIcon> createState() => _LivePulsingIconState();
}

class _LivePulsingIconState extends State<LivePulsingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (widget.status == null) return const SizedBox.shrink();

    final Color color;
    final IconData icon;

    switch (widget.status!.status) {
      case ViewStatus.success:
        color = Colors.greenAccent;
        icon = Icons.check_circle_rounded;
        break;
      case ViewStatus.warning:
        color = Colors.orangeAccent;
        icon = Icons.warning_amber_rounded;
        break;
      case ViewStatus.failure:
        color = Colors.redAccent;
        icon = Icons.error_rounded;
        break;
      case ViewStatus.loading:
        color = Colors.orangeAccent;
        icon = Icons.bolt;
        break;
      case ViewStatus.initial:
        return const SizedBox.shrink();
    }

    final iconSize = widget.compact ? 12.0 : 14.0;
    final padding = widget.compact ? 2.0 : 4.0;

    final child = Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        boxShadow: widget.compact
            ? null
            : [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
      ),
      child: Icon(icon, color: color, size: iconSize),
    );

    final animatedChild = widget.enablePulse && !widget.compact
        ? FadeTransition(opacity: _pulseAnimation, child: child)
        : child;

    return Tooltip(
      message:
          widget.status?.message ??
          (widget.status!.status == ViewStatus.success
              ? l10n.adminConnectionConnected
              : l10n.adminConnectionDisconnected),
      child: animatedChild,
    );
  }
}
