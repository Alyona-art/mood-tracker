import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../application/get_it/get_it.dart';
import '../../domain/models/mood_day.dart';
import '../../domain/usecases/get_entry_by_day.dart';
import 'calendar_day_view.dart';

class MonthCalendarView extends StatelessWidget {
  const MonthCalendarView({
    super.key,
    required this.selectedDate,
    required this.focusedDate,
    required this.onDateChanged,
    required this.onFocusedDateChanged,
    this.horizontalPadding = 16,
    this.gridColors,
  });

  final DateTime selectedDate;
  final DateTime focusedDate;
  final Function(DateTime) onDateChanged;
  final Function(DateTime) onFocusedDateChanged;
  final double horizontalPadding;
  final List<List<Color>>? gridColors;

  /// Header + weekday row + up to 6 week rows.
  static double heightForWidth(double width, {double horizontalPadding = 16}) {
    final double cell = cellSizeForWidth(width, horizontalPadding: horizontalPadding);
    const double header = 40;
    const double daysOfWeek = 18;
    return header + daysOfWeek + cell * 6;
  }

  static double cellSizeForWidth(
    double width, {
    double horizontalPadding = 16,
  }) {
    final double available = (width - horizontalPadding * 2).clamp(200, 600);
    return available / 7;
  }

  FutureBuilder<MoodDay?> _dayBuilder(
    BuildContext context,
    DateTime day,
    DateTime focusedDay,
    double cellSize,
  ) {
    return FutureBuilder<MoodDay?>(
      future: getIt.get<GetEntryByDayUseCase>().execute(day),
      builder: (BuildContext context, AsyncSnapshot<MoodDay?> snapshot) {
        final MoodDay? entry = snapshot.data;
        final bool isSelected = isSameDay(selectedDate, day);
        return CalendarDayView(
          day: day,
          entry: entry,
          isFocused: isSelected,
          cellSize: cellSize,
          gridColors: gridColors,
          onDateChanged: onDateChanged,
        );
      },
    );
  }

  FutureBuilder<MoodDay?> _outsideDayBuilder(
    BuildContext context,
    DateTime day,
    DateTime focusedDay,
    double cellSize,
  ) {
    return FutureBuilder<MoodDay?>(
      future: getIt.get<GetEntryByDayUseCase>().execute(day),
      builder: (BuildContext context, AsyncSnapshot<MoodDay?> snapshot) {
        final MoodDay? entry = snapshot.data;
        return Opacity(
          opacity: 0.2,
          child: CalendarDayView(
            day: day,
            entry: entry,
            isFocused: false,
            isOutside: true,
            cellSize: cellSize,
            gridColors: gridColors,
            onDateChanged: onDateChanged,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double cellSize = cellSizeForWidth(
      width,
      horizontalPadding: horizontalPadding,
    );

    return TableCalendar<dynamic>(
      firstDay: DateTime.utc(2025),
      lastDay: DateTime.utc(2035, 12, 31),
      startingDayOfWeek: StartingDayOfWeek.monday,
      focusedDay: focusedDate,
      selectedDayPredicate: (DateTime day) => isSameDay(selectedDate, day),
      locale: Localizations.localeOf(context).languageCode,
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        onDateChanged(selectedDay);
        onFocusedDateChanged(focusedDay);
      },
      onPageChanged: onFocusedDateChanged,
      rowHeight: cellSize,
      daysOfWeekHeight: 18,
      calendarStyle: const CalendarStyle(
        outsideDaysVisible: true,
        cellMargin: EdgeInsets.zero,
        cellPadding: EdgeInsets.zero,
      ),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        headerPadding: const EdgeInsets.only(bottom: 2),
        titleTextStyle: Theme.of(context).textTheme.bodyMedium!,
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: Theme.of(context).colorScheme.primary,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.primary,
        ),
        leftChevronPadding: EdgeInsets.zero,
        rightChevronPadding: EdgeInsets.zero,
        leftChevronMargin: EdgeInsets.zero,
        rightChevronMargin: EdgeInsets.zero,
      ),
      calendarBuilders: CalendarBuilders<Widget>(
        defaultBuilder:
            (BuildContext c, DateTime d, DateTime f) =>
                _dayBuilder(c, d, f, cellSize),
        todayBuilder:
            (BuildContext c, DateTime d, DateTime f) =>
                _dayBuilder(c, d, f, cellSize),
        selectedBuilder:
            (BuildContext c, DateTime d, DateTime f) =>
                _dayBuilder(c, d, f, cellSize),
        outsideBuilder:
            (BuildContext c, DateTime d, DateTime f) =>
                _outsideDayBuilder(c, d, f, cellSize),
      ),
    );
  }
}
