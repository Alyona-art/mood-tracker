import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/day.dart';
import '../../domain/models/emotion.dart';
import '../../domain/services/mood_gradient_color.dart';
import '../../domain/services/mood_scale.dart';
import '../../domain/utils/date_utils.dart' as calendar_utils;
import '../bloc/days_cubit.dart';
import '../bloc/moods_cubit.dart';
import '../shared/assets/l10n.dart';

class YearCalendarWidget extends StatelessWidget {
  const YearCalendarWidget({
    super.key,
    required this.year,
    this.showTitle = false,
    this.gridColors,
  });

  final int year;
  final bool showTitle;
  final List<List<Color>>? gridColors;

  static const double _gap = 2;

  int _getStartingDayIndex(int month, List<int> daysPerMonth) {
    int sum = 0;
    for (int i = 0; i < month; i++) {
      sum += daysPerMonth[i];
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    final List<int> daysPerMonth = calendar_utils
        .CalendarDateUtils.getDaysPerMonth(year);

    return BlocBuilder<DaysCubit, List<Day>>(
      builder: (BuildContext context, List<Day> daysState) {
        return BlocBuilder<MoodsCubit, List<Emotion>>(
          builder: (BuildContext context, List<Emotion> moodsState) {
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // Fit 31 days + 30 gaps into the actual parent width.
                final double size =
                    (constraints.maxWidth - _gap * 30) / 31;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (showTitle)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          S.of(context).welcome('$year'),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    for (int monthIndex = 0; monthIndex < 12; monthIndex++) ...<
                      Widget
                    >[
                      if (monthIndex > 0) const SizedBox(height: _gap),
                      _MonthRow(
                        size: size,
                        gap: _gap,
                        daysInMonth: daysPerMonth[monthIndex],
                        startIndex: _getStartingDayIndex(
                          monthIndex,
                          daysPerMonth,
                        ),
                        daysState: daysState,
                        gridColors: gridColors,
                      ),
                    ],
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

class _MonthRow extends StatelessWidget {
  const _MonthRow({
    required this.size,
    required this.gap,
    required this.daysInMonth,
    required this.startIndex,
    required this.daysState,
    this.gridColors,
  });

  final double size;
  final double gap;
  final int daysInMonth;
  final int startIndex;
  final List<Day> daysState;
  final List<List<Color>>? gridColors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: Row(
        children: <Widget>[
          for (int dayIndex = 0; dayIndex < daysInMonth; dayIndex++) ...<Widget>[
            if (dayIndex > 0) SizedBox(width: gap),
            _DayDot(
              size: size,
              day:
                  startIndex + dayIndex < daysState.length
                      ? daysState[startIndex + dayIndex]
                      : null,
              gridColors: gridColors,
            ),
          ],
        ],
      ),
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({required this.size, required this.day, this.gridColors});

  final double size;
  final Day? day;
  final List<List<Color>>? gridColors;

  @override
  Widget build(BuildContext context) {
    final Color empty =
        Theme.of(context).colorScheme.surfaceContainerHighest;

    if (day == null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
      );
    }

    final Emotion? mood = context.read<MoodsCubit>().getMood(day!.moodId);
    final bool hasContinuous =
        day!.energy != null || day!.pleasantness != null;
    final bool hasData =
        hasContinuous || (day!.moodId != null && mood != null);

    final Color color;
    if (hasContinuous) {
      color = MoodGradientColor.fromGridOrDefaults(
        energyPercent: MoodScale.toPercent(day!.energy),
        pleasantnessPercent: MoodScale.toPercent(day!.pleasantness),
        grid: gridColors,
      );
    } else if (mood != null) {
      color = mood.color;
    } else {
      color = empty;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: hasData ? color : empty,
      ),
    );
  }
}
