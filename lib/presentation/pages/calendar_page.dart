import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

import '../../application/get_it/get_it.dart';
import '../../data/repositories/emotion_repository.dart';
import '../../data/repositories/mood_repository.dart';
import '../../data/services/mood_grid_color_service.dart';
import '../bloc/days_cubit.dart';
import '../bloc/mood_bloc.dart';
import '../bloc/moods_cubit.dart';
import '../shared/assets/l10n.dart';
import '../widget/custom_icon_button.dart';
import '../widget/month_calendar_view.dart';
import '../widget/mood_meter_widget.dart';
import 'insights_page.dart';
import 'mood_grid_config_page.dart';
import 'settings_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  static const double _calendarPad = 48;

  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  List<List<Color>>? _gridColors;

  late final MoodRepository repository;
  late final EmotionRepository emotionRepository;

  @override
  void initState() {
    super.initState();
    repository = getIt<MoodRepository>();
    emotionRepository = getIt<EmotionRepository>();
    _loadGridColors();
  }

  Future<void> _loadGridColors() async {
    final List<List<Color>>? colors =
        await getIt<MoodGridColorService>().getGridColors();
    if (!mounted) {
      return;
    }
    setState(() => _gridColors = colors);
  }

  void _onDateChanged(DateTime date) {
    setState(() => _selectedDate = date);
  }

  void _onFocusedDateChanged(DateTime date, BuildContext context) {
    final int oldYear = _focusedDate.year;
    setState(() => _focusedDate = date);
    if (date.year != oldYear && mounted) {
      context.read<DaysCubit>().loadDays(date.year);
    }
  }

  Widget _scrollHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: <Widget>[
          CustomIconButton(
            icon: Icons.edit_outlined,
            onPressed: () async {
              final List<List<Color>>? result =
                  await Navigator.push<List<List<Color>>>(
                    context,
                    MaterialPageRoute<List<List<Color>>>(
                      builder: (_) => const MoodGridConfigPage(),
                    ),
                  );
              if (result != null) {
                await getIt<MoodGridColorService>().saveGridColors(result);
                await getIt<EmotionRepository>().updateAllEmotionColors();
                await _loadGridColors();
                if (mounted && context.mounted) {
                  context.read<MoodsCubit>().loadMoods();
                }
              }
            },
          ),
          const Spacer(),
          CustomIconButton(
            icon: Icons.insights_outlined,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder:
                      (_) => MultiBlocProvider(
                        providers: <SingleChildWidget>[
                          BlocProvider<MoodBloc>.value(
                            value: context.read<MoodBloc>(),
                          ),
                          BlocProvider<DaysCubit>.value(
                            value: context.read<DaysCubit>(),
                          ),
                          BlocProvider<MoodsCubit>.value(
                            value: context.read<MoodsCubit>(),
                          ),
                        ],
                        child: InsightsPage(initialYear: _focusedDate.year),
                      ),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          CustomIconButton(
            icon: Icons.settings_outlined,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (_) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<MoodBloc>(
          create:
              (_) => MoodBloc(getIt<MoodRepository>())..add(LoadMoodEntries()),
        ),
        BlocProvider<DaysCubit>(
          create: (_) => DaysCubit(repository)..loadDays(_focusedDate.year),
        ),
        BlocProvider<MoodsCubit>(
          create: (_) => MoodsCubit(emotionRepository)..loadMoods(),
        ),
      ],
      child: Builder(
        builder:
            (BuildContext context) => Scaffold(
              body: SafeArea(
                child: BlocListener<MoodBloc, MoodState>(
                  listener: (BuildContext context, MoodState state) {
                    if (state is MoodLoaded) {
                      context.read<DaysCubit>().loadDays(_focusedDate.year);
                    }
                  },
                  child: BlocBuilder<MoodBloc, MoodState>(
                    builder: (BuildContext context, MoodState state) {
                      if (state is MoodLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      } else if (state is MoodLoaded) {
                        final double calendarHeight =
                            MonthCalendarView.heightForWidth(
                              MediaQuery.sizeOf(context).width,
                              horizontalPadding: _calendarPad,
                            );
                        return ListView(
                          children: <Widget>[
                            _scrollHeader(context),
                            SizedBox(
                              height: calendarHeight,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: _calendarPad,
                                ),
                                child: Builder(
                                  builder:
                                      (BuildContext builderContext) =>
                                          MonthCalendarView(
                                            selectedDate: _selectedDate,
                                            focusedDate: _focusedDate,
                                            horizontalPadding: _calendarPad,
                                            gridColors: _gridColors,
                                            onDateChanged: _onDateChanged,
                                            onFocusedDateChanged:
                                                (DateTime date) =>
                                                    _onFocusedDateChanged(
                                                      date,
                                                      builderContext,
                                                    ),
                                          ),
                                ),
                              ),
                            ),
                            MoodMeterWidget(
                              selectedDate: _selectedDate,
                              onDateChanged: _onDateChanged,
                              gridColors: _gridColors,
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      } else if (state is MoodError) {
                        return Center(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    S.of(context).error(state.message),
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
