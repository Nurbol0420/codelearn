import 'package:codelearn/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class SkillsProgressCard extends StatelessWidget {
  final Map<String, double> skillProgress;
  const SkillsProgressCard({super.key, required this.skillProgress});

  @override
  Widget build(BuildContext context) {
    final entries = skillProgress.entries.toList(growable: false);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                size: 20,
                color: Colors.black87,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Skill Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'skills',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ...List.generate(entries.length, (i) {
            final skill = entries[i];
            final percent = (skill.value * 100).toInt();

            return Padding(
              padding: EdgeInsets.only(
                bottom: i == entries.length - 1 ? 0 : 14,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          skill.key,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$percent%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      tween: Tween(begin: 0, end: skill.value),
                      builder: (context, v, _) => LinearProgressIndicator(
                        value: v,
                        minHeight: 10,
                        backgroundColor: Colors.grey.withValues(alpha: 0.15),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                  if (i != entries.length - 1) ...[
                    const SizedBox(height: 12),
                    Container(
                      height: 1,
                      color: Colors.grey.withValues(alpha: 0.08),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
