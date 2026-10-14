import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../application/get_it/get_it.dart';
import '../../data/repositories/emotion_repository.dart';
import '../../data/services/mood_grid_color_service.dart';
import '../../domain/models/emotion.dart';
import '../../domain/models/mood_day.dart';
import '../../domain/services/mood_advice.dart';
import '../../domain/services/mood_gradient_color.dart';
import '../../domain/services/mood_scale.dart';
import '../../domain/services/mood_shape.dart';
import '../../domain/usecases/get_entry_by_day.dart';
import '../bloc/mood_bloc.dart';
import '../bloc/preferences_cubit.dart';
import '../pages/mood_details_page.dart';
import '../shared/assets/l10n.dart';
import '../shared/extensions/emotion_localization_extension.dart';
import 'custom_slider.dart';
import 'custom_text_button.dart';
import 'expandable_note_card.dart';
import 'mood_shape_sheet.dart';
import 'mood_shape_view.dart';

class MoodMeterWidget extends StatefulWidget {
  const MoodMeterWidget({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    this.gridColors,
  });
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;
  final List<List<Color>>? gridColors;

  @override
  State<MoodMeterWidget> createState() => _MoodMeterWidgetState();
}

enum _ViewState { sliders, saved }

class _MoodMeterWidgetState extends State<MoodMeterWidget> {
  late DateTime _currentDate;
  List<Emotion> _emotions = <Emotion>[];
  MoodDay? _currentEntry;
  bool _isLoading = true;
  double _energy = MoodScale.defaultPercent.toDouble();
  double _pleasantness = MoodScale.defaultPercent.toDouble();
  double? _roundingOverride;
  double? _rayDepthOverride;
  double? _twistOverride;
  double? _varianceOverride;
  bool _slidersTouched = false;
  final Set<String> _selectedEmotionIds = <String>{};
  String _note = '';
  List<List<Color>>? _gridColors;
  _ViewState _viewState = _ViewState.sliders;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.selectedDate;
    _gridColors = widget.gridColors;
    _loadData();
  }

  @override
  void didUpdateWidget(MoodMeterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gridColors != widget.gridColors) {
      _gridColors = widget.gridColors;
    }
    if (oldWidget.selectedDate != widget.selectedDate) {
      _currentDate = widget.selectedDate;
      _loadData();
    }
  }

  int get _daySeed =>
      _currentDate.year * 10000 +
      _currentDate.month * 100 +
      _currentDate.day;

  bool get _shapeLocked =>
      _roundingOverride != null ||
      _rayDepthOverride != null ||
      _twistOverride != null ||
      _varianceOverride != null;

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final List<Emotion> emotions =
        await getIt<EmotionRepository>().getAllEmotions();
    final MoodDay? entry = await getIt<GetEntryByDayUseCase>().execute(
      _currentDate,
    );
    final List<List<Color>>? gridColors =
        widget.gridColors ??
        await getIt<MoodGridColorService>().getGridColors();

    setState(() {
      _gridColors = gridColors;
      _emotions = emotions;
      _currentEntry = entry;
      _energy = MoodScale.toPercent(entry?.energy).toDouble();
      _pleasantness = MoodScale.toPercent(entry?.pleasantness).toDouble();
      _roundingOverride =
          entry?.shapeRounding != null ? entry!.shapeRounding! / 100.0 : null;
      _rayDepthOverride =
          entry?.shapeRayDepth != null ? entry!.shapeRayDepth! / 100.0 : null;
      _twistOverride =
          entry?.shapeTwist != null ? entry!.shapeTwist! / 100.0 : null;
      _varianceOverride =
          entry?.shapeVariance != null ? entry!.shapeVariance! / 100.0 : null;
      _selectedEmotionIds
        ..clear()
        ..addAll(entry?.emotionIds ?? <String>[]);
      _note = entry?.text ?? '';
      final bool hasEntry =
          entry != null &&
          (entry.emotion.isNotEmpty ||
              entry.energy != null ||
              entry.pleasantness != null);
      _slidersTouched = hasEntry;
      _viewState = hasEntry ? _ViewState.saved : _ViewState.sliders;
      _isLoading = false;
    });
  }

  String _formatDate(BuildContext context, DateTime date) {
    return DateFormat(
      'd MMMM, EE',
      Localizations.localeOf(context).languageCode,
    ).format(date);
  }

  Color get _moodColor {
    if (!_slidersTouched) {
      return Theme.of(context).colorScheme.surfaceContainerHighest;
    }
    return MoodGradientColor.fromGridOrDefaults(
      energyPercent: _energy.round(),
      pleasantnessPercent: _pleasantness.round(),
      grid: _gridColors,
    );
  }

  MoodShapeParams get _autoShape => MoodShapeParams.fromMood(
    energyPercent: _energy.round(),
    pleasantnessPercent: _pleasantness.round(),
    seed: _daySeed,
  );

  MoodShapeParams get _currentShape => MoodShapeParams.fromMood(
    energyPercent: _energy.round(),
    pleasantnessPercent: _pleasantness.round(),
    cornerRoundingOverride: _roundingOverride,
    rayDepthOverride: _rayDepthOverride,
    twistOverride: _twistOverride,
    varianceOverride: _varianceOverride,
    seed: _daySeed,
  );

  void _clearShapeLock() {
    setState(() {
      _roundingOverride = null;
      _rayDepthOverride = null;
      _twistOverride = null;
      _varianceOverride = null;
    });
  }

  Future<void> _openShapeSheet() async {
    if (!_slidersTouched) {
      setState(() => _slidersTouched = true);
    }
    final MoodShapeSheetResult? result = await showMoodShapeSheet(
      context: context,
      color: _moodColor,
      initial: _currentShape,
      defaults: _autoShape,
    );
    if (result == null || !mounted) {
      return;
    }
    if (result.cleared || result.params == null) {
      _clearShapeLock();
      return;
    }
    final MoodShapeParams params = result.params!;
    setState(() {
      _slidersTouched = true;
      _roundingOverride = params.cornerRounding;
      _rayDepthOverride = params.rayDepth;
      _twistOverride = params.twist;
      _varianceOverride = params.variance;
    });
  }

  Future<void> _openDetailsPage() async {
    if (!_slidersTouched) {
      setState(() => _slidersTouched = true);
    }
    final MoodDetailsResult? result = await Navigator.of(context)
        .push<MoodDetailsResult>(
          MaterialPageRoute<MoodDetailsResult>(
            builder:
                (_) => MoodDetailsPage(
                  date: _currentDate,
                  energy: _energy.round(),
                  pleasantness: _pleasantness.round(),
                  color: _moodColor,
                  shape: _currentShape,
                  emotions: _emotions,
                  initialEmotionIds: _selectedEmotionIds,
                  initialNote: _note,
                ),
          ),
        );
    if (result == null || !mounted) {
      return;
    }
    setState(() {
      _selectedEmotionIds
        ..clear()
        ..addAll(result.emotionIds);
      _note = result.note;
    });
    _saveMood();
  }

  void _saveMood() {
    final DateTime date = DateTime(
      _currentDate.year,
      _currentDate.month,
      _currentDate.day,
    );

    context.read<MoodBloc>().add(
      AddMoodEntry(
        date: date,
        audioPath: _currentEntry?.audioPath ?? '',
        text: _note,
        emotion: MoodDay.joinEmotionIds(_selectedEmotionIds),
        energy: _energy.round(),
        pleasantness: _pleasantness.round(),
        shapeRounding:
            _roundingOverride != null
                ? (_roundingOverride! * 100).round()
                : null,
        shapeRayDepth:
            _rayDepthOverride != null
                ? (_rayDepthOverride! * 100).round()
                : null,
        shapeTwist:
            _twistOverride != null ? (_twistOverride! * 100).round() : null,
        shapeVariance:
            _varianceOverride != null
                ? (_varianceOverride! * 100).round()
                : null,
      ),
    );

    setState(() => _viewState = _ViewState.saved);
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
      _energy = MoodScale.defaultPercent.toDouble();
      _pleasantness = MoodScale.defaultPercent.toDouble();
      _roundingOverride = null;
      _rayDepthOverride = null;
      _twistOverride = null;
      _varianceOverride = null;
      _slidersTouched = false;
      _selectedEmotionIds.clear();
      _note = '';
    });
  }

  void _onEnergyChanged(double value) {
    setState(() {
      _energy = value;
      _slidersTouched = true;
    });
  }

  void _onPleasantnessChanged(double value) {
    setState(() {
      _pleasantness = value;
      _slidersTouched = true;
    });
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        CustomSlider(value: value, onChanged: onChanged, color: color),
      ],
    );
  }

  Widget _shapeLockChip() {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: InputChip(
        label: const Text('форма зафиксирована'),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: _clearShapeLock,
        onPressed: _clearShapeLock,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildSlidersView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AnimatedMoodShapeView(
            color: _moodColor,
            params: _currentShape,
            starAmount: _slidersTouched ? 1 : 0,
            size: 152,
          ),
          const SizedBox(height: 12),
          _buildSlider(
            label: 'Уровень энергии сегодня',
            value: _energy,
            onChanged: _onEnergyChanged,
            color: Colors.orange.shade300,
          ),
          const SizedBox(height: 8),
          _buildSlider(
            label: 'Насколько приятным был день',
            value: _pleasantness,
            onChanged: _onPleasantnessChanged,
            color: Colors.purple.shade300,
          ),
          if (_shapeLocked) _shapeLockChip(),
          BlocBuilder<PreferencesCubit, PreferencesState>(
            builder: (BuildContext context, PreferencesState state) {
              if (!state.allowShapeEditing || !_slidersTouched) {
                return const SizedBox(height: 8);
              }
              return Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Text(
                      'форма не отражает суть? ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    GestureDetector(
                      onTap: _openShapeSheet,
                      child: Text(
                        'подкрутить',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          CustomTextButton(
            text: S.of(context).continueButton,
            onPressed: _openDetailsPage,
          ),
        ],
      ),
    );
  }

  Widget _buildSavedView() {
    final List<String> labels = <String>[];
    for (final String id in _selectedEmotionIds) {
      Emotion? match;
      for (final Emotion e in _emotions) {
        if (e.id == id) {
          match = e;
          break;
        }
      }
      labels.add(
        match?.getDisplayName(context, showEnglishTranslations: false) ?? id,
      );
    }

    final MoodAdvice advice = MoodAdviceService.forMood(
      energyPercent: _energy.round(),
      pleasantnessPercent: _pleasantness.round(),
      date: _currentDate,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          MoodShapeView(color: _moodColor, params: _currentShape, size: 140),
          const SizedBox(height: 12),
          Text(
            'Энергия ${_energy.round()}% · приятность ${_pleasantness.round()}%',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (labels.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              labels.join(' · '),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
          if (_note.trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            ExpandableNoteCard(text: _note.trim()),
          ],
          BlocBuilder<PreferencesCubit, PreferencesState>(
            builder: (BuildContext context, PreferencesState state) {
              if (!state.showAdvice) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Совет: ${advice.suggestion}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed:
                      () => setState(() => _viewState = _ViewState.sliders),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('изменить'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: _clearMood,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(S.of(context).clear),
                ),
              ),
            ],
          ),
        ],
      ),
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
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: Text(
              _formatDate(context, _currentDate),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child:
                _isLoading
                    ? CircularProgressIndicator(
                      padding: const EdgeInsets.all(32),
                      color: Theme.of(context).colorScheme.primary,
                    )
                    : _viewState == _ViewState.sliders
                    ? _buildSlidersView()
                    : _buildSavedView(),
          ),
        ],
      ),
    );
  }
}
