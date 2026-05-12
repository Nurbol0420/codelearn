import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/models/quiz.dart';
import 'package:codelearn/repositories/quiz_repository.dart';
import 'package:codelearn/view/teacher/quiz_results/teacher_quiz_results_screen.dart';
import 'package:flutter/material.dart';
import 'package:codelearn/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TeacherQuizListScreen extends StatefulWidget {
  const TeacherQuizListScreen({super.key});

  @override
  State<TeacherQuizListScreen> createState() => _TeacherQuizListScreenState();
}

class _TeacherQuizListScreenState extends State<TeacherQuizListScreen> {
  final _repo = QuizRepository();
  List<Quiz> _quizzes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final quizzes = await _repo.getQuizzes();
      setState(() { _quizzes = quizzes; _isLoading = false; });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            actions: [
              IconButton(
                onPressed: () => Get.toNamed('/teacher/quiz/create'),
                icon: const Icon(Icons.add, color: Colors.white),
                tooltip: l10n.createQuiz,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.all(16),
              title: Text(l10n.myQuizzes,
                  style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),

          if (_isLoading)
            const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()))
          else if (_quizzes.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.quiz_outlined,
                        size: 72, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text(l10n.noQuizzesYet,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: Colors.grey)),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => Get.toNamed('/teacher/quiz/create'),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.createQuiz),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final quiz = _quizzes[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: const Icon(Icons.quiz, color: AppColors.primary),
                        ),
                        title: Text(quiz.title,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(quiz.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey.shade600)),
                            const SizedBox(height: 4),
                            Row(children: [
                              Icon(Icons.help_outline,
                                  size: 14, color: Colors.grey.shade400),
                              const SizedBox(width: 4),
                              Text('${quiz.questions.length} ${l10n.questionsCount}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500)),
                              const SizedBox(width: 12),
                              Icon(Icons.timer_outlined,
                                  size: 14, color: Colors.grey.shade400),
                              const SizedBox(width: 4),
                              Text('${quiz.timeLimit} ${l10n.minutes}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500)),
                            ]),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right,
                            color: AppColors.primary),
                        onTap: () => Get.to(
                          () => TeacherQuizResultsScreen(quiz: quiz),
                        ),
                      ),
                    );
                  },
                  childCount: _quizzes.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
