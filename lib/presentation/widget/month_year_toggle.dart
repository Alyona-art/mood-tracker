import 'package:flutter/material.dart';

import '../shared/assets/l10n.dart';

/// Compact Material [SegmentedButton] — indicator and track align reliably,
/// unlike the previous animated_toggle_switch sizing.
class MonthYearToggle extends StatelessWidget {
  const MonthYearToggle({
    super.key,
    required this.current,
    required this.onChanged,
  });

  final int current;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return SegmentedButton<int>(
      segments: <ButtonSegment<int>>[
        ButtonSegment<int>(
          value: 0,
          label: Text(S.of(context).month),
        ),
        ButtonSegment<int>(
          value: 1,
          label: Text(S.of(context).year),
        ),
      ],
      selected: <int>{current},
      onSelectionChanged: (Set<int> next) {
        if (next.isNotEmpty) {
          onChanged(next.first);
        }
      },
      showSelectedIcon: false,
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        padding: const WidgetStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 16),
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.selected)) {
            return scheme.onSecondaryContainer;
          }
          return scheme.onSurfaceVariant;
        }),
        backgroundColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.selected)) {
            return scheme.secondaryContainer;
          }
          return Colors.transparent;
        }),
        side: WidgetStatePropertyAll<BorderSide>(
          BorderSide(color: scheme.outlineVariant),
        ),
      ),
    );
  }
}
