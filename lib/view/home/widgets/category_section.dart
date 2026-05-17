import 'package:codelearn/bloc/filtered_course/filtered_course_bloc.dart';
import 'package:codelearn/bloc/filtered_course/filtered_course_event.dart';
import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/models/category.dart';
import 'package:codelearn/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CategorySection extends StatelessWidget {
  final List<Category> categories;
  const CategorySection({super.key, required this.categories});

  static const Map<String, String> _logoUrls = {
    'python':     'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/python/python-original.svg',
    'javascript': 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/javascript/javascript-original.svg',
    'flutter':    'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flutter/flutter-original.svg',
    'dart':       'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/dart/dart-original.svg',
    'java':       'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/java/java-original.svg',
    'c++':        'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/cplusplus/cplusplus-original.svg',
    'kotlin':     'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/kotlin/kotlin-original.svg',
    'swift':      'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/swift/swift-original.svg',
    'typescript': 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/typescript/typescript-original.svg',
    'react':      'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/react/react-original.svg',
    'go':         'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/go/go-original.svg',
    'php':        'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/php/php-original.svg',
    'ruby':       'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/ruby/ruby-original.svg',
    'html':       'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/html5/html5-original.svg',
    'css':        'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/css3/css3-original.svg',
  };

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
                _buildCard(context, categories[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, Category category) {
    final logoUrl = _logoUrls[category.name.toLowerCase()];
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 16, bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Get.toNamed(
              AppRoutes.courseList,
              arguments: {'category': category.id, 'categoryName': category.name},
              parameters: {'category': category.id, 'categoryName': category.name},
            );
            context.read<FilteredCourseBloc>().add(FilterCoursesByCategory(category.id));
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: logoUrl != null
                      ? SvgPicture.network(
                          logoUrl,
                          width: 44,
                          height: 44,
                          placeholderBuilder: (_) => const SizedBox(
                            width: 44,
                            height: 44,
                            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              category.name.length >= 2
                                  ? category.name.substring(0, 2).toUpperCase()
                                  : category.name.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${category.courseCount} courses',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.secondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}