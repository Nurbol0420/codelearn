import 'package:codelearn/models/course.dart';
import 'package:codelearn/repositories/course_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../routes/app_routes.dart';
import 'lesson_tile.dart';

class LessonList extends StatefulWidget {
  final String courseId;
  final bool isUnlocked;
  final VoidCallback? onLessonComplete;

  const LessonList({
    super.key,
    required this.courseId,
    required this.isUnlocked,
    this.onLessonComplete,
  });

  @override
  State<LessonList> createState() => _LessonListState();
}

class _LessonListState extends State<LessonList> {
  final CourseRepository _courseRepository = CourseRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Course? _course;
  bool _isLoading = true;
  Set<String> _completedLessons = {};

  @override
  void initState() {
    super.initState();
    _loadCourse();
  }

  @override
  void didUpdateWidget(LessonList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.courseId != widget.courseId ||
        oldWidget.isUnlocked != widget.isUnlocked) {
      _loadCourse();
    }
  }

  Future<void> _loadCourse() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        Get.snackbar(
          'Error',
          'User not authenticated',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }

      final course = await _courseRepository.getCourseDetail(widget.courseId);
      final completedLessons = await _courseRepository.getCompletedLessons(
        widget.courseId,
        user.uid,
      );

      if (mounted) {
        setState(() {
          _course = course;
          _completedLessons = completedLessons;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Get.snackbar(
          'Error',
          'Failed to load course lessons: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_course == null) {
      return const Center(child: Text('No Lessons Available'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _course!.lessons.length,
      itemBuilder: (context, index) {
        final lesson = _course!.lessons[index];
        final isCompleted = _completedLessons.contains(lesson.id);
        final isLocked =
            !lesson.isPreview &&
                (index > 0 &&
                    !_completedLessons.contains(_course!.lessons[index - 1].id));
        return LessonTile(
          title: lesson.title,
          duration: '${lesson.duration} min',
          isCompleted: isCompleted,
          isLocked: isLocked,
          isUnlocked: widget.isUnlocked,
          onTap: () async {
            if (_course!.isPremium && !widget.isUnlocked) {
              Get.snackbar(
                'Premium Course',
                'Please purchase this course to access all lessons',
                backgroundColor: AppColors.primary,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );
            } else if (isLocked) {
              Get.snackbar(
                'Lesson Locked',
                'Please complete the previous lesson first',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );
            } else {
              //navigate to lesson screen
              final result = await Get.toNamed(
                AppRoutes.lesson.replaceAll(':id', lesson.id),
                parameters: {'courseId': widget.courseId},
              );
              if (result == true) {
                await _loadCourse(); // ✅ FIXED: Gọi _loadCourse() thay vì LoadCourses()
                widget.onLessonComplete?.call();
              }
            }
          },
        );
      },
    );
  }
}