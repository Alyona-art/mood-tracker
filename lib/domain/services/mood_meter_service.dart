import '../models/emotion.dart';
import 'emotion_mapping.dart';

class MoodMeterService {
  MoodMeterService._();

  static const int minValue = 1;
  static const int maxValue = 5;

  static String getEmotionFromMoodMeter({
    required int energy,
    required int pleasantness,
    required List<Emotion> availableEmotions,
  }) {
    if (availableEmotions.isEmpty) {
      return 'neutral';
    }

    final String? exactEmotionId = EmotionMapping.getEmotionId(
      energy,
      pleasantness,
    );

    if (exactEmotionId != null) {
      final bool emotionExists = availableEmotions.any(
        (Emotion e) => e.id == exactEmotionId,
      );
      if (emotionExists) {
        return exactEmotionId;
      }
    }

    String closestEmotion = 'neutral';
    double minDistance = double.infinity;

    for (final Emotion emotion in availableEmotions) {
      final Map<String, int>? coordinates = EmotionMapping.getCoordinates(
        emotion.id,
      );
      if (coordinates != null) {
        final int emotionEnergy = coordinates['energy']!;
        final int emotionPleasantness = coordinates['pleasantness']!;
        final double distance =
            (energy - emotionEnergy).abs().toDouble() +
            (pleasantness - emotionPleasantness).abs().toDouble();

        if (distance < minDistance) {
          minDistance = distance;
          closestEmotion = emotion.id;
        }
      }
    }

    return closestEmotion;
  }
}
