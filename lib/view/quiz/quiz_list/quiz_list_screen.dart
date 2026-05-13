import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/models/quiz.dart';
import 'package:codelearn/repositories/quiz_repository.dart';
import 'package:codelearn/view/quiz/quiz_history/quiz_history_screen.dart';
import 'package:codelearn/view/quiz/quiz_list/widgets/quiz_card.dart';
import 'package:flutter/material.dart';
import 'package:codelearn/l10n/app_localizations.dart';
import 'package:get/get.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({super.key});

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  final _repo = QuizRepository();
  List<Quiz> _quizzes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    try {
      final quizzes = await _repo.getQuizzes();
      setState(() {
        _quizzes = quizzes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            actions: [
              IconButton(
                onPressed: () => Get.to(() => const QuizHistoryScreen()),
                icon: const Icon(Icons.history, color: Colors.white),
                tooltip: l10n.myQuizHistory,
              ),
              IconButton(
                onPressed: _loadQuizzes,
                icon: const Icon(Icons.refresh, color: Colors.white),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.all(16),
              title: Text(
                l10n.quizzes,
                style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.accent, fontWeight: FontWeight.bold),
              ),
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
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: 64, color: Colors.red.shade300),
                    const SizedBox(height: 12),
                    Text(l10n.error,
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(_error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600)),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                          _error = null;
                        });
                        _loadQuizzes();
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.retry),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          else if (_quizzes.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.quiz_outlined,
                        size: 72, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noQuizzesYet,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final quiz = _quizzes[index];
                    return QuizCard(
                      title: quiz.title,
                      description: quiz.description,
                      questionCount: quiz.questions.length,
                      timeLimit: quiz.timeLimit,
                      onTap: () => Get.toNamed(
                        '/quiz/${quiz.id}',
                        parameters: {'id': quiz.id},
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
