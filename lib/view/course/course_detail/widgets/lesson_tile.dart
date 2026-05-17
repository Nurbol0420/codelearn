import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class LessonTile extends StatelessWidget {
  final String title;
  final String duration;
  final bool isCompleted;
  final bool isLocked;
  final bool isUnlocked;
  final bool isPreview;
  final int lessonNumber;
  final VoidCallback onTap;

  const LessonTile({
    super.key,
    required this.title,
    required this.duration,
    required this.isCompleted,
    required this.isLocked,
    required this.isUnlocked,
    required this.onTap,
    this.isPreview = false,
    this.lessonNumber = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool canAccess = isUnlocked || isPreview;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted
              ? Colors.green
              : (!canAccess && isLocked)
                  ? Colors.grey[200]
                  : AppColors.primary.withOpacity(0.1),
        ),
        child: Center(
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 16)
              : (!canAccess && isLocked)
                  ? const Icon(Icons.lock, color: AppColors.secondary, size: 14)
                  : Text(
                      '$lessonNumber',
                      style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: (!canAccess && isLocked) ? AppColors.secondary : null,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Row(
        children: [
          const Icon(Icons.access_time, size: 12, color: AppColors.secondary),
          const SizedBox(width: 3),
          Text(duration, style: const TextStyle(fontSize: 12, color: AppColors.secondary)),
          if (isPreview) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.blue.withOpacity(0.4)),
              ),
              child: const Text('Бесплатно', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
      trailing: Icon(
        isCompleted ? Icons.check_circle : Icons.play_circle_outline,
        color: isCompleted ? Colors.green : AppColors.primary,
        size: 22,
      ),
    );
  }
}