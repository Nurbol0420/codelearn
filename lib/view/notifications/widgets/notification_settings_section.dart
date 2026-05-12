import 'package:codelearn/core/theme/app_color.dart';
import 'package:flutter/material.dart';

import 'notification_setting_tile.dart';

class NotificationSettingsSection extends StatelessWidget {
  const NotificationSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          NotificationSettingTile(
            title: 'Push Notifications',
            subtitle: 'Receive push notifications',
            icon: Icons.notifications_outlined,
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: AppColors.primary,
            ),
          ),
          _buildDivider(),
          NotificationSettingTile(
            title: 'Course Updates',
            subtitle: 'Get notified about course updates',
            icon: Icons.school_outlined,
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: AppColors.primary,
            ),
          ),
          _buildDivider(),
          NotificationSettingTile(
            title: 'Quiz Reminders',
            subtitle: 'Receive quiz deadline reminders',
            icon: Icons.quiz_outlined,
            trailing: Switch(
              value: false,
              onChanged: (value) {},
              activeColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: AppColors.primary.withOpacity(0.1), height: 1);
  }
}
