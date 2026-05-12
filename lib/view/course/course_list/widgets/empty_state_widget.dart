import 'package:flutter/material.dart';
import 'package:codelearn/l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_color.dart';

class EmptyStateWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onActionPressed;
  final String? actionLabel;
  final IconData icon;

  const EmptyStateWidget({
    super.key,
    this.title,
    this.message,
    this.onActionPressed,
    this.actionLabel,
    this.icon = Icons.school_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: AppColors.primary.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(title ?? l10n.noCoursesFound, style: theme.textTheme.titleSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(message ?? l10n.noCoursesCategory, style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.secondary), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onActionPressed ?? () => Get.back(),
            label: Text(actionLabel ?? l10n.goBack),
            icon: const Icon(Icons.arrow_back),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
          ),
        ],
      ),
    );
  }
}
