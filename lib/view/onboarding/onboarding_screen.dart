import 'package:codelearn/models/onboarding_item.dart';
import 'package:codelearn/view/onboarding/widgets/onboarding_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:codelearn/l10n/app_localizations.dart';

import '../../core/theme/app_color.dart';
import '../../routes/app_routes.dart';
import '../../services/storage_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  late List<OnBoardingItem> _pages;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final l10n = AppLocalizations.of(context)!;

    _pages = [
      OnBoardingItem(
        image: 'assets/images/onboarding/onboarding1.png',
        title: l10n.learnAnywhere,
        description: l10n.learnAnywhereDesc,
      ),
      OnBoardingItem(
        image: 'assets/images/onboarding/onboarding2.png',
        title: l10n.interactiveLearning,
        description: l10n.interactiveLearningDesc,
      ),
      OnBoardingItem(
        image: 'assets/images/onboarding/onboarding3.png',
        title: l10n.trackProgress,
        description: l10n.trackProgressDesc,
      ),
    ];
  }

  void _completeOnboarding() async {
    await StorageService.setFirstTime(false);
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPageWidget(
                page: _pages[index],
              );
            },
          ),

          // Skip button
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _completeOnboarding,
              child: Text(
                l10n.skip,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Bottom navigation
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: const WormEffect(
                    dotColor: Colors.white,
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 8,
                  ),
                  onDotClicked: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),

                ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _pages.length - 1) {
                      _completeOnboarding();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1
                        ? l10n.getStarted
                        : l10n.next,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}