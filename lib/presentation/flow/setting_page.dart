import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../constants.dart';
import '../../domain/domain.dart';
import '../../i18n/i18n.dart';
import '../presentation.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late int _selectedId;
  late String _selectedColor;
  late String _selectedName;
  late TextEditingController _controller;
  late MoodsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _selectedId = 1;
    _cubit = context.read<MoodsCubit>();
    final Mood mood = _cubit.getMood(1)!;
    _selectedColor = mood.color;
    _selectedName = mood.name;
    _controller = TextEditingController(text: _selectedName);
    _controller.addListener(() {
      setState(() {
        _selectedName = _controller.text;
      });
      _cubit.setMood(
        Mood(
          id: _selectedId,
          name: _controller.text,
          color: _selectedColor,
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () => Navigator.maybePop(context),
        icon: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: <Widget>[
              Center(
                child: Text(t.settings.title),
              ),
              const SizedBox(height: 32),
              MoodList(
                selectedId: _selectedId,
                onTap: (Mood mood) {
                  setState(() {
                    _selectedId = mood.id;
                    _selectedColor = mood.color;
                    _selectedName = mood.name;
                    _controller.text = mood.name;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Theme(
                  data: themeData.copyWith(
                    inputDecorationTheme: const InputDecorationTheme(
                      focusedBorder: UnderlineInputBorder(),
                    ),
                  ),
                  child: TextField(
                    controller: _controller,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(20),
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              HueRingPicker(
                colorPickerHeight: 200,
                hueRingStrokeWidth: 25,
                pickerColor: _selectedColor.toColor() ?? Colors.white,
                onColorChanged: (Color color) {
                  _cubit.setMood(
                    Mood(
                      id: _selectedId,
                      name: _selectedName,
                      color: color.toHexString(),
                    ),
                  );
                  setState(() {
                    _selectedColor = color.toHexString();
                  });
                },
              ),
              const SizedBox(height: 32),
              SettingButton(
                onTap: () {
                  int index = 0;
                  for (final MapEntry<String, String> entry
                      in Constants.moods.entries) {
                    final String name =
                        context.read<MoodsCubit>().getMood(index)!.name;
                    context.read<MoodsCubit>().setMood(
                          Mood(
                            id: index,
                            name: name,
                            color: entry.key,
                          ),
                        );
                    if (_selectedId == index) {
                      setState(() {
                        _selectedColor = entry.key;
                      });
                    }
                    index++;
                  }
                },
                text: t.settings.colors,
              ),
              const SizedBox(height: 6),
              SettingButton(
                onTap: () {
                  int index = 0;
                  for (final MapEntry<String, String> entry
                      in Constants.moods.entries) {
                    final String color =
                        context.read<MoodsCubit>().getMood(index)!.color;
                    context.read<MoodsCubit>().setMood(
                          Mood(
                            id: index,
                            name: entry.value,
                            color: color,
                          ),
                        );
                    if (_selectedId == index) {
                      _controller.text = entry.value;
                    }
                    index++;
                  }
                },
                text: t.settings.names,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
