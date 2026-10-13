import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

import '../../application/get_it/get_it.dart';
import '../../data/repositories/emotion_repository.dart';
import '../../data/repositories/mood_repository.dart';
import '../../data/services/mood_grid_color_service.dart';
import '../../domain/usecases/get_entry_by_day.dart';
import '../bloc/days_cubit.dart';
import '../bloc/mood_bloc.dart';
import '../bloc/moods_cubit.dart';
import '../shared/assets/l10n.dart';
import '../widget/custom_icon_button.dart';
import '../widget/month_calendar_view.dart';
import '../widget/month_year_toggle.dart';
import '../widget/mood_meter_widget.dart';
import '../widget/year_calendar_widget.dart';
import 'mood_grid_config_page.dart';
import 'settings_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  int viewIndex = 0;

  late final MoodRepository repository;
  late final EmotionRepository emotionRepository;
  late final GetEntryByDayUseCase getEntryByDayUseCase;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    repository = getIt<MoodRepository>();
    emotionRepository = getIt<EmotionRepository>();
    getEntryByDayUseCase = getIt<GetEntryByDayUseCase>();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onDateChanged(DateTime date) {
    setState(() => _selectedDate = date);
  }

  void _onFocusedDateChanged(DateTime date, BuildContext context) {
    final int oldYear = _focusedDate.year;
    setState(() => _focusedDate = date);
    // Reload days cubit when focused date changes to a different year
    if (date.year != oldYear && mounted) {
      context.read<DaysCubit>().loadDays(date.year);
    }
  }

  PreferredSizeWidget _appBarBuilder(BuildContext context) {
    return AppBar(
      title: MonthYearToggle(
        current: viewIndex,
        onChanged:
            (int value) => setState(() {
              viewIndex = value;
              _pageController.animateToPage(
                value,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            }),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: CustomIconButton(
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
              if (mounted && context.mounted) {
                context.read<MoodsCubit>().loadMoods();
              }
            }
          },
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CustomIconButton(
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
        ),
      ],
      actionsPadding: EdgeInsets.zero,
      leadingWidth: 46,
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
              appBar: _appBarBuilder(context),
              body: BlocListener<MoodBloc, MoodState>(
                listener: (BuildContext context, MoodState state) {
                  if (state is MoodLoaded) {
                    // Always reload days cubit when moods are updated
                    // so year calendar shows updated data when switching views
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
                      return ListView(
                        shrinkWrap: true,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(
                            height: 300,
                            child: PageView(
                              controller: _pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 48,
                                  ),
                                  child: Builder(
                                    builder:
                                        (BuildContext builderContext) =>
                                            MonthCalendarView(
                                              selectedDate: _selectedDate,
                                              focusedDate: _focusedDate,
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
                                YearCalendarWidget(year: _focusedDate.year),
                              ],
                            ),
                          ),

                          MoodMeterWidget(
                            selectedDate: _selectedDate,
                            onDateChanged: _onDateChanged,
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
                                    color: Theme.of(context).colorScheme.error,
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
    );
  }
}
