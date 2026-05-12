import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/models/question.dart';
import 'package:flutter/material.dart';
import 'package:codelearn/l10n/app_localizations.dart';
class QuestionCard extends StatelessWidget {
  final Question question;
  final int index;
  final VoidCallback onDelete;
  final Function(int correctIndex) onCorrectChanged;

  const QuestionCard({
    super.key,
    required this.question,
    required this.index,
    required this.onDelete,
    required this.onCorrectChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(question.text, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ),
                IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, color: Colors.red)),
              ],
            ),
            const SizedBox(height: 12),
            ...question.options.asMap().entries.map((e) {
              final isCorrect = e.value.id == question.correctOptionID;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isCorrect ? Colors.green.withOpacity(0.1) : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isCorrect ? Colors.green : Colors.grey.shade300, width: isCorrect ? 1.5 : 1),
                ),
                child: Row(
                  children: [
                    Icon(isCorrect ? Icons.check_circle : Icons.circle_outlined, color: isCorrect ? Colors.green : Colors.grey, size: 20),
                    const SizedBox(width: 10),
                    Expanded(child: Text(e.value.text, style: TextStyle(color: isCorrect ? Colors.green.shade700 : null, fontWeight: isCorrect ? FontWeight.w600 : null))),
                    if (isCorrect)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                        child: Text(l10n.correctAnswer, style: const TextStyle(color: Colors.white, fontSize: 11)),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
