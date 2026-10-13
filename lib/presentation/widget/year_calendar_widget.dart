import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/day.dart';
import '../../domain/models/emotion.dart';
import '../../domain/utils/date_utils.dart' as calendar_utils;
import '../bloc/days_cubit.dart';
import '../bloc/moods_cubit.dart';
import '../shared/assets/l10n.dart';

class YearCalendarWidget extends StatelessWidget {
  const YearCalendarWidget({super.key, required this.year});

  final int year;

  int _getStartingDayIndex(int month, List<int> daysPerMonth) {
    int sum = 0;
    for (int i = 0; i < month; i++) {
      sum += daysPerMonth[i];
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    final double size = (MediaQuery.of(context).size.width - 2 * 31 - 24) / 31;
    final List<int> daysPerMonth = calendar_utils
        .CalendarDateUtils.getDaysPerMonth(year);

    return BlocBuilder<DaysCubit, List<Day>>(
      builder: (BuildContext context, List<Day> daysState) {
        return BlocBuilder<MoodsCubit, List<Emotion>>(
          builder: (BuildContext context, List<Emotion> moodsState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsetsGeometry.symmetric(vertical: 16),
                  child: Text(
                    S.of(context).welcome('$year'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 12,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  separatorBuilder:
                      (BuildContext context, int index) =>
                          const SizedBox(height: 2),
                  itemBuilder: (BuildContext context, int monthIndex) {
                    final int startIndex = _getStartingDayIndex(
                      monthIndex,
                      daysPerMonth,
                    );
                    final int daysInMonth = daysPerMonth[monthIndex];

                    return SizedBox(
                      height: size,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: daysInMonth,
                        separatorBuilder:
                            (BuildContext context, int index) =>
                                const SizedBox(width: 2),
                        itemBuilder: (BuildContext context, int dayIndex) {
                          final int absoluteDayIndex = startIndex + dayIndex;

                          if (absoluteDayIndex >= daysState.length) {
                            return Container(
                              width: size,
                              height: size,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                ),
                              ),
                            );
                          }

                          final Day day = daysState[absoluteDayIndex];
                          final Emotion? mood = context
                              .read<MoodsCubit>()
                              .getMood(day.moodId);

                          final bool hasData =
                              day.moodId != null && mood != null;

                          return Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  hasData
                                      ? mood.color
                                      : Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainerHighest,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
