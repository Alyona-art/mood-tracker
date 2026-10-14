import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/mood_repository.dart';
import '../../domain/models/day.dart';
import '../../domain/models/mood_day.dart';

class DaysCubit extends Cubit<List<Day>> {
  DaysCubit(this._repository) : super(<Day>[]);

  final MoodRepository _repository;

  Future<void> loadDays(int year) async {
    try {
      final List<MoodDay> entries = await _repository.getAllEntries();
      final Map<DateTime, MoodDay> moodsByDate = <DateTime, MoodDay>{
        for (final MoodDay e in entries)
          DateTime(e.date.year, e.date.month, e.date.day): e,
      };

      final List<Day> days = <Day>[];
      final DateTime startDate = DateTime(year);
      final DateTime endDate = DateTime(year, 12, 31);
      final int daysInYear = endDate.difference(startDate).inDays + 1;

      for (int i = 0; i < daysInYear; i++) {
        final DateTime date = startDate.add(Duration(days: i));
        final DateTime dateKey = DateTime(date.year, date.month, date.day);
        final MoodDay? entry = moodsByDate[dateKey];
        days.add(
          Day(
            date: date,
            moodId: entry?.emotionIds.isNotEmpty == true
                ? entry!.emotionIds.first
                : entry?.emotion,
            energy: entry?.energy,
            pleasantness: entry?.pleasantness,
            shapeRounding: entry?.shapeRounding,
            shapeRayDepth: entry?.shapeRayDepth,
            shapeTwist: entry?.shapeTwist,
            shapeVariance: entry?.shapeVariance,
          ),
        );
      }

      emit(days);
    } catch (e) {
      emit(<Day>[]);
    }
  }
}
