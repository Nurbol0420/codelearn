import 'package:codelearn/bloc/course/course_bloc.dart';
import 'package:codelearn/bloc/course/course_state.dart';
import 'package:codelearn/models/course.dart';
import 'package:codelearn/routes/app_routes.dart';
import 'package:codelearn/view/certificate/certificate_preview_screen.dart';
import 'package:codelearn/view/chat/group_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ActionButtons extends StatelessWidget {
  final Course course;
  final bool isUnlocked;

  const ActionButtons({
    super.key,
    required this.course,
    required this.isUnlocked,
  });

  void _goToFirstLesson(BuildContext context) {
    if (course.lessons.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chưa có bài học để bắt đầu.')),
      );
      return;
    }
    final firstLessonId = course.lessons.first.id;
    Get.toNamed(
      AppRoutes.lesson.replaceAll(':id', firstLessonId),
      parameters: {'courseId': course.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseBloc, CourseState>(
      builder: (context, state) {
        if (state is CoursesLoaded && state.isSelectedCourseCompleted == true) {
          return Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => CertificatePreviewScreen(course: course));
                  },
                  label: const Text('View Certificate'),
                  icon: const Icon(Icons.card_membership),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () => Get.to(
                  () => GroupChatScreen(
                    courseId: course.id,
                    courseTitle: course.title,
                  ),
                ),
                icon: const Icon(Icons.chat),
                tooltip: 'Chat',
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (course.isPremium && !isUnlocked) {
                    Get.toNamed(
                      AppRoutes.payment,
                      arguments: {
                        'courseId': course.id,
                        'courseName': course.title,
                        'price': course.price,
                      },
                    );
                  } else {
                    _goToFirstLesson(context);
                  }
                },
                label: const Text('Start Learning'),
                icon: const Icon(Icons.play_circle),
              ),
            ),

            if (!course.isPremium || isUnlocked) ...[
              const SizedBox(width: 16),
              IconButton(
                onPressed: () => Get.to(
                  () => GroupChatScreen(
                    courseId: course.id,
                    courseTitle: course.title,
                  ),
                ),
                icon: const Icon(Icons.chat),
                tooltip: 'Chat',
              ),
            ],
          ],
        );
      },
    );
  }
}
