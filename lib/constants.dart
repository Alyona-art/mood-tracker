import 'i18n/i18n.dart';

sealed class Constants {
  static const int year = 2025;
  static const String dayBox = 'day_box';
  static const String moodBox = 'mood_box';
  static Map<String, String> moods = <String, String>{
    'FFFFEB3B': t.joy,
    'FFFF626C': t.love,
    'FF840000': t.anger,
    'FF004A86': t.sad,
    'FF8BB0B3': t.tired,
    'FFCAED76': t.calm,
    'FFFF8400': t.energetic,
    'FFF836B6': t.passion,
    'FF8A40A5': t.stressed,
    'FFA998DC': t.lonely,
  };
}
