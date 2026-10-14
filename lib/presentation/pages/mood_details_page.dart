import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../domain/models/emotion.dart';
import '../../domain/services/emotion_mapping.dart';
import '../../domain/services/mood_shape.dart';
import '../shared/assets/l10n.dart';
import '../shared/extensions/emotion_localization_extension.dart';
import '../widget/mood_shape_view.dart';

class MoodDetailsResult {
  const MoodDetailsResult({
    required this.emotionIds,
    required this.note,
  });

  final Set<String> emotionIds;
  final String note;
}

class MoodDetailsPage extends StatefulWidget {
  const MoodDetailsPage({
    super.key,
    required this.date,
    required this.energy,
    required this.pleasantness,
    required this.color,
    required this.shape,
    required this.emotions,
    required this.initialEmotionIds,
    required this.initialNote,
  });

  final DateTime date;
  final int energy;
  final int pleasantness;
  final Color color;
  final MoodShapeParams shape;
  final List<Emotion> emotions;
  final Set<String> initialEmotionIds;
  final String initialNote;

  @override
  State<MoodDetailsPage> createState() => _MoodDetailsPageState();
}

class _MoodDetailsPageState extends State<MoodDetailsPage> {
  late final Set<String> _selected;
  late final TextEditingController _noteController;
  bool _showMore = false;

  @override
  void initState() {
    super.initState();
    _selected = Set<String>.from(widget.initialEmotionIds);
    _noteController = TextEditingController(text: widget.initialNote);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  List<Emotion> _suggestions({required bool expanded}) {
    final List<String> available =
        widget.emotions.map((Emotion e) => e.id).toList();
    final List<String> ids = EmotionMapping.getNearestEmotions(
      energyPercent: widget.energy,
      pleasantnessPercent: widget.pleasantness,
      availableEmotionIds: available,
      limit: expanded ? 12 : 6,
    );
    final Map<String, Emotion> map = <String, Emotion>{
      for (final Emotion e in widget.emotions) e.id: e,
    };
    return ids.map((String id) => map[id]).whereType<Emotion>().toList();
  }

  Future<void> _addCustomWord() async {
    final TextEditingController controller = TextEditingController();
    final String? word = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Своё слово'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'например, спокойный'),
            onSubmitted: (String v) => Navigator.pop(context, v.trim()),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: Text(S.of(context).add),
            ),
          ],
        );
      },
    );
    if (word == null || word.isEmpty || !mounted) {
      return;
    }
    setState(() => _selected.add(word));
  }

  @override
  Widget build(BuildContext context) {
    final String dateLabel = DateFormat(
      'd MMMM, EE',
      Localizations.localeOf(context).languageCode,
    ).format(widget.date);
    final List<Emotion> suggestions = _suggestions(expanded: _showMore);
    final List<String> customSelected =
        _selected
            .where((String id) => !widget.emotions.any((Emotion e) => e.id == id))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(dateLabel, style: Theme.of(context).textTheme.bodyLarge),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: <Widget>[
            Center(
              child: MoodShapeView(
                color: widget.color,
                params: widget.shape,
                size: 96,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Энергия ${widget.energy}% · приятность ${widget.pleasantness}%',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Каким был день сегодня?',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                ...suggestions.map(_emotionChip),
                ...customSelected.map(
                  (String id) => _chip(
                    label: id,
                    selected: true,
                    onTap: () => setState(() => _selected.remove(id)),
                  ),
                ),
                _chip(
                  label: '+ своё слово',
                  selected: false,
                  dashed: true,
                  onTap: _addCustomWord,
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => setState(() => _showMore = !_showMore),
                child: Text(_showMore ? 'меньше слов' : 'больше слов'),
              ),
            ),
            Text('Заметка', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              minLines: 4,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Что случилось сегодня, что запомнилось',
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(S.of(context).back),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        MoodDetailsResult(
                          emotionIds: _selected,
                          note: _noteController.text.trim(),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(S.of(context).save),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _emotionChip(Emotion emotion) {
    final bool selected = _selected.contains(emotion.id);
    final String label = emotion.getDisplayName(
      context,
      showEnglishTranslations: false,
    );
    return _chip(
      label: label,
      selected: selected,
      onTap: () {
        setState(() {
          if (selected) {
            _selected.remove(emotion.id);
          } else {
            _selected.add(emotion.id);
          }
        });
      },
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    bool dashed = false,
  }) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: scheme.primary,
      labelStyle: TextStyle(
        color: selected ? scheme.onPrimary : scheme.onSurface,
      ),
      backgroundColor: scheme.surfaceContainerHighest,
      side: dashed ? BorderSide(color: scheme.outline) : BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
