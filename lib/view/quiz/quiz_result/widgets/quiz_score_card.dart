import 'package:codelearn/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:codelearn/l10n/app_localizations.dart';

class QuizScoreCard extends StatelessWidget {
  final int percentage;
  final bool isPassed;
  const QuizScoreCard({super.key, required this.percentage, required this.isPassed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Text(
            isPassed ? l10n.congratulations : l10n.keepPracticing,
            style: theme.textTheme.headlineSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text('$percentage%', style: theme.textTheme.displayLarge?.copyWith(color: isPassed ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
          Text(l10n.score, style: theme.textTheme.titleMedium?.copyWith(color: AppColors.secondary)),
        ],
      ),
    );
  }
}
