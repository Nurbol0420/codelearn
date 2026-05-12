import 'package:codelearn/bloc/navigation/navigation_bloc.dart';
import 'package:codelearn/view/course/course_list/course_list_screen.dart';
import 'package:codelearn/view/home/home_screen.dart';
import 'package:codelearn/view/profile/profile_screen.dart';
import 'package:codelearn/view/quiz/quiz_list/quiz_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:codelearn/l10n/app_localizations.dart';

import 'package:codelearn/view/chat/group_chat_screen.dart';

import 'bloc/navigation/navigation_event.dart';
import 'bloc/navigation/navigation_state.dart';
import 'core/theme/app_color.dart';

class MainScreen extends StatelessWidget {
  final int? initialIndex;

  const MainScreen({super.key, this.initialIndex});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) =>
      NavigationBloc()..add(NavigateToTab(initialIndex ?? 0)),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.lightBackground,
            body: IndexedStack(
              index: state.currentIndex,
              children: [
                HomeScreen(),
                CourseListScreen(),
                QuizListScreen(),
                ProfileScreen(),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => Get.to(() => const GroupChatScreen()),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.chat, color: Colors.white),
            ),
            bottomNavigationBar: NavigationBar(
              backgroundColor: AppColors.accent,
              indicatorColor: AppColors.primary.withOpacity(0.1),
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home),
                  label: l10n.tabHome,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.play_lesson_outlined),
                  selectedIcon: const Icon(Icons.play_lesson),
                  label: l10n.tabCourses,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.quiz_outlined),
                  selectedIcon: const Icon(Icons.quiz),
                  label: l10n.tabQuizzes,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.person_outline),
                  selectedIcon: const Icon(Icons.person),
                  label: l10n.tabProfile,
                ),
              ],
              selectedIndex: state.currentIndex,
              onDestinationSelected: (index) {
                context.read<NavigationBloc>().add(NavigateToTab(index));
              },
            ),
          );
        },
      ),
    );
  }
}
