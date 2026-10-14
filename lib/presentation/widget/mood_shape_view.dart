import 'package:flutter/material.dart';

import '../../domain/services/mood_shape.dart';

class MoodShapeView extends StatelessWidget {
  const MoodShapeView({
    super.key,
    required this.color,
    required this.params,
    this.size = 160,
    this.showShadow = false,
    this.starAmount = 1,
  });

  final Color color;
  final MoodShapeParams params;
  final double size;
  final bool showShadow;
  final double starAmount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MoodShapePainter(
          color: color,
          params: params,
          showShadow: showShadow,
          starAmount: starAmount,
        ),
      ),
    );
  }
}

/// Animates [starAmount] between circle (0) and star (1).
class AnimatedMoodShapeView extends StatelessWidget {
  const AnimatedMoodShapeView({
    super.key,
    required this.color,
    required this.params,
    required this.starAmount,
    this.size = 160,
    this.showShadow = false,
    this.duration = const Duration(milliseconds: 420),
  });

  final Color color;
  final MoodShapeParams params;
  final double starAmount;
  final double size;
  final bool showShadow;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: starAmount.clamp(0.0, 1.0)),
      duration: duration,
      curve: Curves.easeInOutCubic,
      builder: (BuildContext context, double value, Widget? child) {
        return MoodShapeView(
          color: color,
          params: params,
          size: size,
          showShadow: showShadow,
          starAmount: value,
        );
      },
    );
  }
}

class _MoodShapePainter extends CustomPainter {
  _MoodShapePainter({
    required this.color,
    required this.params,
    required this.showShadow,
    required this.starAmount,
  });

  final Color color;
  final MoodShapeParams params;
  final bool showShadow;
  final double starAmount;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = MoodShapeGeometry.buildPath(
      size,
      params,
      starAmount: starAmount,
    );
    if (showShadow) {
      canvas.drawShadow(path, Colors.black.withValues(alpha: 0.35), 3, false);
    }
    final Paint fill =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;
    canvas.drawPath(path, fill);
  }

  @override
  bool shouldRepaint(covariant _MoodShapePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.showShadow != showShadow ||
        oldDelegate.starAmount != starAmount ||
        oldDelegate.params.cornerRounding != params.cornerRounding ||
        oldDelegate.params.rayDepth != params.rayDepth ||
        oldDelegate.params.twist != params.twist ||
        oldDelegate.params.variance != params.variance ||
        oldDelegate.params.seed != params.seed ||
        oldDelegate.params.points != params.points;
  }
}
