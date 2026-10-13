import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../domain/services/emotion_mapping.dart';
import '../../domain/utils/color_utils.dart';

@singleton
class MoodGridColorService {
  static const String _boxName = 'mood_grid_colors';
  static const String _key = 'grid_colors';

  // Default corner colors for the mood grid
  static const Color defaultTopLeftColor = Color(0xFFFE3131);
  static const Color defaultTopRightColor = Color(0xFFFEDD47);
  static const Color defaultBottomLeftColor = Color(0xFF2289FE);
  static const Color defaultBottomRightColor = Color(0xFF79E859);

  Future<Box<dynamic>> get _box async => Hive.openBox<dynamic>(_boxName);

  Future<void> saveGridColors(List<List<Color>> gridColors) async {
    final Box<dynamic> box = await _box;
    final List<List<int>> serialized =
        gridColors
            .map(
              (List<Color> row) => row.map((Color c) => c.toARGB32()).toList(),
            )
            .toList();
    await box.put(_key, serialized);
  }

  Future<List<List<Color>>?> getGridColors() async {
    final Box<dynamic> box = await _box;
    final dynamic data = box.get(_key);
    if (data == null) {
      return null;
    }
    final List<dynamic> serialized = data as List<dynamic>;
    return serialized
        .map(
          (dynamic row) =>
              (row as List<dynamic>)
                  .map((dynamic value) => Color(value as int))
                  .toList(),
        )
        .toList();
  }

  List<List<Color>> _generateDefaultGridColors() {
    return List<List<Color>>.generate(6, (int row) {
      final double y = row / 5.0;
      return List<Color>.generate(6, (int col) {
        final double x = col / 5.0;
        return ColorUtils.bilinearColor(
          x: x,
          y: y,
          tl: defaultTopLeftColor,
          tr: defaultTopRightColor,
          bl: defaultBottomLeftColor,
          br: defaultBottomRightColor,
        );
      });
    });
  }

  Future<Map<String, Color>> getEmotionColorMap() async {
    List<List<Color>>? gridColors = await getGridColors();
    gridColors ??= _generateDefaultGridColors();

    final Map<String, Color> colorMap = <String, Color>{};
    for (int row = 0; row < 6; row++) {
      for (int col = 0; col < 6; col++) {
        final int energy = 6 - row;
        final int pleasantness = col + 1;
        final String? emotionId = EmotionMapping.getEmotionId(
          energy,
          pleasantness,
        );
        if (emotionId != null) {
          colorMap[emotionId] = gridColors[row][col];
        }
      }
    }
    return colorMap;
  }
}
