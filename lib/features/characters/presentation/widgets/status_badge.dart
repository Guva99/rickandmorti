import 'package:clatch_rcikmorti/core/theme/app_colors.dart';
import 'package:clatch_rcikmorti/core/theme/app_dimens.dart';
import 'package:clatch_rcikmorti/core/theme/app_motion.dart';
import 'package:clatch_rcikmorti/features/characters/domain/entities/character.dart';
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, super.key});

  final CharacterStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      CharacterStatus.alive => AppColors.alive,
      CharacterStatus.dead => AppColors.dead,
      CharacterStatus.unknown => AppColors.unknown,
    };
    final label = switch (status) {
      CharacterStatus.alive => 'Alive',
      CharacterStatus.dead => 'Dead',
      CharacterStatus.unknown => 'Unknown',
    };

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.14),
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 3,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (status == CharacterStatus.alive)
              _PulsingDot(color: color)
            else
              _Dot(color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: 8,
    child: DecoratedBox(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    ),
  );
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot({required this.color});

  final Color color;

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.pulse,
  );
  late final Animation<double> _wave = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );
  late final Animation<double> _haloScale = Tween<double>(
    begin: 1,
    end: 2.6,
  ).animate(_wave);
  late final Animation<double> _haloOpacity = Tween<double>(
    begin: 0.6,
    end: 0,
  ).animate(_wave);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.animationsDisabled) {
      _controller.reset();
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
    child: Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        ScaleTransition(
          scale: _haloScale,
          child: FadeTransition(
            opacity: _haloOpacity,
            child: _Dot(color: widget.color),
          ),
        ),
        _Dot(color: widget.color),
      ],
    ),
  );
}
