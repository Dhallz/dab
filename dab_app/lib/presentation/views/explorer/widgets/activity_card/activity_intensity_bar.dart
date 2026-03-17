import 'package:flutter/material.dart';

class ActivityIntensityBar extends StatefulWidget {
  final int activityCount;
  final Color accentColor;

  const ActivityIntensityBar({
    super.key,
    required this.activityCount,
    required this.accentColor,
  });

  @override
  State<ActivityIntensityBar> createState() => _ActivityIntensityBarState();
}

class _ActivityIntensityBarState extends State<ActivityIntensityBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.activityCount >= 8) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(ActivityIntensityBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activityCount >= 8) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      if (_pulseController.isAnimating) {
        _pulseController.stop();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.activityCount;
    
    // Step configuration
    final steps = [
      _StepConfig(threshold: 2, color: const Color(0xFF00E5FF)), // Cyan
      _StepConfig(threshold: 4, color: const Color(0xFFAEEA00)), // Lime
      _StepConfig(threshold: 6, color: const Color(0xFFFF3D00)), // Orange
      _StepConfig(threshold: 8, color: const Color(0xFFFF1744)), // Red
    ];

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: steps.asMap().entries.map((entry) {
            final index = entry.key;
            final config = entry.value;
            final isFilled = count >= config.threshold;
            final isLastStep = index == steps.length - 1;
            final isExtreme = isLastStep && count >= config.threshold;

            return Padding(
              padding: EdgeInsets.only(left: index == 0 ? 0 : 4),
              child: Container(
                width: 12,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: isFilled 
                      ? config.color 
                      : config.color.withValues(alpha: 0.1),
                  boxShadow: isFilled 
                      ? [
                          BoxShadow(
                            color: config.color.withValues(
                              alpha: isExtreme ? (0.6 * _glowAnimation.value) : 0.3,
                            ),
                            blurRadius: isExtreme ? (6 + (4 * _glowAnimation.value)) : 4,
                            spreadRadius: isExtreme ? (1 * _glowAnimation.value) : 0,
                          ),
                        ]
                      : [],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _StepConfig {
  final int threshold;
  final Color color;

  _StepConfig({required this.threshold, required this.color});
}
