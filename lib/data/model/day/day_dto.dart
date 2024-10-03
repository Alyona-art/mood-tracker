import 'package:hive/hive.dart';
part 'day_dto.g.dart';

@HiveType(typeId: 0)
class DayDTO {
  DayDTO({
    this.date = '',
    this.moodId = -1,
  });

  @HiveField(0)
  String date;
  @HiveField(1)
  int moodId;
}
