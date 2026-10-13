import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../application/get_it/get_it.dart';
import '../../data/services/mood_grid_color_service.dart';
import '../../domain/utils/color_utils.dart';
import '../shared/assets/l10n.dart';
import '../widget/custom_text_button.dart';
import '../widget/mood_grid_preview.dart';

class MoodGridConfigPage extends StatefulWidget {
  const MoodGridConfigPage({super.key});

  @override
  State<MoodGridConfigPage> createState() => _MoodGridConfigPageState();
}

class _MoodGridConfigPageState extends State<MoodGridConfigPage> {
  Color topLeftColor = MoodGridColorService.defaultTopLeftColor;
  Color topRightColor = MoodGridColorService.defaultTopRightColor;
  Color bottomLeftColor = MoodGridColorService.defaultBottomLeftColor;
  Color bottomRightColor = MoodGridColorService.defaultBottomRightColor;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCustomColors();
  }

  Future<void> _loadCustomColors() async {
    final MoodGridColorService colorService = getIt<MoodGridColorService>();
    final List<List<Color>>? gridColors = await colorService.getGridColors();

    if (gridColors != null &&
        gridColors.length == 6 &&
        gridColors[0].length == 6) {
      setState(() {
        // Extract corner colors from the grid
        // top-left: [0][0], top-right: [0][5], bottom-left: [5][0], bottom-right: [5][5]
        topLeftColor = gridColors[0][0];
        topRightColor = gridColors[0][5];
        bottomLeftColor = gridColors[5][0];
        bottomRightColor = gridColors[5][5];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<List<Color>> _generateGridColors() {
    return List<List<Color>>.generate(6, (int row) {
      final double y = row / 5.0;
      return List<Color>.generate(6, (int col) {
        final double x = col / 5.0;
        return ColorUtils.bilinearColor(
          x: x,
          y: y,
          tl: topLeftColor,
          tr: topRightColor,
          bl: bottomLeftColor,
          br: bottomRightColor,
        );
      });
    });
  }

  void _resetToDefault() {
    setState(() {
      topLeftColor = MoodGridColorService.defaultTopLeftColor;
      topRightColor = MoodGridColorService.defaultTopRightColor;
      bottomLeftColor = MoodGridColorService.defaultBottomLeftColor;
      bottomRightColor = MoodGridColorService.defaultBottomRightColor;
    });
  }

  void _saveColors() {
    final List<List<Color>> gridColors = _generateGridColors();
    Navigator.pop(context, gridColors);
  }

  Future<void> _pickColor(
    Color currentColor,
    Function(Color) onColorChanged,
  ) async {
    final Color? pickedColor = await showDialog<Color>(
      context: context,
      builder:
          (BuildContext context) =>
              _ColorPickerDialog(initialColor: currentColor),
    );
    if (pickedColor != null) {
      onColorChanged(pickedColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).everythingHands,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final List<List<Color>> gridColors = _generateGridColors();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).everythingHands,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            S.of(context).customizeColors,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            mainAxisSize: MainAxisSize.min,

            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _CornerColorPicker(
                    color: topLeftColor,
                    onTap:
                        () => _pickColor(topLeftColor, (Color color) {
                          setState(() => topLeftColor = color);
                        }),
                  ),
                  const SizedBox(width: 12),
                  _CornerColorPicker(
                    color: topRightColor,
                    onTap:
                        () => _pickColor(topRightColor, (Color color) {
                          setState(() => topRightColor = color);
                        }),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _CornerColorPicker(
                    color: bottomLeftColor,
                    onTap:
                        () => _pickColor(bottomLeftColor, (Color color) {
                          setState(() => bottomLeftColor = color);
                        }),
                  ),
                  const SizedBox(width: 12),
                  _CornerColorPicker(
                    color: bottomRightColor,
                    onTap:
                        () => _pickColor(bottomRightColor, (Color color) {
                          setState(() => bottomRightColor = color);
                        }),
                  ),
                ],
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.all(32),
            child: Icon(Icons.arrow_downward, size: 30),
          ),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double size = constraints.maxWidth;
              return MoodGridPreview(size: size, gridColors: gridColors);
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              Expanded(
                child: CustomTextButton(
                  onPressed: _resetToDefault,
                  text: S.of(context).resetToDefaults,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextButton(
                  onPressed: _saveColors,
                  text: S.of(context).saveColors,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CornerColorPicker extends StatelessWidget {
  const _CornerColorPicker({required this.color, required this.onTap});

  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

class _ColorPickerDialog extends StatefulWidget {
  const _ColorPickerDialog({required this.initialColor});

  final Color initialColor;

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick a Color'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            HueRingPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                setState(() => selectedColor = color);
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, selectedColor),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
