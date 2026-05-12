import 'package:flutter/material.dart';

import '../../../../core/theme/app_color.dart';

class QuizCard extends StatelessWidget {
  final String title;
  final String description;
  final int questionCount;
  final int timeLimit;
  final VoidCallback onTap;

  const QuizCard({
    super.key,
    required this.title,
    required this.description,
    required this.questionCount,
    required this.timeLimit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuizStart(
                      theme,
                      Icons.quiz_outlined,
                      '$questionCount Questions',
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildQuizStart(theme, Icons.timer_outlined, '$timeLimit mins'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizStart(ThemeData theme, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.secondary),
        const SizedBox(width: 8),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}
