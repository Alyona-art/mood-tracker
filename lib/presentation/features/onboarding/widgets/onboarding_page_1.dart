import 'package:flutter/material.dart';

import '../../../shared/assets/l10n.dart';
import 'simple_mood_grid.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          S.of(context).onboardingPage1Title,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(40),
          child: Text(
            S.of(context).onboardingPage1Description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
        const SimpleMoodGrid(),
      ],
    );
  }
}
