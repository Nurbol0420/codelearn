import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/models/question.dart';
import 'package:codelearn/services/quiz_parser_service.dart';
import 'package:flutter/material.dart';
import 'package:codelearn/l10n/app_localizations.dart';
class ParsedQuestionsPreview extends StatelessWidget {
  final List<ParsedQuestion> parsed;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ParsedQuestionsPreview({
    super.key,
    required this.parsed,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(Icons.checklist, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(l10n.parsedQuestionsTitle, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                  child: Text('${parsed.length} ${l10n.questionsCount}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: parsed.length,
              itemBuilder: (context, i) {
                final q = parsed[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          CircleAvatar(radius: 12, backgroundColor: AppColors.primary, child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontSize: 11))),
                          const SizedBox(width: 10),
                          Expanded(child: Text(q.text, style: const TextStyle(fontWeight: FontWeight.w600))),
                        ]),
                        const SizedBox(height: 8),
                        ...q.options.asMap().entries.map((e) {
                          final isCorrect = e.key == 0;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(children: [
                              Icon(isCorrect ? Icons.check_circle : Icons.radio_button_unchecked,
                                color: isCorrect ? Colors.green : Colors.grey.shade400, size: 16),
                              const SizedBox(width: 8),
                              Expanded(child: Text(e.value, style: TextStyle(color: isCorrect ? Colors.green.shade700 : null, fontWeight: isCorrect ? FontWeight.w600 : null))),
                            ]),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Expanded(child: OutlinedButton(onPressed: onCancel, child: Text(l10n.cancel))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton.icon(
                onPressed: onConfirm,
                icon: const Icon(Icons.add_task),
                label: Text(l10n.addToQuiz),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              )),
            ]),
          ),
        ],
      ),
    );
  }
}
