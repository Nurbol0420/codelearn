import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codelearn/bloc/auth/auth_bloc.dart';
import 'package:codelearn/bloc/auth/auth_state.dart';
import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/models/group_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codelearn/l10n/app_localizations.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _firestore = FirebaseFirestore.instance;
  bool _isSending = false;

  // Firestore collection for group chat
  CollectionReference get _chatRef =>
      _firestore.collection('group_chat').doc('general').collection('messages');

  Future<void> _sendMessage(String userId, String userName,
      String? photoUrl, String role) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSending = true);
    _controller.clear();

    try {
      final msg = GroupMessage(
        id: '',
        senderId: userId,
        senderName: userName,
        senderPhotoUrl: photoUrl,
        senderRole: role,
        text: text,
        createdAt: DateTime.now(),
      );
      await _chatRef.add(msg.toFirestore());

      // Scroll to bottom
      await Future.delayed(const Duration(milliseconds: 100));
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState.userModel;

        return Scaffold(
          backgroundColor: AppColors.lightBackground,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            title: Row(children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white24,
                child: Icon(Icons.groups, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l10n.groupChat,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Text(l10n.groupChatSub,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 11)),
              ]),
            ]),
          ),

          body: Column(
            children: [
              // ── Messages list ──────────────────────────────────────────
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _chatRef
                      .orderBy('createdAt', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline,
                                size: 72, color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            Text(l10n.noMessagesYet,
                                style: TextStyle(color: Colors.grey.shade500)),
                            const SizedBox(height: 6),
                            Text(l10n.beFirstToMessage,
                                style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 12)),
                          ],
                        ),
                      );
                    }

                    final messages = snapshot.data!.docs
                        .map((doc) => GroupMessage.fromFirestore(doc))
                        .toList();

                    // Auto-scroll to bottom on new message
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                        );
                      }
                    });

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      itemCount: messages.length,
                      itemBuilder: (context, i) {
                        final msg = messages[i];
                        final isMe = msg.senderId == user?.uid;
                        final showDate = i == 0 ||
                            !_isSameDay(
                                messages[i - 1].createdAt, msg.createdAt);

                        return Column(
                          children: [
                            if (showDate) _DateDivider(date: msg.createdAt),
                            _MessageBubble(
                                message: msg, isMe: isMe),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),

              // ── Input box ──────────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, -2))
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                child: SafeArea(
                  child: Row(children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.lightBackground,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.2)),
                        ),
                        child: TextField(
                          controller: _controller,
                          minLines: 1,
                          maxLines: 4,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: l10n.typeMessage,
                            hintStyle:
                                TextStyle(color: Colors.grey.shade400),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                          ),
                          onSubmitted: (_) {
                            if (user != null) {
                              _sendMessage(
                                user.uid,
                                user.fullName ?? user.email,
                                user.photoUrl,
                                user.role.name,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: user == null || _isSending
                          ? null
                          : () => _sendMessage(
                                user.uid,
                                user.fullName ?? user.email,
                                user.photoUrl,
                                user.role.name,
                              ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: _isSending
                              ? Colors.grey
                              : AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2))
                          ],
                        ),
                        child: _isSending
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white))
                            : const Icon(Icons.send,
                                color: Colors.white, size: 20),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

// ── Date divider ──────────────────────────────────────────────────────────────
class _DateDivider extends StatelessWidget {
  final DateTime date;
  const _DateDivider({required this.date});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final l10n = AppLocalizations.of(context)!;
    String label;
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      label = l10n.today;
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1) {
      label = l10n.yesterday;
    } else {
      label = DateFormat('dd.MM.yyyy').format(date);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label,
              style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ]),
    );
  }
}

// ── Message bubble ────────────────────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final GroupMessage message;
  final bool isMe;
  const _MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTeacher = message.senderRole == 'teacher';
    final initials = message.senderName.isNotEmpty
        ? message.senderName
            .split(' ')
            .map((e) => e.isNotEmpty ? e[0] : '')
            .take(2)
            .join()
            .toUpperCase()
        : '?';

    return Padding(
      padding: EdgeInsets.only(
        bottom: 6,
        left: isMe ? 48 : 0,
        right: isMe ? 0 : 48,
      ),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar (only for others)
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor:
                  isTeacher ? Colors.orange.shade200 : AppColors.primary.withOpacity(0.2),
              backgroundImage: message.senderPhotoUrl != null
                  ? NetworkImage(message.senderPhotoUrl!)
                  : null,
              child: message.senderPhotoUrl == null
                  ? Text(initials,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isTeacher
                              ? Colors.orange.shade700
                              : AppColors.primary))
                  : null,
            ),
            const SizedBox(width: 8),
          ],

          // Bubble
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // Sender name + role badge (only for others)
                if (!isMe)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(message.senderName,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isTeacher
                                    ? Colors.orange.shade700
                                    : AppColors.primary)),
                        if (isTeacher) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('Teacher',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ],
                    ),
                  ),

                // Text bubble
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 4,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: Text(message.text,
                      style: TextStyle(
                          color: isMe ? Colors.white : Colors.black87,
                          fontSize: 14,
                          height: 1.4)),
                ),

                // Time
                Padding(
                  padding: const EdgeInsets.only(top: 3, left: 4, right: 4),
                  child: Text(
                    DateFormat('HH:mm').format(message.createdAt),
                    style: TextStyle(
                        fontSize: 10, color: Colors.grey.shade400),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
