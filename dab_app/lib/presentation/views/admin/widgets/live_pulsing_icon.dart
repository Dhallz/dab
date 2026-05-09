import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/views/admin/models/provider_connection_status.dart';
import 'package:flutter/material.dart';

class LivePulsingIcon extends StatefulWidget {
  final ProviderConnectionStatus? status;

  const LivePulsingIcon({super.key, this.status});

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

    return Tooltip(
      message:
          widget.status?.message ??
          (widget.status!.status == ViewStatus.success
              ? l10n.adminConnectionConnected
              : l10n.adminConnectionDisconnected),
      child: FadeTransition(
        opacity: _pulseAnimation,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 14),
        ),
      ),
    );
  }
}
