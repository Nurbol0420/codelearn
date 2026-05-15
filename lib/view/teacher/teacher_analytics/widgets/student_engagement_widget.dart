import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/models/course.dart';
import 'package:codelearn/repositories/course_repository.dart';
import 'package:flutter/material.dart';

class StudentEngagementWidget extends StatelessWidget {
  final String instructorID;
  StudentEngagementWidget({super.key, required this.instructorID});

  final CourseRepository _courseRepository = CourseRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Student Engagement',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          FutureBuilder<List<Course>>(
            future: _courseRepository.getInstructorCourses(instructorID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final courses = snapshot.data ?? [];
              final totalStudents = courses.fold<int>(
                0,
                (sum, course) => sum + course.enrollmentCount,
              );
              final totalLessons = courses.fold<int>(
                0,
                (sum, course) => sum + course.lessons.length,
              );
              final premiumCourses = courses
                  .where((course) => course.isPremium)
                  .length;

              return Column(
                children: [
                  _buildEngagementMetric(
                    'Enrolled Students',
                    totalStudents.toString(),
                    Icons.people,
                  ),
                  Divider(height: 32, color: Colors.grey.shade300),
                  _buildEngagementMetric(
                    'Published Lessons',
                    totalLessons.toString(),
                    Icons.school,
                  ),
                  Divider(height: 32, color: Colors.grey.shade300),
                  _buildEngagementMetric(
                    'Premium Courses',
                    premiumCourses.toString(),
                    Icons.workspace_premium,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementMetric(String title, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ],
    );
  }
}
