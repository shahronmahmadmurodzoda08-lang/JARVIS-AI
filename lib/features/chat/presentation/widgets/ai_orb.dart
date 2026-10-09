import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// AI Orb: даврони равшании cyan/blue бо анимацияи "нафаскашӣ".
class AiOrb extends StatefulWidget {
  const AiOrb({super.key, this.size = 160});

  final double size;

  @override
  State<AiOrb> createState() => _AiOrbState();
}

class _AiOrbState extends State<AiOrb> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = Curves.easeInOut.transform(_controller.value);
        final glow = 20 + 30 * t;
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [AppColors.cyan, AppColors.blue, AppColors.surface],
              stops: [0.0, 0.55, 1.0],
            ),
            border: Border.all(color: AppColors.metal, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withValues(alpha: 0.35 + 0.25 * t),
                blurRadius: glow,
                spreadRadius: 2 + 6 * t,
              ),
            ],
          ),
        );
      },
    );
  }
}
