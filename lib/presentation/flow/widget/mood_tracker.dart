import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../domain/domain.dart';
import '../../presentation.dart';

class MoodTracker extends StatefulWidget {
  const MoodTracker({super.key});

  @override
  State<MoodTracker> createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  late DateTime _selectedDate;
  late int _selectedMood;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedMood = context
        .read<DaysCubit>()
        .getDay(_selectedDate.difference(DateTime(2024)).inDays)!
        .moodId;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoodsCubit, List<Mood>>(builder: (BuildContext context, List<Mood> state) {
      return Column(
        children: <Widget>[
          Text(DateFormat('d MMMM').format(_selectedDate)),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: _selectedDate.isBefore(DateTime(2024, 1, 2))
                    ? null
                    : () => setState(() {
                          _selectedDate =
                              _selectedDate.subtract(const Duration(days: 1));
                          _selectedMood = context
                              .read<DaysCubit>()
                              .getDay(_selectedDate
                                  .difference(DateTime(2024))
                                  .inDays)!
                              .moodId;
                        }),
                icon: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                  ),
                ),
              ),
              Expanded(
                child: MoodList(
                  selectedId: _selectedMood,
                  onTap: (Mood mood) {
                  setState(() {
                  _selectedMood = mood.id;
                });
                context.read<DaysCubit>().setDay(
                      _selectedDate.difference(DateTime(2024)).inDays,
                      _selectedDate,
                      mood.id,
                    );
                }),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: _selectedDate.isAfter(DateTime(2024, 12, 30))
                    ? null
                    : () => setState(() {
                          _selectedDate =
                              _selectedDate.add(const Duration(days: 1));
                          _selectedMood = context
                              .read<DaysCubit>()
                              .getDay(_selectedDate
                                  .difference(DateTime(2024))
                                  .inDays)!
                              .moodId;
                        }),
                icon: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
