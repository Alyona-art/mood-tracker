import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class CustomSlider extends StatelessWidget {
  const CustomSlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.color,
    this.min = 0,
    this.max = 100,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final Color color;
  final double min;
  final double max;

  @override
  Widget build(BuildContext context) {
    return SfSliderTheme(
      data: SfSliderThemeData(
        activeTrackHeight: 14,
        activeTrackColor: color,
        inactiveTrackColor:
            Theme.of(context).colorScheme.surfaceContainerHighest,
        inactiveTrackHeight: 14,
        thumbRadius: 11,
        overlayRadius: 16,
        // Keep track ends aligned with thumb travel (no unreachable strip).
        trackCornerRadius: 7,
      ),
      child: SfSlider(
        value: value.clamp(min, max),
        min: min,
        max: max,
        activeColor: color,
        onChanged: (dynamic newValue) {
          onChanged((newValue as double).clamp(min, max));
        },
      ),
    );
  }
}
