import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../domain/models/mood_day.dart';

@singleton
class MoodRepository {
  static const String _boxName = 'mood_days';

  Future<Box<MoodDay>> get _box async => Hive.openBox<MoodDay>(_boxName);

  Future<List<MoodDay>> getAllEntries() async {
    final Box<MoodDay> box = await _box;
    return box.values.toList();
  }

  Future<void> addEntry(MoodDay entry) async {
    final Box<MoodDay> box = await _box;
    await box.add(entry);
  }

  Future<void> updateEntry(int index, MoodDay entry) async {
    final Box<MoodDay> box = await _box;
    await box.putAt(index, entry);
  }

  Future<void> deleteEntry(int index) async {
    final Box<MoodDay> box = await _box;
    await box.deleteAt(index);
  }

  Future<List<MoodDay>> getEntriesByDate(DateTime date) async {
    final Box<MoodDay> box = await _box;
    return box.values
        .where(
          (MoodDay entry) =>
              entry.date.year == date.year &&
              entry.date.month == date.month &&
              entry.date.day == date.day,
        )
        .toList();
  }

  Future<MoodDay?> getEntryByDate(DateTime date) async {
    final List<MoodDay> entries = await getEntriesByDate(date);
    return entries.isNotEmpty ? entries.first : null;
  }

  Future<void> upsertEntryByDate(MoodDay entry) async {
    final Box<MoodDay> box = await _box;
    final List<MoodDay> existingEntries = await getEntriesByDate(entry.date);

    if (existingEntries.isNotEmpty) {
      // Find and update existing entry
      for (int i = 0; i < box.length; i++) {
        final MoodDay? existing = box.getAt(i);
        if (existing != null &&
            existing.date.year == entry.date.year &&
            existing.date.month == entry.date.month &&
            existing.date.day == entry.date.day) {
          await box.putAt(i, entry);
          return;
        }
      }
    } else {
      // Add new entry
      await box.add(entry);
    }
  }

  Future<void> deleteEntryByDate(DateTime date) async {
    final Box<MoodDay> box = await _box;
    for (int i = 0; i < box.length; i++) {
      final MoodDay? existing = box.getAt(i);
      if (existing != null &&
          existing.date.year == date.year &&
          existing.date.month == date.month &&
          existing.date.day == date.day) {
        await box.deleteAt(i);
        return;
      }
    }
  }

  /// Inclusive range by calendar day; one entry per day (last stored wins).
  Future<List<MoodDay>> getEntriesInDateRange(DateTime start, DateTime end) async {
    final Box<MoodDay> box = await _box;
    final DateTime startDay = DateTime(start.year, start.month, start.day);
    final DateTime endDay = DateTime(end.year, end.month, end.day);
    final Map<DateTime, MoodDay> byDay = <DateTime, MoodDay>{};
    for (final MoodDay e in box.values) {
      final DateTime d = DateTime(e.date.year, e.date.month, e.date.day);
      if (d.isBefore(startDay) || d.isAfter(endDay)) {
        continue;
      }
      byDay[d] = e;
    }
    final List<MoodDay> list = byDay.values.toList();
    list.sort(
      (MoodDay a, MoodDay b) => DateTime(
        a.date.year,
        a.date.month,
        a.date.day,
      ).compareTo(DateTime(b.date.year, b.date.month, b.date.day)),
    );
    return list;
  }
}
