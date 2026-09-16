import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';
import '../controller/onboarding_cubit.dart';
import '../controller/onboarding_state.dart';
import '../widgets/onboarding_page_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlideTimer();
  }

  void _startAutoSlideTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      if (_pageController.hasClients) {
        final nextPage = (_pageController.page?.round() ?? 0) + 1;
        if (nextPage < 3) {
          _pageController.animateToPage(
            nextPage,
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<OnboardingCubit, OnboardingState>(
            listener: (context, state) {
              _pageController.animateToPage(
                state.currentPage,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            builder: (context, state) {
              final cubit = context.read<OnboardingCubit>();

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

              return Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        cubit.onPageChanged(index);
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
                          width: state.currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: state.currentPage == index
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
                      text: state.isLastPage
                          ? t.onboarding.getStarted
                          : t.onboarding.next,
                      onPressed: () {
                        if (state.isLastPage) {
                          _navigateToRoleSelection(context);
                        } else {
                          cubit.nextPage(() => _navigateToRoleSelection(context));
                        }
                      },
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
              );
            },
          ),
        ),
      ),
    );
  }
}
