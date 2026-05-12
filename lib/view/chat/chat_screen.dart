import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/models/chat_message.dart';
import 'package:codelearn/services/dummy_data_service.dart';
import 'package:codelearn/view/chat/widgets/message_bubble.dart';
import 'package:codelearn/view/chat/widgets/message_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  final String courseId;
  final String instructorID;
  final bool isTeacherView;
  final String? studentName;
  final TextEditingController _messageController = TextEditingController();

  ChatScreen({
    super.key,
    required this.courseId,
    required this.instructorID,
    required this.isTeacherView,
    this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: AppColors.accent),
        ),
        title: Text(
          isTeacherView
              ? 'Chat with ${studentName ?? 'Student'}'
              : 'Chat with Instructor',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: DummyDataService.getChatMessages(courseId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return MessageBubble(
                      message: message,
                      isMe: message.senderId == 'current_user_id',
                    );
                  },
                );
              },
            ),
          ),
          MessageInput(
            controller: _messageController,
            onSendPressed: () {
              if (_messageController.text.isNotEmpty) {
                //send message logic
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
