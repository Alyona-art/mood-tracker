import '../models/mood_day.dart';
import 'mood_scale.dart';

enum MoodStatsPeriod { week, month, year, custom }

class MoodDateRange {
  const MoodDateRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}

class MoodSeriesPoint {
  const MoodSeriesPoint({
    required this.date,
    required this.energy,
    required this.pleasantness,
  });

  final DateTime date;
  final double energy;
  final double pleasantness;
}

class MoodStatsService {
  MoodStatsService._();

  static MoodDateRange rangeForPeriod(
    MoodStatsPeriod period, {
    DateTime? anchor,
    MoodDateRange? custom,
  }) {
    final DateTime now = anchor ?? DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    switch (period) {
      case MoodStatsPeriod.week:
        final int weekday = today.weekday; // Mon=1
        final DateTime start = today.subtract(Duration(days: weekday - 1));
        return MoodDateRange(
          start: start,
          end: start.add(const Duration(days: 6)),
        );
      case MoodStatsPeriod.month:
        final DateTime start = DateTime(today.year, today.month);
        final DateTime end = DateTime(today.year, today.month + 1, 0);
        return MoodDateRange(start: start, end: end);
      case MoodStatsPeriod.year:
        return MoodDateRange(
          start: DateTime(today.year),
          end: DateTime(today.year, 12, 31),
        );
      case MoodStatsPeriod.custom:
        return custom ??
            MoodDateRange(
              start: today.subtract(const Duration(days: 30)),
              end: today,
            );
    }
  }

  /// One point per day that has an entry inside [range] (inclusive).
  static List<MoodSeriesPoint> seriesInRange(
    List<MoodDay> allEntries,
    MoodDateRange range,
  ) {
    final DateTime start = DateTime(
      range.start.year,
      range.start.month,
      range.start.day,
    );
    final DateTime end = DateTime(
      range.end.year,
      range.end.month,
      range.end.day,
    );

    final Map<DateTime, MoodDay> byDay = <DateTime, MoodDay>{};
    for (final MoodDay e in allEntries) {
      if (e.energy == null && e.pleasantness == null) {
        continue;
      }
      final DateTime d = DateTime(e.date.year, e.date.month, e.date.day);
      if (d.isBefore(start) || d.isAfter(end)) {
        continue;
      }
      byDay[d] = e;
    }

    final List<DateTime> days = byDay.keys.toList()..sort();
    return days
        .map((DateTime d) {
          final MoodDay e = byDay[d]!;
          return MoodSeriesPoint(
            date: d,
            energy: MoodScale.toPercent(e.energy).toDouble(),
            pleasantness: MoodScale.toPercent(e.pleasantness).toDouble(),
          );
        })
        .toList(growable: false);
  }
}
