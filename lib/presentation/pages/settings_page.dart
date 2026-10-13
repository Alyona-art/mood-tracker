import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../application/get_it/get_it.dart';
import '../../data/repositories/mood_repository.dart';
import '../../domain/models/mood_day.dart';
import '../../domain/services/mood_markdown_export.dart';
import '../bloc/preferences_cubit.dart';
import '../shared/assets/l10n.dart';

Future<void> _exportMarkdown(BuildContext context) async {
  final S s = S.of(context);
  final Locale locale = Localizations.localeOf(context);
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTimeRange? range = await showDateRangePicker(
    context: context,
    locale: locale,
    firstDate: DateTime(2000),
    lastDate: today.add(const Duration(days: 365)),
    initialDateRange: DateTimeRange(
      start: today.subtract(const Duration(days: 30)),
      end: today,
    ),
  );
  if (range == null) {
    return;
  }
  if (!context.mounted) {
    return;
  }
  final List<MoodDay> entries = await getIt<MoodRepository>().getEntriesInDateRange(
    range.start,
    range.end,
  );
  if (!context.mounted) {
    return;
  }
  if (entries.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(s.exportMarkdownNoEntries)),
    );
    return;
  }
  final String markdown = buildMoodMarkdown(
    entries,
    energyLabel: s.exportMarkdownEnergy,
    feelingLabel: s.exportMarkdownFeeling,
    moodLabel: s.exportMarkdownMood,
  );
  await SharePlus.instance.share(ShareParams(text: markdown));
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).emotionSettings,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: BlocBuilder<PreferencesCubit, PreferencesState>(
        builder: (BuildContext context, PreferencesState state) {
          final bool isRussian =
              Localizations.localeOf(context).languageCode == 'ru';
          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: Text(S.of(context).exportAsMarkdown),
                subtitle: Text(S.of(context).exportMarkdownDescription),
                onTap: () => _exportMarkdown(context),
              ),
              SwitchListTile(
                title: Text(S.of(context).showAdvice),
                subtitle: Text(S.of(context).showAdviceDescription),
                value: state.showAdvice,
                onChanged: (bool value) {
                  context.read<PreferencesCubit>().setShowAdvice(value);
                },
              ),
              if (isRussian)
                SwitchListTile(
                  title: Text(S.of(context).showEnglishTranslations),
                  subtitle: Text(
                    S.of(context).showEnglishTranslationsDescription,
                  ),
                  value: state.showEnglishTranslations,
                  onChanged: (bool value) {
                    context.read<PreferencesCubit>().setShowEnglishTranslations(
                      value,
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
