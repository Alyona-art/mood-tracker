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
    /// Comma-separated emotion ids (chips). Primary / first used for legacy UIs.
    @HiveField(3) required String emotion,
    /// Energy 0–100 (legacy entries may still be 1–6 until rewritten).
    @HiveField(4) int? energy,
    /// Pleasantness 0–100 (legacy entries may still be 1–6 until rewritten).
    @HiveField(5) int? pleasantness,
    /// Optional manual shape overrides 0–100; null = derived from mood.
    @HiveField(6) int? shapeRounding,
    @HiveField(7) int? shapeRayDepth,
    @HiveField(8) int? shapeTwist,
    @HiveField(9) int? shapeVariance,
    /// Tip locked at mark time (daytime/evening pack).
    @HiveField(11) String? adviceSuggestion,
  }) = _MoodDay;
  const MoodDay._();

  factory MoodDay.fromJson(Map<String, dynamic> json) =>
      _$MoodDayFromJson(json);

  List<String> get emotionIds {
    if (emotion.isEmpty) {
      return <String>[];
    }
    return emotion
        .split(',')
        .map((String e) => e.trim())
        .where((String e) => e.isNotEmpty)
        .toList();
  }

  static String joinEmotionIds(Iterable<String> ids) =>
      ids.where((String e) => e.isNotEmpty).join(',');
}
