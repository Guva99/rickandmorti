import 'package:clatch_rcikmorti/core/theme/app_motion.dart';
import 'package:flutter/material.dart';

class PressableCard extends StatefulWidget {
  const PressableCard({required this.onTap, required this.child, super.key});

  final VoidCallback onTap;
  final Widget child;

  @override
  State<PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<PressableCard> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) => AnimatedScale(
    scale: _pressed ? AppMotion.pressedScale : 1,
    duration: context.motion(AppMotion.fast),
    curve: AppMotion.curve,
    child: Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        onHighlightChanged: (pressed) => setState(() => _pressed = pressed),
        child: widget.child,
      ),
    ),
  );
}
