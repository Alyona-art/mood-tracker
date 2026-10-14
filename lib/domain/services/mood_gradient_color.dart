import 'package:flutter/material.dart';

import '../../data/services/mood_grid_color_service.dart';
import '../utils/color_utils.dart';
import 'mood_scale.dart';

/// Continuous color from the mood gradient square.
/// X = pleasantness (0 left → 1 right), Y = energy inverted (1 top → 0 bottom).
class MoodGradientColor {
  MoodGradientColor._();

  static Color fromPercents({
    required int energyPercent,
    required int pleasantnessPercent,
    Color tl = MoodGridColorService.defaultTopLeftColor,
    Color tr = MoodGridColorService.defaultTopRightColor,
    Color bl = MoodGridColorService.defaultBottomLeftColor,
    Color br = MoodGridColorService.defaultBottomRightColor,
  }) {
    final double x = MoodScale.toUnit(pleasantnessPercent);
    final double y = 1.0 - MoodScale.toUnit(energyPercent);
    return ColorUtils.bilinearColor(x: x, y: y, tl: tl, tr: tr, bl: bl, br: br);
  }

  /// Sample corner colors from a saved 6×6 (or any) grid if present.
  static Color fromGridOrDefaults({
    required int energyPercent,
    required int pleasantnessPercent,
    List<List<Color>>? grid,
  }) {
    if (grid == null || grid.isEmpty || grid.first.isEmpty) {
      return fromPercents(
        energyPercent: energyPercent,
        pleasantnessPercent: pleasantnessPercent,
      );
    }
    final Color tl = grid.first.first;
    final Color tr = grid.first.last;
    final Color bl = grid.last.first;
    final Color br = grid.last.last;
    return fromPercents(
      energyPercent: energyPercent,
      pleasantnessPercent: pleasantnessPercent,
      tl: tl,
      tr: tr,
      bl: bl,
      br: br,
    );
  }
}
