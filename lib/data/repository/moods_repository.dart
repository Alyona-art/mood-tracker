import 'package:hive/hive.dart';

import '../../domain/domain.dart';
import '../data.dart';

class MoodsRepository {
  MoodsRepository(this.box);
  
  final Box<MoodDTO> box;

  Mood? getMoodById(int id) =>
      box.getAt(id) != null ? Mood.fromEntity(box.getAt(id)!) : null;

  List<Mood> getAllMoods() =>
      box.values.map((MoodDTO e) => Mood.fromEntity(e)).toList();

  Future<void> saveMood(int id, Mood mood) => box.put(
        id,
        Mood.toEntity(mood),
      );
}
