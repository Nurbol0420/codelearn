import 'package:codelearn/bloc/filtered_course/filtered_course_bloc.dart';
import 'package:codelearn/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../bloc/filtered_course/filtered_course_event.dart';
import '../../../core/theme/app_color.dart';
import '../../../routes/app_routes.dart';

class CategorySection extends StatelessWidget {
  final List<Category> categories;
  const CategorySection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) =>
                _buildCategoryCard(context, categories[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 16, bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _handleCategoryTap(context, category),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(category.icon, size: 32, color: AppColors.primary),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${category.courseCount} courses',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.secondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleCategoryTap(BuildContext context, Category category) {
    Get.toNamed(
      AppRoutes.courseList,
      arguments: {'category': category.id, 'categoryName': category.name},
      parameters: {'category': category.id, 'categoryName': category.name},
    );
    context.
    read<FilteredCourseBloc>().
    add(FilterCoursesByCategory(category.id),
    );
  }
}
