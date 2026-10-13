import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../application/get_it/get_it.dart';
import '../../../../data/services/mood_grid_color_service.dart';
import '../../../../domain/utils/color_utils.dart';
import '../../../../domain/utils/date_utils.dart' as calendar_utils;

class YearCalendarPreview extends StatelessWidget {
  const YearCalendarPreview({super.key});

  List<List<Color>> _generateDefaultGridColors() {
    return List<List<Color>>.generate(6, (int row) {
      final double y = row / 5.0;
      return List<Color>.generate(6, (int col) {
        final double x = col / 5.0;
        return ColorUtils.bilinearColor(
          x: x,
          y: y,
          tl: MoodGridColorService.defaultTopLeftColor,
          tr: MoodGridColorService.defaultTopRightColor,
          bl: MoodGridColorService.defaultBottomLeftColor,
          br: MoodGridColorService.defaultBottomRightColor,
        );
      });
    });
  }

  List<Color> _getAllMoodColors(List<List<Color>> gridColors) {
    final Set<Color> uniqueColors = <Color>{};
    for (final List<Color> row in gridColors) {
      uniqueColors.addAll(row);
    }
    return uniqueColors.toList();
  }

  List<Color> _getPositiveMoodColors(List<Color> allColors) {
    final List<Color> positiveColors = <Color>[];
    for (final Color color in allColors) {
      final double luminance = color.computeLuminance();
      final HSVColor hsv = HSVColor.fromColor(color);
      final double hue = hsv.hue;
      final double saturation = hsv.saturation;
      if (luminance > 0.3 &&
          saturation > 0.3 &&
          (hue < 60 || hue > 300 || (hue > 100 && hue < 200))) {
        positiveColors.add(color);
      }
    }
    return positiveColors.isNotEmpty ? positiveColors : allColors;
  }

  Color _getRandomMoodColor(
    List<Color> allColors,
    List<Color> positiveColors,
    math.Random random,
  ) {
    if (random.nextDouble() > 0.2) {
      return positiveColors[random.nextInt(positiveColors.length)];
    }
    return allColors[random.nextInt(allColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    final int year = DateTime.now().year;
    final math.Random random = math.Random(42);
    final List<int> daysPerMonth = calendar_utils
        .CalendarDateUtils.getDaysPerMonth(year);
    final double size = (MediaQuery.of(context).size.width - 2 * 24 - 44) / 31;

    return FutureBuilder<List<List<Color>>?>(
      future: getIt<MoodGridColorService>().getGridColors(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<List<Color>>?> snapshot,
      ) {
        final List<List<Color>> gridColors =
            snapshot.data ?? _generateDefaultGridColors();
        final List<Color> allMoodColors = _getAllMoodColors(gridColors);
        final List<Color> positiveMoodColors = _getPositiveMoodColors(
          allMoodColors,
        );

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 12,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              separatorBuilder:
                  (BuildContext context, int index) =>
                      const SizedBox(height: 2),
              itemBuilder: (BuildContext context, int monthIndex) {
                final int daysInMonth = daysPerMonth[monthIndex];
                return SizedBox(
                  height: size,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: daysInMonth,
                    separatorBuilder:
                        (BuildContext context, int index) =>
                            const SizedBox(width: 2),
                    itemBuilder: (BuildContext context, int dayIndex) {
                      return Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getRandomMoodColor(
                            allMoodColors,
                            positiveMoodColors,
                            random,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
