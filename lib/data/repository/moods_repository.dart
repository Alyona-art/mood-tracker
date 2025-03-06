import 'package:hive/hive.dart';

import '../../constants.dart';
import '../../domain/domain.dart';
import '../data.dart';

class MoodsRepository {
  MoodsRepository(this.box);

  final Box<MoodDTO> box;

  Mood? getMoodById(int id) =>
      box.getAt(id) != null ? Mood.fromEntity(box.getAt(id)!) : null;

  List<Mood> getAllMoods() {
    if (box.isEmpty) {
      Constants.moods.forEach(
        (String key, String value) => box.add(
          Mood.toEntity(
            Mood(id: -1, name: value, color: key),
          ),
        ),
      );
    }
    return box.values.map((MoodDTO e) => Mood.fromEntity(e)).toList();
  }

  Future<void> saveMood(int id, Mood mood) => box.put(
        id,
        Mood.toEntity(mood),
      );
}
