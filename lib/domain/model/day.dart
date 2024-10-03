import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/data.dart';

part 'day.freezed.dart';

@freezed
class Day with _$Day {
  const factory Day({
    required DateTime date,
    required int moodId,
  }) = _Day;

  static Day fromEntity(DayDTO entity) => Day(
        date: DateTime.parse(entity.date),
        moodId: entity.moodId,
      );

  static DayDTO toEntity(Day day) => DayDTO(
        date: day.date.toIso8601String(),
        moodId: day.moodId,
      );
}
