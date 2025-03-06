import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/data.dart';

part 'mood.freezed.dart';

@freezed
class Mood with _$Mood {
  const factory Mood({
    required int id,
    required String name,
    required String color,
  }) = _Mood;

  static Mood fromEntity(MoodDTO entity) => Mood(
    id: entity.key as int,
        name: entity.name,
        color: entity.color,
      );

  static MoodDTO toEntity(Mood mood) => MoodDTO(
        name: mood.name,
        color: mood.color,
      );
}
