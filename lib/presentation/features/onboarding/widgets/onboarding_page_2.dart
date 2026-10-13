import 'package:flutter/material.dart';

import '../../../shared/assets/l10n.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            S.of(context).onboardingPage2Description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
        Image.asset('assets/images/onboarding-2.png'),
      ],
    );
  }
}
