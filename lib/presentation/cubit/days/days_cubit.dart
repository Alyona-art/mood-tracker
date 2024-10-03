import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../di.dart';
import '../../../domain/domain.dart';

@Singleton()
class DaysCubit extends Cubit<List<Day>> {
  DaysCubit() : super(<Day>[]) {
    final List<Day> initialDays = <Day>[];
    final int year = DateTime.now().year % 4 == 0 ? 366 : 365;
    for (int i = 0; i < year; i++) {
      initialDays.add(_daysUseCase.getDayById(i) ??
          Day(
            date: DateTime(DateTime.now().year).add(Duration(days: i)),
            moodId: -1,
          ));
    }
    emit(initialDays);
  }

  final DaysUseCase _daysUseCase = DI.getInstance().daysUseCase;

  Day? getDay(int id) {
    return _daysUseCase.getDayById(id);
  }

  void setDay(int id, DateTime date, int moodId) {
    _daysUseCase.saveDay(id, date, moodId);

    emit(state.map((Day day) {
      return day.date.year == date.year &&
              day.date.month == date.month &&
              day.date.day == date.day
          ? Day(
              date: day.date,
              moodId: moodId,
            )
          : day;
    }).toList());
  }
}
