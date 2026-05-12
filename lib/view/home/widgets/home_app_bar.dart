import 'package:codelearn/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../bloc/profile/profile_bloc.dart';
import '../../../bloc/profile/profile_state.dart';
import '../../../routes/app_routes.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;

        return SliverAppBar(
          expandedHeight: 180,
          floating: false,
          pinned: true,
          backgroundColor: AppColors.primary,
          actions: [
            IconButton(
              onPressed: () => Get.toNamed(AppRoutes.analytics),
              icon: const Icon(Icons.analytics, color: Colors.white),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.accent.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  profile?.fullName ?? 'Loading...',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
