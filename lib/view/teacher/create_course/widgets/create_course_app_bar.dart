import 'package:codelearn/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/course.dart';

class CreateCourseAppBar extends StatelessWidget {
  final VoidCallback onSubmit;
  final Course? course;

  const CreateCourseAppBar({super.key, required this.onSubmit, this.course});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      collapsedHeight: kToolbarHeight,
      toolbarHeight: kToolbarHeight,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back, color: AppColors.accent),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Center(
            child: ElevatedButton.icon(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.primary,
                elevation: 5,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: Icon(
                course != null ? Icons.update_outlined : Icons.add_circle_outline,
                size: 20,
              ),
              label: Text(
                course != null ? 'Update' : 'Create',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.15,
          bottom: 16,
        ),
        title: Text(
          course != null ? 'Edit Course' : 'Create Course',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }
}