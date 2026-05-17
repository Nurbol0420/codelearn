import 'package:codelearn/models/course.dart';
import 'package:codelearn/models/course_section.dart';
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
  // Track which sections are expanded
  final Map<String, bool> _sectionExpanded = {};

  @override
  void initState() {
    super.initState();
    _loadCourse();
  }

  @override
  void didUpdateWidget(LessonList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.courseId != widget.courseId || oldWidget.isUnlocked != widget.isUnlocked) {
      _loadCourse();
    }
  }

  Future<void> _loadCourse() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final user = _auth.currentUser;
      if (user == null) {
        if (mounted) setState(() => _isLoading = false);
        Get.snackbar('Error', 'User not authenticated', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
        return;
      }
      final course = await _courseRepository.getCourseDetail(widget.courseId);
      final completedLessons = await _courseRepository.getCompletedLessons(widget.courseId, user.uid);
      if (mounted) {
        setState(() {
          _course = course;
          _completedLessons = completedLessons;
          _isLoading = false;
          // Initialize all sections as expanded by default
          for (final s in course.sections) {
            _sectionExpanded.putIfAbsent(s.id, () => true);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        Get.snackbar('Error', 'Failed to load course: $e', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_course == null) return const Center(child: Text('Нет уроков'));

    final course = _course!;

    // If course has sections, render grouped; otherwise flat list
    if (course.sections.isNotEmpty) {
      return _buildSectionedList(course);
    } else {
      return _buildFlatList(course);
    }
  }

  // ─── Udemy-style grouped by section ───────────────────────────────────────

  Widget _buildSectionedList(Course course) {
    final sortedSections = List<CourseSection>.from(course.sections)
      ..sort((a, b) => a.order.compareTo(b.order));

    int globalLessonIndex = 0;

    return Column(
      children: sortedSections.map((section) {
        final sectionLessons = course.lessons
            .where((l) => l.sectionId == section.id)
            .toList();

        final startIndex = globalLessonIndex;
        globalLessonIndex += sectionLessons.length;

        final isExpanded = _sectionExpanded[section.id] ?? true;
        final completedInSection = sectionLessons.where((l) => _completedLessons.contains(l.id)).length;
        final totalDuration = sectionLessons.fold(0, (sum, l) => sum + l.duration);

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.lightDivider),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              // Section header
              InkWell(
                onTap: () => setState(() => _sectionExpanded[section.id] = !isExpanded),
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(10),
                  bottom: isExpanded ? Radius.zero : const Radius.circular(10),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.lightSurface,
                    borderRadius: BorderRadius.vertical(
                      top: const Radius.circular(10),
                      bottom: isExpanded ? Radius.zero : const Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          section.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
                        ),
                      ),
                      Text(
                        '$completedInSection/${sectionLessons.length} • ${totalDuration} мин',
                        style: const TextStyle(color: AppColors.secondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),

              // Lessons
              if (isExpanded)
                ...sectionLessons.asMap().entries.map((entry) {
                  final localIdx = entry.key;
                  final lesson = entry.value;
                  final globalIdx = startIndex + localIdx;

                  final isCompleted = _completedLessons.contains(lesson.id);
                  final isLocked = !lesson.isPreview &&
                      globalIdx > 0 &&
                      !_completedLessons.contains(course.lessons[globalIdx - 1].id);

                  return Column(
                    children: [
                      if (localIdx > 0) const Divider(height: 1, indent: 56),
                      LessonTile(
                        title: lesson.title,
                        duration: '${lesson.duration} мин',
                        isCompleted: isCompleted,
                        isLocked: isLocked,
                        isUnlocked: widget.isUnlocked,
                        isPreview: lesson.isPreview,
                        lessonNumber: globalIdx + 1,
                        onTap: () => _onLessonTap(course, lesson, isLocked),
                      ),
                    ],
                  );
                }),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ─── Flat list (legacy — no sections) ──────────────────────────────────────

  Widget _buildFlatList(Course course) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: course.lessons.length,
      itemBuilder: (context, index) {
        final lesson = course.lessons[index];
        final isCompleted = _completedLessons.contains(lesson.id);
        final isLocked = !lesson.isPreview &&
            index > 0 &&
            !_completedLessons.contains(course.lessons[index - 1].id);

        return LessonTile(
          title: lesson.title,
          duration: '${lesson.duration} мин',
          isCompleted: isCompleted,
          isLocked: isLocked,
          isUnlocked: widget.isUnlocked,
          isPreview: lesson.isPreview,
          lessonNumber: index + 1,
          onTap: () => _onLessonTap(course, lesson, isLocked),
        );
      },
    );
  }

  // ─── Tap handler ───────────────────────────────────────────────────────────

  Future<void> _onLessonTap(Course course, lesson, bool isLocked) async {
    if (course.isPremium && !widget.isUnlocked) {
      Get.snackbar('Premium Course', 'Please purchase this course to access all lessons',
          backgroundColor: AppColors.primary, colorText: Colors.white, duration: const Duration(seconds: 3));
    } else if (isLocked) {
      Get.snackbar('Lesson Locked', 'Please complete the previous lesson first',
          backgroundColor: Colors.red, colorText: Colors.white, duration: const Duration(seconds: 3));
    } else {
      final result = await Get.toNamed(
        AppRoutes.lesson.replaceAll(':id', lesson.id),
        parameters: {'courseId': widget.courseId},
      );
      if (result == true) {
        await _loadCourse();
        widget.onLessonComplete?.call();
      }
    }
  }
}


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