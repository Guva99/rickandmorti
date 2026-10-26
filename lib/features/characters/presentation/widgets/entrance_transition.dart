import 'package:clatch_rcikmorti/core/theme/app_motion.dart';
import 'package:flutter/widgets.dart';

class EntranceTransition extends StatefulWidget {
  const EntranceTransition({
    required this.child,
    this.delay = Duration.zero,
    this.enabled = true,
    super.key,
  });

  final Duration delay;
  final bool enabled;
  final Widget child;

  @override
  State<EntranceTransition> createState() => _EntranceTransitionState();
}

class _EntranceTransitionState extends State<EntranceTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    final total = widget.delay + AppMotion.entrance;
    _controller = AnimationController(vsync: this, duration: total);
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        widget.delay.inMicroseconds / total.inMicroseconds,
        1,
        curve: AppMotion.curve,
      ),
    );
    if (widget.enabled) {
      _controller.forward();
    } else {
      _controller.value = 1;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.animationsDisabled) _controller.value = 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: FadeTransition(
      opacity: _progress,
      child: AnimatedBuilder(
        animation: _progress,
        builder: (_, child) => Transform.translate(
          offset: Offset(0, (1 - _progress.value) * AppMotion.entranceOffset),
          child: child,
        ),
        child: widget.child,
      ),
    ),
  );
}
