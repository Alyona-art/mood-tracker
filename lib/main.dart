import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'constants.dart';

import 'data/data.dart';
import 'i18n/i18n.dart';
import 'presentation/app.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(DayDTOAdapter());
  Hive.registerAdapter(MoodDTOAdapter());
  await Hive.openBox<DayDTO>(Constants.dayBox);
  await Hive.openBox<MoodDTO>(Constants.moodBox);

  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();

  runApp(TranslationProvider(child: const MyApp()));
}
