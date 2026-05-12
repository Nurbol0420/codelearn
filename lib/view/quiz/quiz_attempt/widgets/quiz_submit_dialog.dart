import 'package:codelearn/models/quiz.dart';
import 'package:flutter/material.dart';
import 'package:codelearn/l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../../../models/quiz_attempt.dart';
import '../../quiz_result/quiz_result_screen.dart';

class QuizSubmitDialog extends StatelessWidget {
  final QuizAttempt attempt;
  final Quiz quiz;
  const QuizSubmitDialog({super.key, required this.attempt, required this.quiz});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.submitQuiz),
      content: Text(l10n.submitQuizConfirm),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            Get.off(() => QuizResultScreen(attempt: attempt, quiz: quiz));
          },
          child: Text(l10n.submit),
        ),
      ],
    );
  }
}
