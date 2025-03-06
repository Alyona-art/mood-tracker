import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../i18n/i18n.dart';
import 'setting_page.dart';
import 'widget/calendar_view.dart';
import 'widget/mood_tracker.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const SettingPage(),
          ),
        ),
        icon: const Icon(Icons.settings_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(t.welcome(name: Constants.year)),
            ),
            const SizedBox(height: 16),
            const CalendarView(),
            const SizedBox(height: 32),
            const MoodTracker(),
          ],
        ),
      ),
    );
  }
}
