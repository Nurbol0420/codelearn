import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/models/chat_message.dart';
import 'package:codelearn/services/dummy_data_service.dart';
import 'package:codelearn/view/chat/widgets/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: AppColors.accent),
        ),
        title: const Text(
          'Student Messages',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<List<ChatMessage>>(
        stream: DummyDataService.getTeacherChats('inst_1'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final chatsByCourse = DummyDataService.getTeacherChatsByCourse(
            'inst_1',
          );

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: chatsByCourse.length,
            itemBuilder: (context, index) {
              final courseId = chatsByCourse.keys.elementAt(index);
              final courseChats = chatsByCourse[courseId]!;
              final course = DummyDataService.getCourseById(courseId);
              return Card(
                elevation: 0,
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(
                      course.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${courseChats.length} messages',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ),
                    children: courseChats.map((chat) {
                      final studentProgress = DummyDataService
                          .studentProgress['inst_1']
                          ?.firstWhere(
                            (progress) => progress.studentId == chat.senderId,
                            orElse: () => StudentProgress(
                              studentId: chat.senderId,
                              studentName: 'Unknow Student',
                              courseId: chat.courseId,
                              courseName: 'Unknow Course',
                              progress: 0,
                              lastActive: DateTime.now(),
                              quizScores: [],
                              completedLessons: 0,
                              totalLessons: 0,
                              averageTimePerLesson: 0,
                            ),
                          );
                      return ChatTile(
                        lastMessage: chat,
                        studentName: studentProgress?.studentName,
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
