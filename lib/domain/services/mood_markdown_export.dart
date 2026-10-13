import 'package:intl/intl.dart';

import '../models/mood_day.dart';
import 'emotion_mapping.dart';

int _energyForExport(MoodDay e) {
  if (e.energy != null) {
    return e.energy!;
  }
  final Map<String, int>? coords = EmotionMapping.getCoordinates(e.emotion);
  return coords?['energy'] ?? 4;
}

int _feelingForExport(MoodDay e) {
  if (e.pleasantness != null) {
    return e.pleasantness!;
  }
  final Map<String, int>? coords = EmotionMapping.getCoordinates(e.emotion);
  return coords?['pleasantness'] ?? 4;
}

String buildMoodMarkdown(
  List<MoodDay> entries, {
  required String energyLabel,
  required String feelingLabel,
  required String moodLabel,
}) {
  final DateFormat dateFmt = DateFormat('yyyy-MM-dd');
  final StringBuffer buf = StringBuffer();
  for (final MoodDay e in entries) {
    final DateTime d = DateTime(e.date.year, e.date.month, e.date.day);
    final int energy = _energyForExport(e);
    final int feeling = _feelingForExport(e);
    buf.writeln('## ${dateFmt.format(d)}');
    buf.writeln('**$energyLabel:** $energy/6');
    buf.writeln('**$feelingLabel:** $feeling/6');
    buf.writeln('**$moodLabel:** ${e.emotion}');
    buf.writeln();
  }
  return buf.toString().trimRight();
}
