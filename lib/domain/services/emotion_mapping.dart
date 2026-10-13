import 'package:flutter/material.dart';

class EmotionMapping {
  EmotionMapping._();

  static const Map<String, Map<String, int>> emotionToCoordinates =
      <String, Map<String, int>>{
        // High Energy, High Pleasantness (4-6 x 4-6)
        'ecstatic': <String, int>{'energy': 6, 'pleasantness': 6},
        'festive': <String, int>{'energy': 6, 'pleasantness': 5},
        'surprised': <String, int>{'energy': 6, 'pleasantness': 4},
        'excited': <String, int>{'energy': 5, 'pleasantness': 6},
        'optimistic': <String, int>{'energy': 5, 'pleasantness': 5},
        'energized': <String, int>{'energy': 5, 'pleasantness': 4},
        'blissful': <String, int>{'energy': 4, 'pleasantness': 6},
        'proud': <String, int>{'energy': 4, 'pleasantness': 5},
        'pleasant': <String, int>{'energy': 4, 'pleasantness': 4},

        // Low Energy, High Pleasantness (1-3 x 4-6)
        'fulfilled': <String, int>{'energy': 3, 'pleasantness': 6},
        'content': <String, int>{'energy': 3, 'pleasantness': 5},
        'at ease': <String, int>{'energy': 3, 'pleasantness': 4},
        'balanced': <String, int>{'energy': 2, 'pleasantness': 6},
        'blessed': <String, int>{'energy': 2, 'pleasantness': 5},
        'relaxed': <String, int>{'energy': 2, 'pleasantness': 4},
        'serene': <String, int>{'energy': 1, 'pleasantness': 6},
        'tranquil': <String, int>{'energy': 1, 'pleasantness': 5},
        'sleepy': <String, int>{'energy': 1, 'pleasantness': 4},

        // High Energy, Low Pleasantness (4-6 x 1-3)
        'enraged': <String, int>{'energy': 6, 'pleasantness': 1},
        'stressed': <String, int>{'energy': 6, 'pleasantness': 2},
        'shocked': <String, int>{'energy': 6, 'pleasantness': 3},
        'fuming': <String, int>{'energy': 5, 'pleasantness': 1},
        'angry': <String, int>{'energy': 5, 'pleasantness': 2},
        'restless': <String, int>{'energy': 5, 'pleasantness': 3},
        'repulse': <String, int>{'energy': 4, 'pleasantness': 1},
        'worried': <String, int>{'energy': 4, 'pleasantness': 2},
        'annoyed': <String, int>{'energy': 4, 'pleasantness': 3},

        // Low Energy, Low Pleasantness (1-3 x 1-3)
        'disgusted': <String, int>{'energy': 3, 'pleasantness': 1},
        'down': <String, int>{'energy': 3, 'pleasantness': 2},
        'apathetic': <String, int>{'energy': 3, 'pleasantness': 3},
        'miserable': <String, int>{'energy': 2, 'pleasantness': 1},
        'lonely': <String, int>{'energy': 2, 'pleasantness': 2},
        'tired': <String, int>{'energy': 2, 'pleasantness': 3},
        'despair': <String, int>{'energy': 1, 'pleasantness': 1},
        'desolate': <String, int>{'energy': 1, 'pleasantness': 2},
        'drained': <String, int>{'energy': 1, 'pleasantness': 3},
      };

  static String? getEmotionId(int energy, int pleasantness) {
    for (final MapEntry<String, Map<String, int>> entry
        in emotionToCoordinates.entries) {
      if (entry.value['energy'] == energy &&
          entry.value['pleasantness'] == pleasantness) {
        return entry.key;
      }
    }
    return null;
  }

  static Map<String, int>? getCoordinates(String emotionId) {
    return emotionToCoordinates[emotionId];
  }

  static List<String> getAllEmotionIds() {
    return emotionToCoordinates.keys.toList();
  }

  static Color getColorForEmotion(
    String emotionId,
    Map<String, Color>? customColors,
  ) {
    return customColors?[emotionId] ?? Colors.grey;
  }

  static List<String> getSurroundingEmotions({
    required int energy,
    required int pleasantness,
    required List<String> availableEmotionIds,
  }) {
    final List<String> surroundingEmotions = <String>[];

    final List<Map<String, int>> coordinates = <Map<String, int>>[
      if (energy < 6)
        <String, int>{'energy': energy + 1, 'pleasantness': pleasantness},
      if (energy < 6 && pleasantness < 6)
        <String, int>{'energy': energy + 1, 'pleasantness': pleasantness + 1},
      <String, int>{'energy': energy, 'pleasantness': pleasantness},
      if (pleasantness < 6)
        <String, int>{'energy': energy, 'pleasantness': pleasantness + 1},
    ];

    for (final Map<String, int> coord in coordinates) {
      final String? emotionId = getEmotionId(
        coord['energy']!,
        coord['pleasantness']!,
      );
      if (emotionId != null && availableEmotionIds.contains(emotionId)) {
        surroundingEmotions.add(emotionId);
      }
    }

    return surroundingEmotions;
  }
}
