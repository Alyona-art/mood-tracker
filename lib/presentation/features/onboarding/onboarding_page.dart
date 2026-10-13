import 'package:flutter/material.dart';

import '../../../application/get_it/get_it.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../pages/calendar_page.dart';
import '../../shared/assets/l10n.dart';
import '../../widget/custom_text_button.dart';
import 'widgets/onboarding_page_1.dart';
import 'widgets/onboarding_page_2.dart';
import 'widgets/onboarding_page_3.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _completeOnboarding() async {
    await getIt<SettingsRepository>().setOnboardingCompleted(true);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const CalendarPage()),
      );
    }
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() => _currentPage = page);
                },
                children: const <Widget>[
                  OnboardingPage1(),
                  OnboardingPage2(),
                  OnboardingPage3(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List<Widget>.generate(
                      3,
                      (int index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _currentPage == index
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outline
                                        .withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.maxFinite,
                    child: CustomTextButton(
                      text:
                          _currentPage == 2
                              ? S.of(context).getStarted
                              : S.of(context).continueButton,
                      onPressed: _nextPage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
