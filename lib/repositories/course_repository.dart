import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codelearn/models/course.dart';

class CourseRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Course>> getCourse({String? categoryID}) async {
    try {
      Query query = _firestore.collection('courses');

      if (categoryID != null) {
        query = query.where('categoryID', isEqualTo: categoryID);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) {
          throw Exception('Course data is null');
        }
        return Course.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch courses: $e');
    }
  }

  Future<Course> getCourseDetail(String courseId) async {
    try {
      final doc = await _firestore.collection('courses').doc(courseId).get();
      if (!doc.exists) {
        throw Exception('Course not found');
      }
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Course data is null');
      }
      return Course.fromJson({...data, 'id': doc.id});
    } catch (e) {
      throw Exception('Failed to get course detail: $e');
    }
  }

  Future<void> createCourse(Course course) async {
    try {
      // convert course to JSON
      final courseData = course.toJson();

      // convert lesson to JSON
      final lessonsData = course.lessons.map((lesson) => lesson.toJson());

      // create course document
      await _firestore.collection('courses').doc(course.id).set({
        ...courseData,
        'lessons': lessonsData,
      });
    } catch (e) {
      throw Exception('Failed to create course: $e');
    }
  }

  Future<List<Course>> getInstructorCourses(String instructorID) async {
    try {
      final snapshot = await _firestore
          .collection('courses')
          .where('instructorID', isEqualTo: instructorID)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) {
          throw Exception('Course data is null');
        }
        return Course.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch instructor courses: $e');
    }
  }

  Future<void> updateCourse(Course course) async {
    try {
      // convert course to JSON
      final courseData = course.toJson();

      // convert lesson to JSON
      final lessonsData = course.lessons
          .map((lesson) => lesson.toJson())
          .toList();

      // update course document
      await _firestore.collection('courses').doc(course.id).update({
        ...courseData,
        'lessons': lessonsData,
      });
    } catch (e) {
      throw Exception('Failed to update course: $e');
    }
  }

  // delete course
  Future<void> deleteCourse(String courseId) async {
    try {
      // delete the course document
      await _firestore.collection('courses').doc(courseId).delete();

      // delete all enrollments for this course
      final enrollmentsSnapshot = await _firestore
          .collection('enrollments')
          .where('courseId', isEqualTo: courseId)
          .get();

      for (var doc in enrollmentsSnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete course: $e');
    }
  }

  Future<Set<String>> getCompletedLessons(
    String courseId,
    String studentId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('lesson_student_progress')
          .where('courseId', isEqualTo: courseId)
          .where('studentId', isEqualTo: studentId)
          .where('isCompleted', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => doc.data()['lessonId'] as String)
          .toSet();
    } catch (e) {
      throw Exception('Failed to get completed lessons: $e');
    }
  }

  Future<void> updateCourseProgress(String courseId, String studentId) async {
    try {
      final course = await getCourseDetail(courseId);
      final totalLessons = course.lessons.length;

      final completedLessons = await getCompletedLessons(courseId, studentId);

      final progress = (completedLessons.length / totalLessons) * 100;

      final enrollmentSnapshot = await _firestore
          .collection('enrollments')
          .where('courseId', isEqualTo: courseId)
          .where('studentId', isEqualTo: studentId)
          .get();

      if (enrollmentSnapshot.docs.isNotEmpty) {
        await _firestore
            .collection('enrollments')
            .doc(enrollmentSnapshot.docs.first.id)
            .update({
              'progress': progress,
              'updatedAt': FieldValue.serverTimestamp(),
            });
      }
    } catch (e) {
      throw Exception('Failed to update course progress: $e');
    }
  }

  Future<void> enrollCourse(String userId, String courseId) async {
    try {
      await _firestore.collection('enrollments').add({
        'userID': userId,
        'courseID': courseId,
        'enrolledAt': FieldValue.serverTimestamp(),
        'progress': 0,
      });
    } catch (e) {
      throw Exception('Failed to enroll in course: $e');
    }
  }

  Future<double> getCourseProgress(String courseId, String studentId) async {
    try {
      final enrollmentSnapshot = await _firestore
          .collection('enrollments')
          .where('courseId', isEqualTo: courseId)
          .where('studentId', isEqualTo: studentId)
          .get();

      if (enrollmentSnapshot.docs.isNotEmpty) return 0.0;
      return (enrollmentSnapshot.docs.first.data()['progress'] as num)
          .toDouble();
    } catch (e) {
      throw Exception('Failed to get course progress: $e');
    }
  }

  Future<void> markLessonAsCompleted(
    String courseId,
    String lessonId,
    String studentId,
  ) async {
    try {
      final existingProgress = await _firestore
          .collection('lesson_student_progress')
          .where('courseId', isEqualTo: courseId)
          .where('lessonId', isEqualTo: lessonId)
          .where('studentId', isEqualTo: studentId)
          .get();

      if (existingProgress.docs.isEmpty) {
        await _firestore.collection('lesson_student_progress').add({
          'courseId': courseId,
          'lessonId': lessonId,
          'studentId': studentId,
          'isCompleted': true,
          'isLocked': false,
          'completedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await _firestore
            .collection('lesson_student_progress')
            .doc(existingProgress.docs.first.id)
            .update({
              'isCompleted': true,
              'completedAt': FieldValue.serverTimestamp(),
            });
      }

      await updateCourseProgress(courseId, studentId);
    } catch (e) {
      throw Exception('Failed to mark lesson as completed: $e');
    }
  }

  Future<void> unlockLesson(
    String courseId,
    String lessonId,
    String studentId,
  ) async {
    try {
      final existingProgress = await _firestore
          .collection('lesson_student_progress')
          .where('courseId', isEqualTo: courseId)
          .where('lessonId', isEqualTo: lessonId)
          .where('studentId', isEqualTo: studentId)
          .get();

      if (existingProgress.docs.isEmpty) {
        await _firestore.collection('lesson_student_progress').add({
          'courseId': courseId,
          'lessonId': lessonId,
          'studentId': studentId,
          'isCompleted': false,
          'isLocked': false,
          'unlockedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await _firestore
            .collection('lesson_student_progress')
            .doc(existingProgress.docs.first.id)
            .update({
              'isLocked': false,
              'unlockedAt': FieldValue.serverTimestamp(),
            });
      }
    } catch (e) {
      throw Exception('Failed to unlock lesson: $e');
    }
  }

  Future<bool> isLessonUnlocked(
    String courseId,
    String lessonId,
    String studentId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('lesson_student_progress')
          .where('courseId', isEqualTo: courseId)
          .where('lessonId', isEqualTo: lessonId)
          .where('studentId', isEqualTo: studentId)
          .get();

      if (snapshot.docs.isEmpty) {
        final course = await getCourseDetail(courseId);
        return course.lessons.first.id == lessonId;
      }
      return !snapshot.docs.first.data()['isLocked'];
    } catch (e) {
      throw Exception('Failed to check if lesson is unlocked: $e');
    }
  }

  Future<void> enrollInCourse(
    String courseId,
    String studentId, {
    bool isPremium = false,
  }) async {
    try {
      final existingEnrollment = await _firestore
          .collection('enrollments')
          .where('courseId', isEqualTo: courseId)
          .where('studentId', isEqualTo: studentId)
          .get();

      if (existingEnrollment.docs.isEmpty) {
        await _firestore.collection('enrollments').add({
          'courseId': courseId,
          'studentId': studentId,
          'enrolledAt': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
          'isPremium': isPremium,
          'progress': 0,
        });
        final course = await getCourseDetail(courseId);
        if (course.lessons.isNotEmpty) {
          await unlockLesson(courseId, course.lessons.first.id, studentId);
        }
      }
    } catch (e) {
      throw Exception('Failed to enroll in course: $e');
    }
  }

  Future<bool> isEnrolled(String courseId, String studentId) async {
    try {
      final snapshot = await _firestore
          .collection('enrollments')
          .where('courseId', isEqualTo: courseId)
          .where('studentId', isEqualTo: studentId)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check enrollment status: $e');
    }
  }

  Future<bool> isCourseCompleted(String courseId, String studentId) async {
    try {
      final course = await getCourseDetail(courseId);
      final totalLessons = course.lessons.length;

      final completedLessons = await getCompletedLessons(courseId, studentId);

      return completedLessons.length == totalLessons;
    }catch (e) {
      throw Exception('Failed to check course completion status: $e');
    }
  }
}
