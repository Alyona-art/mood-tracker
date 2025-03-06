import 'package:hive/hive.dart';
part 'mood_dto.g.dart';

@HiveType(typeId: 1)
class MoodDTO extends HiveObject {
  MoodDTO({
    this.name = '',
    this.color = '',
  });

  @HiveField(0)
  String name;
  @HiveField(1)
  String color;
}
