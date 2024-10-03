import '../../data/data.dart';
import '../domain.dart';

class MoodsUseCase {
  MoodsUseCase(this._moodsRepository);

  final MoodsRepository _moodsRepository;

  Mood? getMoodById(int id) =>
      id != -1 ? _moodsRepository.getMoodById(id) : null;

  List<Mood> getAllMoods() => _moodsRepository.getAllMoods();

  Future<void> saveMood(int id, Mood mood) =>
      _moodsRepository.saveMood(id, mood);
}
