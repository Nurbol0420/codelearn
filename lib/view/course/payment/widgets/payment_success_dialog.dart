import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/view/onboarding/widgets/common/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:codelearn/l10n/app_localizations.dart';

class PaymentSuccessDialog extends StatelessWidget {
  const PaymentSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: AppColors.primary, size: 64),
            const SizedBox(height: 16),
            Text(
              l10n.paymentSuccessful,
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.youCanNowAccessTheCourseContent,
              style: Get.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: CustomButton(text: l10n.startLearning, onPressed: () {
                Get.back();
                Get.back();
                //navigate to course content
              },
                height: 56,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
