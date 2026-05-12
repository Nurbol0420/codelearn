import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codelearn/models/category.dart';
import 'package:flutter/cupertino.dart';

class CategoryRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Category>> getCategories() async {
    try {
      //first get all categories
      final categoriesSnapshot = await _firestore
          .collection('categories')
          .get();

      //get all courses to count by category
      final coursesSnapshot = await _firestore.collection('courses').get();

      //create a map to store courses count by category
      final Map<String, int> courseCounts = {};

      //count courses by category
      for (var course in coursesSnapshot.docs) {
        final categoryId = course.data()['categoryID'] as String?;
        if (categoryId != null) {
          courseCounts[categoryId] = (courseCounts[categoryId] ?? 0) + 1;
        }
      }
      //create category objects with calculated
      return categoriesSnapshot.docs.map((doc) {
        final data = doc.data();
        return Category(
          id: doc.id,
          name: data['name'] as String,
          icon: IconData(
            int.parse(data['icon'] as String),
            fontFamily: 'MaterialIcons',
          ),
          courseCount: courseCounts[doc.id] ?? 0,
        );
      }).toList();
    } catch (e) {
      throw Exception('Error getting categories: $e');
    }
  }
}
