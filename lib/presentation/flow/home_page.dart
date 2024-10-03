import 'package:flutter/material.dart';
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
      body: const Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text('welcome to 2024 and all of its possibilities'),
            ),
            SizedBox(height: 16),
            CalendarView(),
            SizedBox(height: 32),
            MoodTracker(),
          ],
        ),
      ),
    );
  }
}
