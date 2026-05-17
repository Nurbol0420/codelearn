import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/core/utils/app_dialogs.dart';
import 'package:codelearn/services/category_seed_service.dart';
import 'package:codelearn/view/teacher/teacher_home/widgets/dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codelearn/l10n/app_localizations.dart';

import 'package:codelearn/view/teacher/quiz_results/teacher_quiz_list_screen.dart';
import 'package:codelearn/view/chat/group_chat_screen.dart';
import 'package:get/get.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../routes/app_routes.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200, pinned: true,
            backgroundColor: AppColors.primary,
            actions: [
              IconButton(
                onPressed: () async {
                  final confirm = await AppDialogs.showLogoutDialog(context);
                  if (confirm == true) context.read<AuthBloc>().add(LogoutRequested());
                },
                icon: Icon(Icons.logout, color: AppColors.accent),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(l10n.teacherDashboard, style: const TextStyle(color: AppColors.accent)),
              background: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryLight], begin: Alignment.topLeft, end: Alignment.bottomRight))),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              delegate: SliverChildListDelegate([
                DashboardCard(title: l10n.myCourses, icon: Icons.book, onTap: () => Get.toNamed(AppRoutes.myCourses)),
                DashboardCard(title: l10n.createCourse, icon: Icons.add_circle, onTap: () => Get.toNamed(AppRoutes.createCourse)),
                DashboardCard(title: l10n.analytics, icon: Icons.analytics, onTap: () => Get.toNamed(AppRoutes.teacherAnalytics)),
                DashboardCard(title: l10n.studentProgress, icon: Icons.people, onTap: () => Get.toNamed(AppRoutes.studentProgress)),
                DashboardCard(title: l10n.messages, icon: Icons.chat, onTap: () => Get.toNamed(AppRoutes.teacherChats)),
                DashboardCard(title: l10n.createQuiz, icon: Icons.quiz_outlined, onTap: () => Get.toNamed(AppRoutes.createQuiz)),
                DashboardCard(title: l10n.myQuizzes, icon: Icons.bar_chart, onTap: () => Get.to(() => const TeacherQuizListScreen())),
                DashboardCard(title: l10n.groupChat, icon: Icons.groups, onTap: () => Get.to(() => const GroupChatScreen())),
                DashboardCard(
                  title: 'Обновить категории',
                  icon: Icons.category,
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: Text(l10n.updateCategoriesTitle),
                        content: Text(l10n.updateCategoriesBody),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(l10n.update),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      try {
                        await CategorySeedService.seedProgrammingCategories();
                        Get.snackbar('✅', l10n.updateCategoriesTitle, backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
                      } catch (e) {
                        Get.snackbar('Ошибка', '$e', backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
                      }
                    }
                  },
                ),
              ]),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}