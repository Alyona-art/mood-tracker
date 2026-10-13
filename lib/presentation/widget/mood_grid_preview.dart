import 'package:flutter/material.dart';

import '../../domain/models/emotion.dart';
import '../../domain/services/emotion_mapping.dart';
import '../shared/extensions/emotion_localization_extension.dart';
import 'axis_grid_view.dart';

class MoodGridPreview extends StatelessWidget {
  const MoodGridPreview({
    super.key,
    required this.size,
    required this.gridColors,
  });

  final double size;
  final List<List<Color>> gridColors;

  Color _getContrastColor(Color backgroundColor) {
    final double luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final double squareSize = size - 18;
    return AxisGridView(
      size: squareSize,
      topLeftColor: gridColors[0][0],
      bottomLeftColor: gridColors[5][0],
      bottomRightColor: gridColors[5][5],
      grid: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 6,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        children: List<Widget>.generate(36, (int index) {
          final int row = index ~/ 6;
          final int col = index % 6;
          final Color color = gridColors[row][col];
          final int energy = 6 - row;
          final int pleasantness = col + 1;
          final String? emotionId = EmotionMapping.getEmotionId(
            energy,
            pleasantness,
          );

          if (emotionId == null) {
            return Container(color: color);
          }

          final Emotion emotion = Emotion.withColor(
            id: emotionId,
            color: color,
          );

          return Container(
            color: color,
            child: Center(
              child: Text(
                emotion.getName(context),
                style: TextStyle(
                  color: _getContrastColor(color),
                  fontSize: 7,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }),
      ),
    );
  }
}
