import 'package:flutter/widgets.dart';

abstract final class AppMotion {
  static const fast = Duration(milliseconds: 150);
  static const medium = Duration(milliseconds: 250);
  static const page = Duration(milliseconds: 320);
  static const entrance = Duration(milliseconds: 380);
  static const staggerStep = Duration(milliseconds: 45);
  static const maxStaggerSteps = 8;
  static const pulse = Duration(milliseconds: 1600);
  static const shimmer = Duration(milliseconds: 1400);

  static const Curve curve = Curves.easeOutCubic;
  static const entranceOffset = 14.0;
  static const pageOffset = Offset(0, 0.04);
  static const pressedScale = 0.97;
}

extension MotionPreference on BuildContext {
  bool get animationsDisabled => MediaQuery.disableAnimationsOf(this);

  Duration motion(Duration duration) =>
      animationsDisabled ? Duration.zero : duration;
}
