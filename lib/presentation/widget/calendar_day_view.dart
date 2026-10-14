import 'package:flutter/material.dart';

import '../../domain/models/mood_day.dart';
import '../../domain/services/mood_gradient_color.dart';
import '../../domain/services/mood_scale.dart';
import '../../domain/services/mood_shape.dart';
import 'mood_shape_view.dart';

class CalendarDayView extends StatelessWidget {
  const CalendarDayView({
    super.key,
    required this.day,
    required this.entry,
    required this.isFocused,
    required this.cellSize,
    this.isOutside = false,
    required this.onDateChanged,
    this.gridColors,
  });

  final DateTime day;
  final MoodDay? entry;
  final bool isFocused;
  final bool isOutside;
  final double cellSize;
  final Function(DateTime) onDateChanged;
  final List<List<Color>>? gridColors;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        Theme.of(context).colorScheme.surfaceContainerHighest;
    final bool hasEntry = entry != null;

    Color dayColor = backgroundColor;
    MoodShapeParams? shape;
    if (entry != null) {
      final int energy = MoodScale.toPercent(entry!.energy);
      final int pleasantness = MoodScale.toPercent(entry!.pleasantness);
      dayColor = MoodGradientColor.fromGridOrDefaults(
        energyPercent: energy,
        pleasantnessPercent: pleasantness,
        grid: gridColors,
      );
      shape = MoodShapeParams.fromMood(
        energyPercent: energy,
        pleasantnessPercent: pleasantness,
        cornerRoundingOverride:
            entry!.shapeRounding != null ? entry!.shapeRounding! / 100.0 : null,
        rayDepthOverride:
            entry!.shapeRayDepth != null ? entry!.shapeRayDepth! / 100.0 : null,
        twistOverride:
            entry!.shapeTwist != null ? entry!.shapeTwist! / 100.0 : null,
        varianceOverride:
            entry!.shapeVariance != null ? entry!.shapeVariance! / 100.0 : null,
        seed: day.year * 10000 + day.month * 100 + day.day,
      );
    }

    // Stars read smaller than disks because of rays — bias them larger.
    final double filledSize = cellSize * (isFocused ? 0.96 : 0.9);
    final double emptySize = cellSize * 0.72;

    return GestureDetector(
      onTap: () => onDateChanged(day),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: cellSize,
        height: cellSize,
        child: Center(
          child:
              hasEntry && shape != null
                  ? MoodShapeView(
                    color: dayColor,
                    params: shape,
                    size: filledSize,
                    showShadow: isFocused,
                  )
                  : Container(
                    width: emptySize,
                    height: emptySize,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      shape: BoxShape.circle,
                      border:
                          isFocused
                              ? Border.all(
                                width: 1.5,
                                color: Colors.black.withValues(alpha: 0.14),
                              )
                              : null,
                    ),
                  ),
        ),
      ),
    );
  }
}
