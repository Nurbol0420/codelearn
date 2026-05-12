import 'package:flutter/material.dart';
import 'package:codelearn/l10n/app_localizations.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../models/course.dart';

class CourseInfoCard extends StatelessWidget {
  final Course course;
  const CourseInfoCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _buildInfoItem(context, Icons.people, '${course.enrollmentCount}+', l10n.students),
              _buildInfoItem(context, Icons.star, course.rating.toString(), '${course.reviewCount} ${l10n.reviews}'),
              _buildInfoItem(context, Icons.library_books, '${course.lessons.length}', l10n.lessons),
              _buildInfoItem(context, Icons.signal_cellular_alt, course.level, l10n.level),
            ]),
            const SizedBox(height: 16),
            if (course.requirements.isNotEmpty) ...[
              _buildSectionTitle(context, l10n.requirements),
              const SizedBox(height: 8),
              ...course.requirements.map((r) => _buildRequirementItem(context, r)),
              const SizedBox(height: 16),
            ],
            if (course.whatYouWillLearn.isNotEmpty) ...[
              _buildSectionTitle(context, l10n.whatYouLearn),
              const SizedBox(height: 8),
              ...course.whatYouWillLearn.map((item) => _buildLearningItem(context, item)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String value, String label) {
    final theme = Theme.of(context);
    return Column(children: [
      Icon(icon, color: AppColors.primary),
      const SizedBox(height: 4),
      Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
      Text(label, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.secondary)),
    ]);
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Align(alignment: Alignment.centerLeft, child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)));
  }

  Widget _buildRequirementItem(BuildContext context, String requirement) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('- ', style: TextStyle(color: AppColors.primary)),
        Expanded(child: Text(requirement, style: Theme.of(context).textTheme.bodyMedium)),
      ]),
    );
  }

  Widget _buildLearningItem(BuildContext context, String item) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.check_circle, color: AppColors.primary, size: 16),
        const SizedBox(width: 8),
        Expanded(child: Text(item, style: Theme.of(context).textTheme.bodyMedium)),
      ]),
    );
  }
}
