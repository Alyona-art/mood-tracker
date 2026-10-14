import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../application/get_it/get_it.dart';
import '../../data/services/mood_grid_color_service.dart';
import '../../domain/models/mood_day.dart';
import '../../domain/services/mood_stats.dart';
import '../bloc/days_cubit.dart';
import '../bloc/mood_bloc.dart';
import '../widget/mood_stats_charts.dart';
import '../widget/year_calendar_widget.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key, required this.initialYear});

  final int initialYear;

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  late int _year;
  MoodStatsPeriod _period = MoodStatsPeriod.month;
  MoodDateRange? _customRange;
  List<List<Color>>? _gridColors;

  @override
  void initState() {
    super.initState();
    _year = widget.initialYear;
    _loadGridColors();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DaysCubit>().loadDays(_year);
      }
    });
  }

  Future<void> _loadGridColors() async {
    final List<List<Color>>? colors =
        await getIt<MoodGridColorService>().getGridColors();
    if (!mounted) {
      return;
    }
    setState(() => _gridColors = colors);
  }

  void _changeYear(int delta) {
    setState(() => _year += delta);
    context.read<DaysCubit>().loadDays(_year);
  }

  MoodDateRange get _chartRange {
    if (_period == MoodStatsPeriod.year) {
      return MoodDateRange(
        start: DateTime(_year),
        end: DateTime(_year, 12, 31),
      );
    }
    if (_period == MoodStatsPeriod.custom && _customRange != null) {
      return _customRange!;
    }
    return MoodStatsService.rangeForPeriod(_period);
  }

  Future<void> _onPeriodChanged(MoodStatsPeriod? value) async {
    if (value == null) {
      return;
    }
    if (value == MoodStatsPeriod.custom) {
      final DateTime now = DateTime.now();
      final DateTime today = DateTime(now.year, now.month, now.day);
      final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        locale: Localizations.localeOf(context),
        firstDate: DateTime(2000),
        lastDate: today.add(const Duration(days: 365)),
        initialDateRange: DateTimeRange(
          start:
              _customRange?.start ??
              today.subtract(const Duration(days: 30)),
          end: _customRange?.end ?? today,
        ),
      );
      if (picked == null) {
        return;
      }
      setState(() {
        _period = MoodStatsPeriod.custom;
        _customRange = MoodDateRange(
          start: DateTime(
            picked.start.year,
            picked.start.month,
            picked.start.day,
          ),
          end: DateTime(picked.end.year, picked.end.month, picked.end.day),
        );
      });
      return;
    }
    setState(() => _period = value);
  }

  String _periodLabel(MoodStatsPeriod period) {
    switch (period) {
      case MoodStatsPeriod.week:
        return 'Неделя';
      case MoodStatsPeriod.month:
        return 'Месяц';
      case MoodStatsPeriod.year:
        return 'Год';
      case MoodStatsPeriod.custom:
        return 'Другой период';
    }
  }

  String _rangeCaption(MoodDateRange range) {
    final String locale = Localizations.localeOf(context).languageCode;
    final DateFormat fmt = DateFormat('d MMM y', locale);
    if (range.start == range.end) {
      return fmt.format(range.start);
    }
    return '${fmt.format(range.start)} — ${fmt.format(range.end)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Итоги', style: Theme.of(context).textTheme.bodyLarge),
      ),
      body: BlocBuilder<MoodBloc, MoodState>(
        builder: (BuildContext context, MoodState state) {
          final List<MoodDay> entries =
              state is MoodLoaded ? state.entries : <MoodDay>[];
          final MoodDateRange range = _chartRange;
          final List<MoodSeriesPoint> points = MoodStatsService.seriesInRange(
            entries,
            range,
          );

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () => _changeYear(-1),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text(
                    '$_year',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    onPressed: () => _changeYear(1),
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              YearCalendarWidget(year: _year, gridColors: _gridColors),
              const SizedBox(height: 28),
              Row(
                children: <Widget>[
                  Text(
                    'Динамика',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<MoodStatsPeriod>(
                      value: _period,
                      borderRadius: BorderRadius.circular(12),
                      items: <DropdownMenuItem<MoodStatsPeriod>>[
                        for (final MoodStatsPeriod p in MoodStatsPeriod.values)
                          DropdownMenuItem<MoodStatsPeriod>(
                            value: p,
                            child: Text(_periodLabel(p)),
                          ),
                      ],
                      onChanged: _onPeriodChanged,
                    ),
                  ),
                ],
              ),
              Text(
                _rangeCaption(range),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              MoodTrendChart(points: points, range: range),
            ],
          );
        },
      ),
    );
  }
}
