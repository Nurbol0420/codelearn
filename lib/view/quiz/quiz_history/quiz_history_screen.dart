import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/models/quiz_attempt.dart';
import 'package:codelearn/repositories/quiz_repository.dart';
import 'package:codelearn/repositories/quiz_repository.dart';
import 'package:codelearn/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:codelearn/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class QuizHistoryScreen extends StatefulWidget {
  const QuizHistoryScreen({super.key});

  @override
  State<QuizHistoryScreen> createState() => _QuizHistoryScreenState();
}

class _QuizHistoryScreenState extends State<QuizHistoryScreen> {
  final _repo = QuizRepository();
  List<QuizAttempt> _attempts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAttempts();
  }

  Future<void> _loadAttempts() async {
    final userId = UserService().getCurrentUserId();
    if (userId == null) {
      setState(() { _isLoading = false; _error = 'Not logged in'; });
      return;
    }
    try {
      final attempts = await _repo.getMyAttempts(userId);
      setState(() { _attempts = attempts; _isLoading = false; });
    } catch (e) {
      setState(() { _isLoading = false; _error = e.toString(); });
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
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.all(16),
              title: Text(l10n.myQuizHistory,
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
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            SliverFillRemaining(
              child: Center(child: Text(_error!, style: const TextStyle(color: Colors.red))),
            )
          else if (_attempts.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.quiz_outlined, size: 72, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text(l10n.noAttemptsYet,
                        style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey)),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _AttemptCard(attempt: _attempts[i]),
                  childCount: _attempts.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AttemptCard extends StatelessWidget {
  final QuizAttempt attempt;
  const _AttemptCard({required this.attempt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    // Quiz title fallback - use quizId if quiz not in cache
    final quizTitle = attempt.quizId;
    final totalPoints = attempt.score; // total from attempt
    final percentage = totalPoints > 0
        ? ((attempt.score / totalPoints) * 100).round()
        : 0;
    final passed = percentage >= 70;
    final date = attempt.completedAt != null
        ? DateFormat('dd.MM.yyyy  HH:mm').format(attempt.completedAt!)
        : '-';
    final minutes = (attempt.timeSpent / 60).floor();
    final seconds = attempt.timeSpent % 60;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(children: [
              Expanded(
                child: Text(attempt.quizId,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: passed ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  passed ? l10n.passed : l10n.failed,
                  style: const TextStyle(color: Colors.white,
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            const SizedBox(height: 12),

            // Score bar
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                    passed ? Colors.green : Colors.red),
              ),
            ),
            const SizedBox(height: 8),

            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatChip(
                    icon: Icons.star, label: '$percentage%', color: passed ? Colors.green : Colors.red),
                _StatChip(
                    icon: Icons.check_circle_outline,
                    label: '${attempt.score}/$totalPoints ${l10n.points}',
                    color: AppColors.primary),
                _StatChip(
                    icon: Icons.timer_outlined,
                    label: '${minutes}m ${seconds}s',
                    color: Colors.orange),
              ],
            ),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(date,
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
            ]),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _StatChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 4),
      Text(label,
          style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
    ]);
  }
}
