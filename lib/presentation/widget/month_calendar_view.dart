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
  });

  final DateTime selectedDate;
  final DateTime focusedDate;
  final Function(DateTime) onDateChanged;
  final Function(DateTime) onFocusedDateChanged;

  FutureBuilder<MoodDay?> _dayBuilder(
    BuildContext context,
    DateTime day,
    DateTime focusedDay,
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
          onDateChanged: onDateChanged,
        );
      },
    );
  }

  FutureBuilder<MoodDay?> _outsideDayBuilder(
    BuildContext context,
    DateTime day,
    DateTime focusedDay,
  ) {
    return FutureBuilder<MoodDay?>(
      future: getIt.get<GetEntryByDayUseCase>().execute(day),
      builder: (BuildContext context, AsyncSnapshot<MoodDay?> snapshot) {
        final MoodDay? entry = snapshot.data;
        final bool isFocused = day == focusedDay;
        return Opacity(
          opacity: 0.2,
          child: CalendarDayView(
            day: day,
            entry: entry,
            isFocused: isFocused,
            isOutside: true,
            onDateChanged: onDateChanged,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar<dynamic>(
      firstDay: DateTime.utc(2025),
      lastDay: DateTime.utc(2035, 12, 31),
      startingDayOfWeek: StartingDayOfWeek.monday,
      focusedDay: focusedDate,
      selectedDayPredicate: (DateTime day) {
        return isSameDay(selectedDate, day);
      },
      locale: Localizations.localeOf(context).languageCode,
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        onDateChanged(selectedDay);
        onFocusedDateChanged(focusedDay);
      },
      onPageChanged: (DateTime focusedDay) {
        onFocusedDateChanged(focusedDay);
      },
      rowHeight: 40,
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.primaryContainer.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
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
        defaultBuilder: _dayBuilder,
        todayBuilder: _dayBuilder,
        selectedBuilder: _dayBuilder,
        outsideBuilder: _outsideDayBuilder,
      ),
    );
  }
}
