import 'package:chewie/chewie.dart';
import 'package:codelearn/repositories/course_repository.dart';
import 'package:codelearn/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import '../models/course.dart';

class LessonVideoController {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  bool isLoading = true;
  final String lessonId;
  final Function(bool) onLoadingChanged;
  final Function(Course) onCertificateEarned;
  final CourseRepository _courseRepository;
  final FirebaseAuth _auth;

  LessonVideoController({
    required this.lessonId,
    required this.onLoadingChanged,
    required this.onCertificateEarned,
  }) : _courseRepository = CourseRepository(),
       _auth = FirebaseAuth.instance;

  Future<void> initializeVideo() async {
    try {
      final courseId = Get.parameters['courseId'];

      debugPrint('courseId: $courseId');

      if (courseId == null) {
        debugPrint('No courseId found in parameters');
        onLoadingChanged(false);
        return;
      }

      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('No authenticated user found');
        onLoadingChanged(false);
        return;
      }

      final course = await _courseRepository.getCourseDetail(courseId);
      debugPrint('course: $course');

      final isUnlocked = await _courseRepository.isLessonUnlocked(
        courseId,
        lessonId,
        user.uid,
      );
      final isEnrolled = await _courseRepository.isEnrolled(courseId, user.uid);

      if (!isUnlocked) {
        onLoadingChanged(false);
        Get.back();
        Get.snackbar(
          'Lesson Locked',
          'Please complete previous lessons first',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (course.isPremium && !isEnrolled) {
        onLoadingChanged(false);
        Get.back();
        Get.toNamed(
          AppRoutes.payment,
          arguments: {
            'courseId': courseId,
            'courseName': course.title,
            'price': course.price,
          },
        );
        return;
      }

      if (!course.isPremium &&
          !isEnrolled &&
          course.lessons.first.id == lessonId) {
        await _courseRepository.enrollInCourse(courseId, user.uid);
      }

      final lesson = course.lessons.firstWhere(
        (lesson) => lesson.id == lessonId,
        orElse: () => course.lessons.first,
      );
      videoPlayerController = VideoPlayerController.network(lesson.videoUrl);
      await videoPlayerController?.initialize();
      videoPlayerController?.addListener(
        () => onVideoProgressChanged(courseId),
      );

      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        autoPlay: true,
        looping: false,
        aspectRatio: 16 / 9,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              "Error: Unable to load video content",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.red),
            ),
          );
        },
      );

      onLoadingChanged(false);
    } catch (e) {
      debugPrint('Error initializing video: $e');
      onLoadingChanged(false);
    }
  }

  void onVideoProgressChanged(String courseId) async {
    if (videoPlayerController != null &&
        videoPlayerController!.value.position >=
            videoPlayerController!.value.duration) {
      await markLessonAsCompleted(courseId);
      videoPlayerController?.removeListener(
        () => onVideoProgressChanged(courseId),
      );
    }
  }
  Future<void> markLessonAsCompleted(String courseId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final course = await _courseRepository.getCourseDetail(courseId);
      final lessonIndex = course.lessons.indexWhere((l) => l.id == lessonId);
      if (lessonIndex == -1) return;

      var completedLessons = await _courseRepository.getCompletedLessons(courseId, user.uid);

      if (!completedLessons.contains(lessonId)) {
        await _courseRepository.markLessonAsCompleted(courseId, lessonId, user.uid);
        completedLessons = await _courseRepository.getCompletedLessons(courseId, user.uid);
      }

      if (lessonIndex < course.lessons.length - 1) {
        await _courseRepository.unlockLesson(
          courseId,
          course.lessons[lessonIndex + 1].id,
          user.uid,
        );
      }

      final isLastLesson = lessonIndex == course.lessons.length - 1;
      final allLessonCompleted = completedLessons.length == course.lessons.length;

      if (isLastLesson && allLessonCompleted) {
        onCertificateEarned(course);
      } else {
        Get.back(result: true);
        final progress = await _courseRepository.getCourseProgress(courseId, user.uid);
        Get.snackbar(
          'Lesson Completed',
          'Course Progress: ${progress.toStringAsFixed(1)}%',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      debugPrint('Error marking lesson as completed: $e');
    }
  }


  void dispose() {
    videoPlayerController?.removeListener(
      () => onVideoProgressChanged(Get.parameters['courseId'] ?? ''),
    );
    videoPlayerController?.dispose();
    chewieController?.dispose();
  }
}
