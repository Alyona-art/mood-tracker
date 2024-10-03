import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../di.dart';
import '../../../domain/domain.dart';

@Singleton()
class MoodsCubit extends Cubit<List<Mood>> {
  MoodsCubit() : super(<Mood>[]) {
    emit(_moodsUseCase.getAllMoods());
  }
  
  final MoodsUseCase _moodsUseCase = DI.getInstance().moodsUseCase;

  Mood? getMood(int id) {
    return _moodsUseCase.getMoodById(id);
  }

  void setMood(Mood newMood) {
    _moodsUseCase.saveMood(newMood.id, newMood);
    emit(state
        .map((Mood mood) => mood.id == newMood.id ? newMood : mood)
        .toList());
  }
}
