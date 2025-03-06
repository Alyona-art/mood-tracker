import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../domain/domain.dart';
import '../../../i18n/i18n.dart';
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
        .getDay(_selectedDate.difference(DateTime(Constants.year)).inDays)!
        .moodId;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoodsCubit, List<Mood>>(
        builder: (BuildContext context, List<Mood> state) {
      return Column(
        children: <Widget>[
          Text(DateFormat(
                  'd MMMM, EE', LocaleSettings.currentLocale.languageCode)
              .format(_selectedDate)),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: _selectedDate
                        .isBefore(DateTime(Constants.year, 1, 2))
                    ? null
                    : () => setState(() {
                          _selectedDate =
                              _selectedDate.subtract(const Duration(days: 1));
                          _selectedMood = context
                              .read<DaysCubit>()
                              .getDay(_selectedDate
                                  .difference(DateTime(Constants.year))
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
                      int id = mood.id;
                      if (_selectedMood == mood.id) {
                        id = -1;
                      }
                      setState(() {
                        _selectedMood = id;
                      });
                      context.read<DaysCubit>().setDay(
                            _selectedDate
                                .difference(DateTime(Constants.year))
                                .inDays,
                            _selectedDate,
                            id,
                          );
                    }),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed:
                    _selectedDate.isAfter(DateTime(Constants.year, 12, 30))
                        ? null
                        : () => setState(() {
                              _selectedDate =
                                  _selectedDate.add(const Duration(days: 1));
                              _selectedMood = context
                                  .read<DaysCubit>()
                                  .getDay(_selectedDate
                                      .difference(DateTime(Constants.year))
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
