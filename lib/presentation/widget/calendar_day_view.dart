import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/emotion.dart';
import '../../domain/models/mood_day.dart';
import '../bloc/moods_cubit.dart';

class CalendarDayView extends StatelessWidget {
  const CalendarDayView({
    super.key,
    required this.day,
    required this.entry,
    required this.isFocused,
    this.isOutside = false,
    required this.onDateChanged,
  });

  final DateTime day;
  final MoodDay? entry;
  final bool isFocused;
  final bool isOutside;
  final Function(DateTime) onDateChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onDateChanged(day);
      },
      child: BlocBuilder<MoodsCubit, List<Emotion>>(
        builder: (BuildContext context, List<Emotion> moods) {
          final Color backgroundColor =
              Theme.of(context).colorScheme.surfaceContainerHighest;

          Color? dayColor;
          if (entry?.emotion != null) {
            try {
              final Emotion emotion = moods.firstWhere(
                (Emotion mood) => mood.id == entry!.emotion,
              );
              dayColor = emotion.color;
            } catch (e) {
              dayColor = null;
            }
          }

          final Color finalColor = dayColor ?? backgroundColor;
          final bool hasEntry = entry != null;

          return Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: hasEntry ? finalColor : backgroundColor,
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    isFocused
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                width: isFocused ? 2.5 : 0,
              ),
            ),
          );
        },
      ),
    );
  }
}
