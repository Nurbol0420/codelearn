import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/models/quiz.dart';
import 'package:codelearn/models/quiz_attempt.dart';
import 'package:codelearn/repositories/quiz_repository.dart';
import 'package:flutter/material.dart';
import 'package:codelearn/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TeacherQuizResultsScreen extends StatefulWidget {
  final Quiz quiz;
  const TeacherQuizResultsScreen({super.key, required this.quiz});

  @override
  State<TeacherQuizResultsScreen> createState() =>
      _TeacherQuizResultsScreenState();
}

class _TeacherQuizResultsScreenState extends State<TeacherQuizResultsScreen> {
  final _repo = QuizRepository();
  List<QuizAttempt> _attempts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final attempts = await _repo.getAttemptsByQuiz(widget.quiz.id);
      setState(() { _attempts = attempts; _isLoading = false; });
    } catch (e) {
      setState(() { _isLoading = false; _error = e.toString(); });
    }
  }

  int get _totalPoints =>
      widget.quiz.questions.fold(0, (s, q) => s + q.points);

  int get _passedCount =>
      _attempts.where((a) => _pct(a) >= 70).length;

  double get _avgScore => _attempts.isEmpty
      ? 0
      : _attempts.fold(0.0, (s, a) => s + _pct(a)) / _attempts.length;

  int _pct(QuizAttempt a) =>
      _totalPoints > 0 ? ((a.score / _totalPoints) * 100).round() : 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // AppBar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.all(16),
              title: Text(widget.quiz.title,
                  style: theme.textTheme.titleLarge?.copyWith(
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
          else if (_error != null)
            SliverFillRemaining(
                child: Center(
                    child: Text(_error!,
                        style: const TextStyle(color: Colors.red))))
          else ...[
            // Summary cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats row
                    Row(children: [
                      _SummaryCard(
                        icon: Icons.people,
                        value: '${_attempts.length}',
                        label: l10n.totalStudents,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      _SummaryCard(
                        icon: Icons.check_circle,
                        value: '$_passedCount',
                        label: l10n.passed,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 12),
                      _SummaryCard(
                        icon: Icons.bar_chart,
                        value: '${_avgScore.toStringAsFixed(0)}%',
                        label: l10n.avgScore,
                        color: Colors.orange,
                      ),
                    ]),
                    const SizedBox(height: 24),

                    if (_attempts.isEmpty)
                      Center(
                        child: Column(children: [
                          const SizedBox(height: 40),
                          Icon(Icons.inbox_outlined,
                              size: 72, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          Text(l10n.noStudentsYet,
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(color: Colors.grey)),
                        ]),
                      )
                    else ...[
                      Text(l10n.studentResults,
                          style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary)),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ),

            // Student list
            if (_attempts.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _StudentResultCard(
                      attempt: _attempts[i],
                      totalPoints: _totalPoints,
                      index: i,
                    ),
                    childCount: _attempts.length,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

// ── Summary card ─────────────────────────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(color: color, fontSize: 11)),
        ]),
      ),
    );
  }
}

// ── Student result card ───────────────────────────────────────────────────────
class _StudentResultCard extends StatelessWidget {
  final QuizAttempt attempt;
  final int totalPoints;
  final int index;

  const _StudentResultCard({
    required this.attempt,
    required this.totalPoints,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final pct =
        totalPoints > 0 ? ((attempt.score / totalPoints) * 100).round() : 0;
    final passed = pct >= 70;
    final date = attempt.completedAt != null
        ? DateFormat('dd.MM.yyyy  HH:mm').format(attempt.completedAt!)
        : '-';
    final minutes = (attempt.timeSpent / 60).floor();
    final seconds = attempt.timeSpent % 60;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Rank circle
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text('${index + 1}',
                  style: const TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(attempt.userId,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.grey)),
                  const SizedBox(height: 4),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct / 100,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          passed ? Colors.green : Colors.red),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(children: [
                    Text('$pct%  •  ${attempt.score}/$totalPoints ${l10n.points}  •  ${minutes}m ${seconds}s',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey.shade600)),
                  ]),
                  Text(date,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.grey.shade400, fontSize: 11)),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: passed ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$pct%',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
