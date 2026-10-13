import 'package:freezed_annotation/freezed_annotation.dart';

part 'day.freezed.dart';

@freezed
class Day with _$Day {
  const factory Day({
    required DateTime date,
    required String? moodId,
  }) = _Day;
}
