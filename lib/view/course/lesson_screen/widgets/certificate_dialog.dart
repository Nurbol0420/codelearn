import 'package:codelearn/models/course.dart';
import 'package:codelearn/view/certificate/certificate_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:codelearn/l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_color.dart';

class CertificateDialog extends StatelessWidget {
  final Course course;
  const CertificateDialog({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.congratulations),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.workspace_premium, size: 64, color: AppColors.primary),
          const SizedBox(height: 16),
          Text('${l10n.courseCompleted} "${course.title}"', textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(l10n.downloadCertDesc, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.secondary)),
        ],
      ),
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                child: Text(l10n.later, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () { Get.back(); Get.to(() => CertificatePreviewScreen(course: course)); },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12), backgroundColor: AppColors.primary),
                child: Text(l10n.viewCertificate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
