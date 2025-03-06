import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nested/nested.dart';

import '../constants.dart';
import '../data/data.dart';
import '../di.dart';
import '../domain/domain.dart';
import '../i18n/i18n.dart';
import 'presentation.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    final Box<DayDTO> dayBox = Hive.box<DayDTO>(Constants.dayBox);

    final int year = DateTime.now().year % 4 == 0 ? 366 : 365;
    DateTime currentDate = DateTime(DateTime.now().year);

    if (dayBox.isEmpty) {
      for (int i = 0; i < year; i++) {
        dayBox.add(Day.toEntity(Day(date: currentDate, moodId: -1)));
        currentDate = currentDate.add(const Duration(days: 1));
      }
    }
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: DI.getInstance().init(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiBlocProvider(
            providers: <SingleChildWidget>[
              BlocProvider<MoodsCubit>(
                create: (BuildContext context) => MoodsCubit(),
              ),
              BlocProvider<DaysCubit>(
                create: (BuildContext context) => DaysCubit(),
              ),
            ],
            child: MaterialApp(
              locale: TranslationProvider.of(context).flutterLocale,
              supportedLocales: AppLocaleUtils.supportedLocales,
              localizationsDelegates: GlobalMaterialLocalizations.delegates,
              theme: ThemeData(
                brightness: Brightness.light,
                /* light theme settings */
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                /* dark theme settings */
              ),
              themeMode: ThemeMode.system,
              home: const HomePage(),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
