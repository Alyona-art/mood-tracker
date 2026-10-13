import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../domain/models/emotion.dart';
import '../../domain/services/emotion_mapping.dart';
import '../services/mood_grid_color_service.dart';

@singleton
class EmotionRepository {
  EmotionRepository(this._colorService);

  final MoodGridColorService _colorService;
  static const String _boxName = 'emotions';

  Future<Box<Emotion>> get _box async => Hive.openBox<Emotion>(_boxName);

  Color _getColorForEmotion(
    String emotionId,
    Map<String, Color>? customColors,
  ) {
    return EmotionMapping.getColorForEmotion(emotionId, customColors);
  }

  Future<List<Emotion>> getAllEmotions() async {
    final Box<Emotion> box = await _box;
    final Map<String, Color> customColors =
        await _colorService.getEmotionColorMap();

    // Get the valid emotion IDs from the mapping (should be 36)
    final List<String> validEmotionIds = EmotionMapping.getAllEmotionIds();
    final Set<String> validEmotionIdSet = validEmotionIds.toSet();

    // Create a map of existing emotions from the box
    final Map<String, Emotion> existingEmotions = <String, Emotion>{};
    for (final Emotion emotion in box.values) {
      if (validEmotionIdSet.contains(emotion.id)) {
        existingEmotions[emotion.id] = emotion;
      }
    }

    // Build the final list: use existing emotions if available, otherwise create new ones
    final List<Emotion> emotions = <Emotion>[];
    for (final String id in validEmotionIds) {
      final Emotion existingEmotion =
          existingEmotions[id] ??
          Emotion.withColor(
            id: id,
            color: _getColorForEmotion(id, customColors),
          );

      // Update color if it changed
      final Color newColor = _getColorForEmotion(id, customColors);
      if (existingEmotion.color != newColor) {
        emotions.add(Emotion.withColor(id: id, color: newColor));
      } else {
        emotions.add(existingEmotion);
      }
    }

    // Update the box with only valid emotions
    await box.clear();
    for (final Emotion emotion in emotions) {
      await box.add(emotion);
    }

    return emotions;
  }

  Future<void> updateAllEmotionColors() async {
    final Box<Emotion> box = await _box;
    final Map<String, Color> customColors =
        await _colorService.getEmotionColorMap();

    final List<Emotion> updatedEmotions = <Emotion>[];
    for (final Emotion emotion in box.values) {
      final Color newColor = _getColorForEmotion(emotion.id, customColors);
      updatedEmotions.add(Emotion.withColor(id: emotion.id, color: newColor));
    }

    await box.clear();
    for (final Emotion emotion in updatedEmotions) {
      await box.add(emotion);
    }
  }

  Future<Emotion?> getEmotionById(String id) async {
    final Box<Emotion> box = await _box;
    try {
      return box.values.firstWhere((Emotion e) => e.id == id);
    } catch (e) {
      return null;
    }
  }
}
