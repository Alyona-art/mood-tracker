import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';

import '../shared/assets/l10n.dart';

class MonthYearToggle extends StatelessWidget {
  const MonthYearToggle({
    super.key,
    required this.current,
    required this.onChanged,
  });

  final int current;
  final Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: AnimatedToggleSwitch<int>.size(
        current: current,
        values: const <int>[0, 1],
        selectedIconScale: 1.0,
        indicatorSize: const Size(150, 30),
        height: 30,
        onChanged: onChanged,
        iconBuilder:
            (int value) => Text(
              value == 0 ? S.of(context).month : S.of(context).year,
              style: Theme.of(context).textTheme.bodyLarge,
            ),

        styleBuilder:
            (int value) => ToggleStyle(
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              indicatorColor: Theme.of(context).colorScheme.surfaceContainer,
              borderColor: Colors.transparent,
            ),
      ),
    );
  }
}
