import 'package:flutter/material.dart';

import 'notification_card.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return NotificationCard(
          title: 'New Course Available',
          message: 'Check out our new Flutter Advanced course!',
          time: '2 hours ago',
          icon: Icons.school,
          isUnread: index == 0,
        );
      },
    );
  }
}
