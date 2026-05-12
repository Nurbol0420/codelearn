import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/models/question.dart';
import 'package:codelearn/models/quiz.dart';
import 'package:codelearn/models/quiz_attempt.dart';
import 'package:flutter/material.dart';

class QuizQuestionAnalysis extends StatelessWidget {
  final Quiz quiz;
  final QuizAttempt attempt;
  const QuizQuestionAnalysis({
    super.key,
    required this.quiz,
    required this.attempt,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question Analysis',
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...quiz.questions.map((question) {
            final userAnswer = attempt.answers[question.id];
            final isCorrect = userAnswer == question.correctOptionID;
            return _buildQuestionResult(theme, question, isCorrect);
          }),
        ],
      ),
    );
  }

  Widget _buildQuestionResult(
    ThemeData theme,
    Question question,
    bool isCorrect,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCorrect
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: isCorrect ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              question.text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
