import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/emotion.dart';
import '../bloc/preferences_cubit.dart';
import '../shared/extensions/emotion_localization_extension.dart';

class EmotionSelectionGrid extends StatelessWidget {
  const EmotionSelectionGrid({
    super.key,
    required this.emotions,
    required this.onEmotionSelected,
  });

  final List<Emotion> emotions;
  final ValueChanged<Emotion> onEmotionSelected;

  @override
  Widget build(BuildContext context) {
    if (emotions.length < 4) {
      return const SizedBox.shrink();
    }

    return Column(
      children: <Widget>[
        _EmotionRow(
          first: emotions[0],
          second: emotions[1],
          onEmotionSelected: onEmotionSelected,
        ),
        _EmotionRow(
          first: emotions[2],
          second: emotions[3],
          onEmotionSelected: onEmotionSelected,
        ),
      ],
    );
  }
}

class _EmotionRow extends StatelessWidget {
  const _EmotionRow({
    required this.first,
    required this.second,
    required this.onEmotionSelected,
  });

  final Emotion first;
  final Emotion second;
  final ValueChanged<Emotion> onEmotionSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _EmotionCircle(emotion: first, onTap: () => onEmotionSelected(first)),
        _EmotionCircle(emotion: second, onTap: () => onEmotionSelected(second)),
      ],
    );
  }
}

class _EmotionCircle extends StatelessWidget {
  const _EmotionCircle({required this.emotion, required this.onTap});

  final Emotion emotion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = emotion.color;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(height: 8),
            BlocBuilder<PreferencesCubit, PreferencesState>(
              builder: (BuildContext context, PreferencesState state) {
                final String displayName = emotion.getDisplayName(
                  context,
                  showEnglishTranslations: state.showEnglishTranslations,
                );
                return SizedBox(
                  width: 120,
                  child: Text(
                    displayName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
