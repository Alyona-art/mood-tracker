import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../application/get_it/get_it.dart';
import '../../data/repositories/emotion_repository.dart';
import '../../domain/models/emotion.dart';
import '../../domain/models/mood_day.dart';
import '../../domain/services/emotion_mapping.dart';
import '../../domain/usecases/get_entry_by_day.dart';
import '../bloc/mood_bloc.dart';
import '../bloc/preferences_cubit.dart';
import '../shared/assets/l10n.dart';
import '../shared/extensions/emotion_localization_extension.dart';
import 'custom_slider.dart';
import 'custom_text_button.dart';
import 'emotion_selection_grid.dart';

class MoodMeterWidget extends StatefulWidget {
  const MoodMeterWidget({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  @override
  State<MoodMeterWidget> createState() => _MoodMeterWidgetState();
}

enum _ViewState { sliders, emotionSelection, saved }

class _MoodMeterWidgetState extends State<MoodMeterWidget> {
  late DateTime _currentDate;
  List<Emotion> _emotions = <Emotion>[];
  MoodDay? _currentEntry;
  bool _isLoading = true;
  int _energy = 4;
  int _pleasantness = 4;
  _ViewState _viewState = _ViewState.sliders;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.selectedDate;
    _loadData();
  }

  @override
  void didUpdateWidget(MoodMeterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _currentDate = widget.selectedDate;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final List<Emotion> emotions =
        await getIt<EmotionRepository>().getAllEmotions();
    final MoodDay? entry = await getIt<GetEntryByDayUseCase>().execute(
      _currentDate,
    );
    setState(() {
      _emotions = emotions;
      _currentEntry = entry;
      _energy = entry?.energy ?? 4;
      _pleasantness = entry?.pleasantness ?? 4;
      _viewState =
          entry != null && entry.emotion.isNotEmpty
              ? _ViewState.saved
              : _ViewState.sliders;
      _isLoading = false;
    });
  }

  void _navigateDate(int days) {
    final DateTime newDate = _currentDate.add(Duration(days: days));
    setState(() => _currentDate = newDate);
    widget.onDateChanged(newDate);
    _loadData();
  }

  String _formatDate(BuildContext context, DateTime date) {
    return DateFormat(
      'd MMMM, EE',
      Localizations.localeOf(context).languageCode,
    ).format(date);
  }

  void _saveMood(Emotion emotion) {
    final DateTime date = DateTime(
      _currentDate.year,
      _currentDate.month,
      _currentDate.day,
    );

    context.read<MoodBloc>().add(
      AddMoodEntry(
        date: date,
        audioPath: _currentEntry?.audioPath ?? '',
        text: _currentEntry?.text ?? '',
        emotion: emotion.id,
        energy: _energy,
        pleasantness: _pleasantness,
      ),
    );

    setState(() {
      _viewState = _ViewState.saved;
    });
  }

  void _clearMood() {
    final DateTime date = DateTime(
      _currentDate.year,
      _currentDate.month,
      _currentDate.day,
    );

    context.read<MoodBloc>().add(DeleteMoodEntry(date));

    setState(() {
      _viewState = _ViewState.sliders;
      _energy = 4;
      _pleasantness = 4;
    });
  }

  void _onSliderChanged() {
    setState(() {
      _viewState = _ViewState.emotionSelection;
    });
  }

  List<Emotion> _getSurroundingEmotions() {
    final List<String> availableEmotionIds =
        _emotions.map((Emotion e) => e.id).toList();
    final List<String> emotionIds = EmotionMapping.getSurroundingEmotions(
      energy: _energy,
      pleasantness: _pleasantness,
      availableEmotionIds: availableEmotionIds,
    );

    final Map<String, Emotion> emotionMap = <String, Emotion>{
      for (final Emotion e in _emotions) e.id: e,
    };

    return emotionIds
        .map((String id) => emotionMap[id])
        .whereType<Emotion>()
        .toList();
  }

  Widget _buildSlider({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
    required Color color,
    required IconData leadingIcon,
    required IconData trailingIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Icon(leadingIcon),
            Expanded(
              child: CustomSlider(
                value: value,
                onChanged: (int newValue) {
                  setState(() {
                    onChanged(newValue);
                  });
                },
                color: color,
              ),
            ),
            Icon(trailingIcon),
          ],
        ),
      ],
    );
  }

  Widget _buildContent() {
    switch (_viewState) {
      case _ViewState.sliders:
        return _buildSlidersView();
      case _ViewState.emotionSelection:
        return _buildEmotionSelectionView();
      case _ViewState.saved:
        return _buildSavedView();
    }
  }

  Widget _buildSlidersView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildSlider(
            label: S.of(context).howEnergy,
            value: _energy,
            onChanged: (int value) {
              setState(() => _energy = value);
            },
            color: Colors.orange.shade300,
            leadingIcon: Icons.trending_down_outlined,
            trailingIcon: Icons.trending_up_outlined,
          ),
          const SizedBox(height: 32),
          _buildSlider(
            label: S.of(context).howPleasant,
            value: _pleasantness,
            onChanged: (int value) {
              setState(() => _pleasantness = value);
            },
            color: Colors.purple.shade300,

            leadingIcon: Icons.sentiment_dissatisfied_outlined,
            trailingIcon: Icons.sentiment_satisfied_outlined,
          ),
          const SizedBox(height: 32),
          CustomTextButton(
            text: S.of(context).continueButton,
            onPressed: _onSliderChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionSelectionView() {
    final List<Emotion> surroundingEmotions = _getSurroundingEmotions();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            S.of(context).chooseMood,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          EmotionSelectionGrid(
            emotions: surroundingEmotions,
            onEmotionSelected: _saveMood,
          ),
          const SizedBox(height: 24),
          CustomTextButton(
            onPressed: () {
              setState(() {
                _viewState = _ViewState.sliders;
              });
            },
            text: S.of(context).back,
          ),
        ],
      ),
    );
  }

  String _getAdviceDescription() {
    final bool isHighEnergy = _energy >= 4;
    final bool isHighPleasantness = _pleasantness >= 4;

    if (isHighEnergy && !isHighPleasantness) {
      return S.of(context).redDescription;
    } else if (isHighEnergy && isHighPleasantness) {
      return S.of(context).yellowDescription;
    } else if (!isHighEnergy && !isHighPleasantness) {
      return S.of(context).blueDescription;
    } else {
      return S.of(context).greenDescription;
    }
  }

  String _getAdviceText() {
    final bool isHighEnergy = _energy >= 4;
    final bool isHighPleasantness = _pleasantness >= 4;

    if (isHighEnergy && !isHighPleasantness) {
      return S.of(context).redAdvice;
    } else if (isHighEnergy && isHighPleasantness) {
      return S.of(context).yellowAdvice;
    } else if (!isHighEnergy && !isHighPleasantness) {
      return S.of(context).blueAdvice;
    } else {
      return S.of(context).greenAdvice;
    }
  }

  Widget _buildSavedView() {
    final Emotion? selectedEmotion =
        _currentEntry != null
            ? _emotions.firstWhere(
              (Emotion e) => e.id == _currentEntry!.emotion,
              orElse: () => _emotions.first,
            )
            : null;

    if (selectedEmotion == null) {
      return const SizedBox.shrink();
    }

    final Color color = selectedEmotion.color;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 16),
        BlocBuilder<PreferencesCubit, PreferencesState>(
          builder: (BuildContext context, PreferencesState state) {
            final String displayName = selectedEmotion.getDisplayName(
              context,
              showEnglishTranslations: state.showEnglishTranslations,
            );
            return Text(
              displayName,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            );
          },
        ),
        const SizedBox(height: 16),
        CustomTextButton(onPressed: _clearMood, text: S.of(context).clear),
        BlocBuilder<PreferencesCubit, PreferencesState>(
          builder: (BuildContext context, PreferencesState state) {
            if (!state.showAdvice) {
              return const SizedBox.shrink();
            }
            return Column(
              children: <Widget>[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _getAdviceDescription(),
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${S.of(context).YouCanTry} ${_getAdviceText()}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MoodBloc, MoodState>(
      listener: (BuildContext context, MoodState state) {
        if (state is MoodLoaded) {
          _loadData();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: () => _navigateDate(-1),
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                Text(
                  _formatDate(context, _currentDate),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: () => _navigateDate(1),
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child:
                _isLoading
                    ? CircularProgressIndicator(
                      padding: const EdgeInsets.all(32),
                      color: Theme.of(context).colorScheme.primary,
                    )
                    : _buildContent(),
          ),
        ],
      ),
    );
  }
}
