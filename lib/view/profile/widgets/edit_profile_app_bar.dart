import 'package:codelearn/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSave;
  const EditProfileAppBar({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
      backgroundColor: AppColors.primary,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back, color: Colors.white),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        TextButton(
          onPressed: onSave,
          child: const Text(
            'Save',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
