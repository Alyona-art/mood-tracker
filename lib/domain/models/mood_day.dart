import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'mood_day.freezed.dart';
part 'mood_day.g.dart';

@freezed
@HiveType(typeId: 0)
class MoodDay with _$MoodDay {
  const factory MoodDay({
    @HiveField(0) required DateTime date,
    @HiveField(1) required String audioPath,
    @HiveField(2) required String text,
    @HiveField(3) required String emotion,
    @HiveField(4) int? energy,
    @HiveField(5) int? pleasantness,
  }) = _MoodDay;

  factory MoodDay.fromJson(Map<String, dynamic> json) =>
      _$MoodDayFromJson(json);
}
