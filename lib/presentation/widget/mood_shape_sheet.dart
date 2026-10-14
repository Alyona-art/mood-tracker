import 'package:flutter/material.dart';

import '../../domain/services/mood_shape.dart';
import 'custom_slider.dart';
import 'mood_shape_view.dart';

class MoodShapeSheetResult {
  const MoodShapeSheetResult.locked(this.params) : cleared = false;
  const MoodShapeSheetResult.cleared() : params = null, cleared = true;

  final MoodShapeParams? params;
  final bool cleared;
}

Future<MoodShapeSheetResult?> showMoodShapeSheet({
  required BuildContext context,
  required Color color,
  required MoodShapeParams initial,
  required MoodShapeParams defaults,
}) {
  return showModalBottomSheet<MoodShapeSheetResult>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (BuildContext context) {
      return _MoodShapeSheet(
        color: color,
        initial: initial,
        defaults: defaults,
      );
    },
  );
}

class _MoodShapeSheet extends StatefulWidget {
  const _MoodShapeSheet({
    required this.color,
    required this.initial,
    required this.defaults,
  });

  final Color color;
  final MoodShapeParams initial;
  final MoodShapeParams defaults;

  @override
  State<_MoodShapeSheet> createState() => _MoodShapeSheetState();
}

class _MoodShapeSheetState extends State<_MoodShapeSheet> {
  late double _rounding;
  late double _rayDepth;
  late double _twist;
  late double _variance;
  bool _resetRequested = false;

  @override
  void initState() {
    super.initState();
    _rounding = widget.initial.cornerRounding * 100;
    _rayDepth = widget.initial.rayDepth * 100;
    _twist = widget.initial.twist * 100;
    _variance = widget.initial.variance * 100;
  }

  MoodShapeParams get _params => MoodShapeParams(
    cornerRounding: _rounding / 100,
    rayDepth: _rayDepth / 100,
    twist: _twist / 100,
    variance: _variance / 100,
    seed: widget.initial.seed,
  );

  void _applyDefaults() {
    setState(() {
      _rounding = widget.defaults.cornerRounding * 100;
      _rayDepth = widget.defaults.rayDepth * 100;
      _twist = widget.defaults.twist * 100;
      _variance = widget.defaults.variance * 100;
      _resetRequested = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 0,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Форма настроения',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 12),
          MoodShapeView(color: widget.color, params: _params, size: 140),
          const SizedBox(height: 16),
          _labeledSlider(
            label: 'Скругление углов',
            value: _rounding,
            color: Colors.orange.shade300,
            onChanged: (double v) {
              setState(() {
                _rounding = v;
                _resetRequested = false;
              });
            },
          ),
          const SizedBox(height: 12),
          _labeledSlider(
            label: 'Глубина лучей',
            value: _rayDepth,
            color: Colors.deepOrange.shade300,
            onChanged: (double v) {
              setState(() {
                _rayDepth = v;
                _resetRequested = false;
              });
            },
          ),
          const SizedBox(height: 12),
          _labeledSlider(
            label: 'Закрутка и асимметрия',
            value: _twist,
            color: Colors.purple.shade300,
            onChanged: (double v) {
              setState(() {
                _twist = v;
                _resetRequested = false;
              });
            },
          ),
          const SizedBox(height: 12),
          _labeledSlider(
            label: 'Случайность лучей',
            value: _variance,
            color: Colors.teal.shade300,
            onChanged: (double v) {
              setState(() {
                _variance = v;
                _resetRequested = false;
              });
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: _applyDefaults,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('сбросить'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      _resetRequested
                          ? const MoodShapeSheetResult.cleared()
                          : MoodShapeSheetResult.locked(_params),
                    );
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: scheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('готово'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _labeledSlider({
    required String label,
    required double value,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ),
            Text('${value.round()}%'),
          ],
        ),
        CustomSlider(value: value, onChanged: onChanged, color: color),
      ],
    );
  }
}
