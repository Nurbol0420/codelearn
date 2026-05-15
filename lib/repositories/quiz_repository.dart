import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codelearn/repositories/course_repository.dart';
import 'package:codelearn/models/quiz.dart';
import 'package:codelearn/models/quiz_attempt.dart';

class QuizRepository {
  final _firestore = FirebaseFirestore.instance;
  final _courseRepository = CourseRepository();

  // ─── Quiz CRUD ────────────────────────────────────────────────────────────

  Future<void> createQuiz(Quiz quiz) async {
    try {
      await _firestore.collection('quizzes').doc(quiz.id).set(quiz.toJson());
    } catch (e) {
      throw Exception('Викторинаны жасау мүмкін болмады: $e');
    }
  }

  Future<void> updateQuiz(Quiz quiz) async {
    try {
      await _firestore.collection('quizzes').doc(quiz.id).update(quiz.toJson());
    } catch (e) {
      throw Exception('Викторинаны жаңарту мүмкін болмады: $e');
    }
  }

  Future<void> deleteQuiz(String quizId) async {
    try {
      await _firestore.collection('quizzes').doc(quizId).delete();
    } catch (e) {
      throw Exception('Викторинаны жою мүмкін болмады: $e');
    }
  }

  Future<List<Quiz>> getQuizzes() async {
    try {
      final snapshot = await _firestore.collection('quizzes').get();
      final quizzes = snapshot.docs.map((doc) {
        return Quiz.fromJson({...doc.data(), 'id': doc.id});
      }).toList();
      quizzes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return quizzes;
    } catch (e) {
      throw Exception('Викториналарды алу мүмкін болмады: $e');
    }
  }

  Future<List<Quiz>> getQuizzesByInstructor(String instructorId) async {
    final quizzes = await getQuizzes();
    return quizzes.where((quiz) => quiz.instructorId == instructorId).toList();
  }

  Future<List<Quiz>> getQuizzesForStudent(String studentId) async {
    final enrolledCourseIds = await _courseRepository.getEnrolledCourseIds(
      studentId,
    );
    if (enrolledCourseIds.isEmpty) return [];

    final quizzes = await getQuizzes();
    return quizzes
        .where(
          (quiz) =>
              quiz.isActive &&
              quiz.courseId.isNotEmpty &&
              enrolledCourseIds.contains(quiz.courseId),
        )
        .toList();
  }

  // ─── Quiz Attempts ────────────────────────────────────────────────────────

  /// Student saves attempt after finishing quiz
  Future<void> saveAttempt(QuizAttempt attempt) async {
    try {
      await _firestore
          .collection('quiz_attempts')
          .doc(attempt.id)
          .set(attempt.toJson());
    } catch (e) {
      throw Exception('Викторинаны жасау мүмкін болмады: $e');
    }
  }

  /// Student: get all MY attempts
  Future<List<QuizAttempt>> getMyAttempts(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('quiz_attempts')
          .where('userId', isEqualTo: userId)
          .get();
      final attempts = snapshot.docs.map((doc) {
        return QuizAttempt.fromJson({...doc.data(), 'id': doc.id});
      }).toList();
      attempts.sort(_compareAttemptsByCompletedAtDesc);
      return attempts;
    } catch (e) {
      throw Exception('Викторинаны жасау мүмкін болмады: $e');
    }
  }

  /// Teacher: get all attempts for a specific quiz
  Future<List<QuizAttempt>> getAttemptsByQuiz(String quizId) async {
    try {
      final snapshot = await _firestore
          .collection('quiz_attempts')
          .where('quizId', isEqualTo: quizId)
          .get();
      final attempts = snapshot.docs.map((doc) {
        return QuizAttempt.fromJson({...doc.data(), 'id': doc.id});
      }).toList();
      attempts.sort(_compareAttemptsByCompletedAtDesc);
      return attempts;
    } catch (e) {
      throw Exception('Викторинаны жасау мүмкін болмады: $e');
    }
  }

  int _compareAttemptsByCompletedAtDesc(QuizAttempt a, QuizAttempt b) {
    final aDate = a.completedAt ?? a.startedAt;
    final bDate = b.completedAt ?? b.startedAt;
    return bDate.compareTo(aDate);
  }
}
