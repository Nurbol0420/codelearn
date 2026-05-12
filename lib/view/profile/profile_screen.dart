import 'package:codelearn/bloc/profile/profile_bloc.dart';
import 'package:codelearn/bloc/profile/profile_event.dart';
import 'package:codelearn/bloc/profile/profile_state.dart';
import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/view/profile/widgets/profile_app_bar.dart';
import 'package:codelearn/view/profile/widgets/profile_options.dart';
import 'package:codelearn/view/profile/widgets/profile_stats_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codelearn/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final profile = state.profile;
        if (profile == null) {
          return Scaffold(body: Center(child: Text(l10n.profileNotFound)));
        }
        return Scaffold(
          backgroundColor: AppColors.lightBackground,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              ProfileAppBar(
                initials: profile.fullName.split(' ').map((e) => e[0]).take(2).join().toUpperCase(),
                fullName: profile.fullName,
                email: profile.email,
                photoUrl: profile.photoUrl,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ProfileStatsCard(),
                      const SizedBox(height: 24),
                      ProfileOptions(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
