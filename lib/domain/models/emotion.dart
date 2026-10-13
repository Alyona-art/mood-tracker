import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'emotion.freezed.dart';
part 'emotion.g.dart';

@freezed
@HiveType(typeId: 1)
class Emotion with _$Emotion {
  const factory Emotion({
    @HiveField(0) required String id,
    @HiveField(1) required int colorValue,
  }) = _Emotion;

  factory Emotion.withColor({required String id, required Color color}) {
    return Emotion(id: id, colorValue: color.toARGB32());
  }
  const Emotion._();

  factory Emotion.fromJson(Map<String, dynamic> json) =>
      _$EmotionFromJson(json);

  Color get color => Color(colorValue);
}
