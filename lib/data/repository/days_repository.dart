import 'package:hive/hive.dart';

import '../../domain/domain.dart';
import '../data.dart';

class DaysRepository {
  DaysRepository(this.box);

  final Box<DayDTO> box;

  Day? getDay(int id) =>
      box.getAt(id) != null ? Day.fromEntity(box.getAt(id)!) : null;

  Future<void> saveDay(int id, Day day) => box.putAt(id, Day.toEntity(day));
}
