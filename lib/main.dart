import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'constants.dart';

import 'data/data.dart';
import 'presentation/app.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(DayDTOAdapter());
  Hive.registerAdapter(MoodDTOAdapter());
  await Hive.openBox<DayDTO>(Constants.dayBox);
  await Hive.openBox<MoodDTO>(Constants.moodBox);

  runApp(const MyApp());
}
