import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/emotion_repository.dart';
import '../../domain/models/emotion.dart';

class MoodsCubit extends Cubit<List<Emotion>> {
  MoodsCubit(this._repository) : super(<Emotion>[]);

  final EmotionRepository _repository;

  Future<void> loadMoods() async {
    try {
      final List<Emotion> moods = await _repository.getAllEmotions();
      emit(moods);
    } catch (e) {
      emit(<Emotion>[]);
    }
  }

  Emotion? getMood(String? id) {
    if (id == null) {
      return null;
    }
    try {
      return state.firstWhere((Emotion mood) => mood.id == id);
    } catch (e) {
      return null;
    }
  }
}
