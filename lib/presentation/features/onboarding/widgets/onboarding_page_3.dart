import 'package:flutter/material.dart';

import '../../../shared/assets/l10n.dart';
import 'year_calendar_preview.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          S.of(context).onboardingPage3Title,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            S.of(context).onboardingPage3Description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
        const YearCalendarPreview(),
      ],
    );
  }
}
