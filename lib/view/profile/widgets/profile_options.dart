import 'package:codelearn/bloc/auth/auth_bloc.dart';
import 'package:codelearn/bloc/auth/auth_event.dart';
import 'package:codelearn/view/profile/widgets/profile_option_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codelearn/l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_dialogs.dart';
import '../../../routes/app_routes.dart';

class ProfileOptions extends StatelessWidget {
  const ProfileOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        ProfileOptionCard(
          title: l10n.editProfileOption,
          subtitle: l10n.editProfileSub,
          icon: Icons.edit_outlined,
          onTap: () => Get.toNamed(AppRoutes.editProfile),
        ),
        ProfileOptionCard(
          title: l10n.notifications,
          subtitle: l10n.notificationsSub,
          icon: Icons.notifications_outlined,
          onTap: () => Get.toNamed(AppRoutes.notifications),
        ),
        ProfileOptionCard(
          title: l10n.settings,
          subtitle: l10n.settingsSub,
          icon: Icons.settings_outlined,
          onTap: () => Get.toNamed(AppRoutes.setting),
        ),
        ProfileOptionCard(
          title: l10n.helpSupport,
          subtitle: l10n.helpSupportSub,
          icon: Icons.help_outlined,
          onTap: () => Get.toNamed(AppRoutes.helpSupport),
        ),
        ProfileOptionCard(
          title: l10n.logout,
          subtitle: l10n.logoutSub,
          icon: Icons.logout,
          onTap: () async {
            final confirm = await AppDialogs.showLogoutDialog(context);
            if (confirm == true) {
              context.read<AuthBloc>().add(LogoutRequested());
            }
          },
          isDestructive: true,
        ),
      ],
    );
  }
}
