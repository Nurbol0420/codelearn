import 'package:codelearn/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class QuizOptionTile extends StatelessWidget {
  final String optionId;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final String? selectedOptionId;
  const QuizOptionTile({
    super.key,
    required this.optionId,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.selectedOptionId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withOpacity(0.1)
            : AppColors.accent,
        borderRadius: BorderRadius.circular(16),
        border: isSelected
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      optionId,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Radio<String>(
                  value: optionId,
                  groupValue: selectedOptionId,
                  onChanged: (value) => onTap(),
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
