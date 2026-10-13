import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../domain/services/mood_meter_service.dart';

class DotTickShape extends SfTickShape {
  DotTickShape({this.radius = 2});

  final double radius;

  @override
  void paint(
    PaintingContext context,
    Offset offset,
    Offset? thumbCenter,
    Offset? startThumbCenter,
    Offset? endThumbCenter, {
    dynamic currentValue,
    SfRangeValues? currentValues,
    required Animation<double> enableAnimation,
    required RenderBox parentBox,
    required TextDirection textDirection,
    required SfSliderThemeData themeData,
  }) {
    final Canvas canvas = context.canvas;
    final Paint tickPaint =
        Paint()
          ..color = themeData.activeTickColor ?? Colors.grey
          ..style = PaintingStyle.fill;

    canvas.drawCircle(offset, radius, tickPaint);
  }
}

class ExtendedTrackShape extends SfTrackShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset,
    Offset? thumbCenter,
    Offset? startThumbCenter,
    Offset? endThumbCenter, {
    required RenderBox parentBox,
    required SfSliderThemeData themeData,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Paint? activePaint,
    required Paint? inactivePaint,
    dynamic currentValue,
    SfRangeValues? currentValues,
  }) {
    final double thumbRadius = themeData.thumbRadius;
    final double trackHeight = themeData.activeTrackHeight;
    final double inactiveTrackHeight = themeData.inactiveTrackHeight;
    final double trackPadding = thumbRadius / 2 + 2;

    final double trackWidth = parentBox.size.width;
    final double trackLeft = offset.dx + trackPadding;
    final double trackRight = offset.dx + trackWidth - trackPadding;
    final double trackCenterY = offset.dy;

    // Draw inactive track (extended)
    final Paint inactiveTrackPaint =
        inactivePaint ?? Paint()
          ..color = themeData.inactiveTrackColor ?? Colors.grey
          ..style = PaintingStyle.fill;

    final Rect inactiveRect = Rect.fromLTWH(
      trackLeft,
      trackCenterY,
      trackRight - trackLeft,
      inactiveTrackHeight,
    );
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(
        inactiveRect,
        Radius.circular(inactiveTrackHeight / 2),
      ),
      inactiveTrackPaint,
    );

    // Draw active track (extended)
    if (thumbCenter != null) {
      final double activeTrackRight = thumbCenter.dx;
      final Paint activeTrackPaint =
          activePaint ?? Paint()
            ..color = themeData.activeTrackColor ?? Colors.blue
            ..style = PaintingStyle.fill;

      final Rect activeRect = Rect.fromLTWH(
        trackLeft,
        trackCenterY,
        activeTrackRight - trackLeft,
        trackHeight,
      );
      context.canvas.drawRRect(
        RRect.fromRectAndRadius(activeRect, Radius.circular(trackHeight / 2)),
        activeTrackPaint,
      );
    }
  }
}

class CustomSlider extends StatelessWidget {
  const CustomSlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.color,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SfSliderTheme(
      data: SfSliderThemeData(
        activeTrackHeight: 22,
        activeTrackColor: color,
        inactiveTrackColor:
            Theme.of(context).colorScheme.surfaceContainerHighest,
        inactiveTrackHeight: 22,
        thumbRadius: 15,
        tickOffset: const Offset(0, -11),
        activeTickColor: Colors.black12,
        inactiveTickColor: Colors.black38,
      ),
      child: SfSlider(
        value: value.toDouble(),
        min: MoodMeterService.minValue.toDouble(),
        max: MoodMeterService.maxValue.toDouble(),
        stepSize: 1,
        interval: 1,
        showTicks: true,
        activeColor: color,
        onChanged: (dynamic newValue) {
          onChanged((newValue as double).toInt());
        },
        tickShape: DotTickShape(),
        trackShape: ExtendedTrackShape(),
      ),
    );
  }
}
