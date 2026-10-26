import 'package:clatch_rcikmorti/core/theme/app_colors.dart';
import 'package:clatch_rcikmorti/core/theme/app_motion.dart';
import 'package:flutter/material.dart';

class Shimmer extends StatefulWidget {
  const Shimmer({required this.child, super.key});

  final Widget child;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.shimmer,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.animationsDisabled) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: AnimatedBuilder(
      animation: _controller,
      builder: (_, child) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          begin: const Alignment(-1, -0.4),
          end: const Alignment(1, 0.4),
          colors: const [
            Colors.transparent,
            AppColors.shimmer,
            Colors.transparent,
          ],
          stops: const [0.35, 0.5, 0.65],
          transform: _SlidingGradient(_controller.value),
        ).createShader(bounds),
        child: child,
      ),
      child: widget.child,
    ),
  );
}

class _SlidingGradient extends GradientTransform {
  const _SlidingGradient(this.progress);

  final double progress;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * (progress * 2 - 1), 0, 0);
}
