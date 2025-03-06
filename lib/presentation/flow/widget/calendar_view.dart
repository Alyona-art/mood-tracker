import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../domain/domain.dart';
import '../../presentation.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width / 42;
    final List<int> daysInMonth = <int>[
      31,
      DateTime.now().year % 4 == 0 ? 29 : 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];

    return BlocBuilder<DaysCubit, List<Day>>(
      builder: (BuildContext context, List<Day> state) {
        return BlocBuilder<MoodsCubit, List<Mood>>(
            builder: (BuildContext context, List<Mood> moodState) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 12,
            separatorBuilder: (BuildContext context, int month) =>
                const SizedBox(height: 2),
            itemBuilder: (BuildContext context, int month) {
              return Container(
                height: size,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: daysInMonth[month],
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(width: 2),
                  itemBuilder: (BuildContext context, int index) {
                    int count = 0;
                    for (int i = 0; i < month; i++) {
                      count += daysInMonth[i];
                    }
                    count += index;
                    final String? colorString = context
                        .read<MoodsCubit>()
                        .getMood(state[count].moodId)
                        ?.color;
                    final Color? color =
                        colorString == null || colorString == ''
                            ? null
                            : colorString.toColor();
                    return Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        border: color == null
                            ? Border.all(
                                color: Theme.of(context).dividerColor,
                              )
                            : null,
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    );
                  },
                ),
              );
            },
          );
        });
      },
    );
  }
}
