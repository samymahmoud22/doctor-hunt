import 'dart:async';
import 'package:flutter/material.dart';

import 'package:doctor_hunt/core/router/app_router.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';
import '../widgets/onboarding_page_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  static const int _pageCount = 3;

  @override
  void initState() {
    super.initState();
    _startAutoSlideTimer();
  }

  void _startAutoSlideTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      if (_pageController.hasClients) {
        if (_currentPage < _pageCount - 1) {
          _pageController.animateToPage(
            _currentPage + 1,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        } else {
          _timer?.cancel();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToRoleSelection(BuildContext context) {
    _timer?.cancel();
    const ChooseRoleRoute().go(context);
  }

  void _onNextPressed() {
    if (_currentPage < _pageCount - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToRoleSelection(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = _currentPage == _pageCount - 1;

    final pages = [
      OnboardingPageContent(
        title: t.onboarding.title1,
        description: t.onboarding.desc1,
        imageAsset: 'assets/images/onboarding1.jpg',
        iconData: Icons.medical_services_outlined,
        arcAlignment: Alignment.topLeft,
      ),
      OnboardingPageContent(
        title: t.onboarding.title2,
        description: t.onboarding.desc2,
        imageAsset: 'assets/images/onboarding2.jpg',
        iconData: Icons.local_hospital_outlined,
        arcAlignment: Alignment.topRight,
      ),
      OnboardingPageContent(
        title: t.onboarding.title3,
        description: t.onboarding.desc3,
        imageAsset: 'assets/images/onboarding3.jpg',
        iconData: Icons.calendar_month_outlined,
        arcAlignment: Alignment.topLeft,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: pages,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomButton(
                text: isLastPage ? t.onboarding.getStarted : t.onboarding.next,
                onPressed: _onNextPressed,
              ),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => _navigateToRoleSelection(context),
              child: Text(
                t.onboarding.skip,
                style: const TextStyle(
                  color: AppColors.textSub,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
