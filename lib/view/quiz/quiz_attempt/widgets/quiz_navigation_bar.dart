import 'package:codelearn/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class QuizNavigationBar extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback? onPreviousPressed;
  final VoidCallback? onNextPressed;
  final bool isLastPage;
  const QuizNavigationBar({
    super.key,
    required this.theme,
    this.onPreviousPressed,
    this.onNextPressed,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accent,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavigationButton(
            theme,
            Icons.arrow_back_rounded,
            'Previous',
            onPreviousPressed,
            isNext: false,
          ),
          _buildNavigationButton(
            theme,
            Icons.arrow_forward_rounded,
            'Next',
            onNextPressed,
            isNext: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(
    ThemeData theme,
    IconData icon,
    String label,
    VoidCallback? onPressed, {
    bool isNext = false,
  }) {
    final isEnabled = onPressed != null;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: isNext ? AppColors.primary : AppColors.accent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isNext
              ? BorderSide.none
              : const BorderSide(color: AppColors.primary),
        ),
        disabledBackgroundColor: isNext
            ? AppColors.primary.withOpacity(0.5)
            : AppColors.accent.withOpacity(0.5),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          children: [
            if (!isNext)
              Icon(
                icon,
                color: isEnabled
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.5),
                size: 20,
              ),
            if (!isNext) const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: isEnabled
                    ? (isNext ? AppColors.accent : AppColors.primary)
                    : (isNext ? AppColors.accent : AppColors.primary)
                          .withOpacity(0.5),
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isNext) const SizedBox(width: 8),
            if (isNext)
              Icon(
                icon,
                color: isEnabled
                    ? AppColors.accent
                    : AppColors.accent.withOpacity(0.5),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
