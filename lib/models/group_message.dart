import 'package:cloud_firestore/cloud_firestore.dart';

class GroupMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderPhotoUrl;
  final String senderRole; // 'student' or 'teacher'
  final String text;
  final DateTime createdAt;

  GroupMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderPhotoUrl,
    required this.senderRole,
    required this.text,
    required this.createdAt,
  });

  factory GroupMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroupMessage(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? 'Unknown',
      senderPhotoUrl: data['senderPhotoUrl'],
      senderRole: data['senderRole'] ?? 'student',
      text: data['text'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'senderId': senderId,
    'senderName': senderName,
    'senderPhotoUrl': senderPhotoUrl,
    'senderRole': senderRole,
    'text': text,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}
