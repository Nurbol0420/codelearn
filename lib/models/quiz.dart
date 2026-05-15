import 'package:codelearn/models/question.dart';

class Quiz {
  final String id;
  final String title;
  final String description;
  final String courseId;
  final String courseTitle;
  final String instructorId;
  final int timeLimit;
  final List<Question> questions;
  final DateTime createdAt;
  final bool isActive;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    this.courseId = '',
    this.courseTitle = '',
    this.instructorId = '',
    required this.timeLimit,
    required this.questions,
    required this.createdAt,
    this.isActive = true,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    final questionsJson = json['questions'] ?? json['question'] ?? [];
    final createdAtJson = json['createdAt'] ?? json['createAt'];

    return Quiz(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      courseId: json['courseId'] ?? '',
      courseTitle: json['courseTitle'] ?? '',
      instructorId: json['instructorId'] ?? '',
      timeLimit: json['timeLimit'] ?? 30,
      questions: (questionsJson as List<dynamic>)
          .map((q) => Question.fromMap(Map<String, dynamic>.from(q)))
          .toList(),
      createdAt: createdAtJson != null
          ? DateTime.parse(createdAtJson)
          : DateTime.now(),
      isActive: json['isActive'] ?? true,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'instructorId': instructorId,
      'timeLimit': timeLimit,
      'questions': questions.map((q) => q.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }
}
