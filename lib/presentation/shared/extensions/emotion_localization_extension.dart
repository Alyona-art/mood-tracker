import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/models/emotion.dart';
import '../../bloc/preferences_cubit.dart';
import '../assets/l10n.dart';

extension EmotionLocalizationExtension on Emotion {
  String getName(BuildContext context) {
    final S localizations = S.of(context);
    switch (id) {
      // High Energy, High Pleasantness
      case 'ecstatic':
        return localizations.emotionEcstatic;
      case 'festive':
        return localizations.emotionFestive;
      case 'surprised':
        return localizations.emotionSurprised;
      case 'excited':
        return localizations.emotionExcited;
      case 'optimistic':
        return localizations.emotionOptimistic;
      case 'energized':
        return localizations.emotionEnergized;
      case 'blissful':
        return localizations.emotionBlissful;
      case 'proud':
        return localizations.emotionProud;
      case 'pleasant':
        return localizations.emotionPleasant;

      // Low Energy, High Pleasantness
      case 'fulfilled':
        return localizations.emotionFulfilled;
      case 'content':
        return localizations.emotionContent;
      case 'at ease':
        return localizations.emotionAtEase;
      case 'balanced':
        return localizations.emotionBalanced;
      case 'blessed':
        return localizations.emotionBlessed;
      case 'relaxed':
        return localizations.emotionRelaxed;
      case 'serene':
        return localizations.emotionSerene;
      case 'tranquil':
        return localizations.emotionTranquil;
      case 'sleepy':
        return localizations.emotionSleepy;

      // High Energy, Low Pleasantness
      case 'enraged':
        return localizations.emotionEnraged;
      case 'stressed':
        return localizations.emotionStressed;
      case 'shocked':
        return localizations.emotionShocked;
      case 'fuming':
        return localizations.emotionFuming;
      case 'angry':
        return localizations.emotionAngry;
      case 'restless':
        return localizations.emotionRestless;
      case 'repulse':
        return localizations.emotionRepulse;
      case 'worried':
        return localizations.emotionWorried;
      case 'annoyed':
        return localizations.emotionAnnoyed;

      // Low Energy, Low Pleasantness
      case 'disgusted':
        return localizations.emotionDisgusted;
      case 'down':
        return localizations.emotionDown;
      case 'apathetic':
        return localizations.emotionApathetic;
      case 'miserable':
        return localizations.emotionMiserable;
      case 'lonely':
        return localizations.emotionLonely;
      case 'tired':
        return localizations.emotionTired;
      case 'despair':
        return localizations.emotionDespair;
      case 'desolate':
        return localizations.emotionDesolate;
      case 'drained':
        return localizations.emotionDrained;

      default:
        return id;
    }
  }

  String getDisplayName(BuildContext context, {bool? showEnglishTranslations}) {
    final String localizedName = getName(context);
    final bool isRussian = Localizations.localeOf(context).languageCode == 'ru';

    if (!isRussian) {
      return localizedName;
    }

    final bool showEnglish =
        showEnglishTranslations ??
        (() {
          try {
            final PreferencesCubit cubit = context.read<PreferencesCubit>();
            return cubit.state.showEnglishTranslations;
          } catch (_) {
            return false;
          }
        })();

    if (showEnglish && id != localizedName) {
      return '$localizedName\n($id)';
    }

    return localizedName;
  }
}
