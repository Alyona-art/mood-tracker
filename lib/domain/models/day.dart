import 'package:freezed_annotation/freezed_annotation.dart';

part 'day.freezed.dart';

@freezed
class Day with _$Day {
  const factory Day({
    required DateTime date,
    required String? moodId,
    int? energy,
    int? pleasantness,
    int? shapeRounding,
    int? shapeRayDepth,
    int? shapeTwist,
    int? shapeVariance,
  }) = _Day;
}
