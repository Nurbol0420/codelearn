import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/view/notifications/widgets/notification_settings_section.dart';
import 'package:codelearn/view/notifications/widgets/notifications_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:codelearn/l10n/app_localizations.dart';
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          l10n.notifications,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const NotificationSettingsSection(),
                  const SizedBox(height: 24),
                  Text(
                    l10n.recentNotifications,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const NotificationsList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
