import 'package:intl/intl.dart';

import '../models/mood_day.dart';
import 'mood_scale.dart';

String buildMoodMarkdown(
  List<MoodDay> entries, {
  required String energyLabel,
  required String feelingLabel,
  required String moodLabel,
  String noteLabel = 'Note',
}) {
  final DateFormat dateFmt = DateFormat('yyyy-MM-dd');
  final StringBuffer buf = StringBuffer();
  for (final MoodDay e in entries) {
    final DateTime d = DateTime(e.date.year, e.date.month, e.date.day);
    final int energy = MoodScale.toPercent(e.energy);
    final int feeling = MoodScale.toPercent(e.pleasantness);
    buf.writeln('## ${dateFmt.format(d)}');
    buf.writeln('**$energyLabel:** $energy/100');
    buf.writeln('**$feelingLabel:** $feeling/100');
    final List<String> moods = e.emotionIds;
    if (moods.isNotEmpty) {
      buf.writeln('**$moodLabel:** ${moods.join(', ')}');
    }
    final String note = e.text.trim();
    if (note.isNotEmpty) {
      buf.writeln('**$noteLabel:** $note');
    }
    buf.writeln();
  }
  return buf.toString().trimRight();
}
