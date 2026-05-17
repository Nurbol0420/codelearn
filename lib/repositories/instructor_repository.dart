import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codelearn/models/user_model.dart';

class InstructorRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getInstructorById(String instructorID) async {
    try {
      // Read main user doc first to get role
      final userDoc = await _firestore.collection('users').doc(instructorID).get();
      if (!userDoc.exists) return null;

      final userModel = UserModel.fromFirestore(userDoc);
      final roleCol = userModel.role == UserRole.teacher ? 'teachers' : 'students';

      // Try subcollection for detailed/role data
      final subDoc = await _firestore
          .collection('users')
          .doc(instructorID)
          .collection(roleCol)
          .doc(instructorID)
          .get();

      if (subDoc.exists) return UserModel.fromFirestore(subDoc);
      return userModel; // fallback to main doc
    } catch (e) {
      throw Exception('Failed to get instructor: $e');
    }
  }

  Future<Map<String, UserModel>> getInstructorsByIds(List<String> instructorIds) async {
    try {
      if (instructorIds.isEmpty) return {};
      final result = <String, UserModel>{};
      for (final id in instructorIds) {
        final user = await getInstructorById(id);
        if (user != null) result[id] = user;
      }
      return result;
    } catch (e) {
      throw Exception('Failed to get instructors: $e');
    }
  }

  /// Get all teachers from subcollections
  Future<List<UserModel>> getAllTeachers() async {
    try {
      final usersSnap = await _firestore.collection('users').get();
      final List<UserModel> teachers = [];
      for (final userDoc in usersSnap.docs) {
        final subSnap = await userDoc.reference.collection('teachers').get();
        for (final sub in subSnap.docs) {
          teachers.add(UserModel.fromFirestore(sub));
        }
      }
      return teachers;
    } catch (e) {
      throw Exception('Failed to get teachers: $e');
    }
  }

  /// Get all students from subcollections
  Future<List<UserModel>> getAllStudents() async {
    try {
      final usersSnap = await _firestore.collection('users').get();
      final List<UserModel> students = [];
      for (final userDoc in usersSnap.docs) {
        final subSnap = await userDoc.reference.collection('students').get();
        for (final sub in subSnap.docs) {
          students.add(UserModel.fromFirestore(sub));
        }
      }
      return students;
    } catch (e) {
      throw Exception('Failed to get students: $e');
    }
  }
}


}