import 'package:codelearn/bloc/profile/profile_bloc.dart';
import 'package:codelearn/bloc/profile/profile_event.dart';
import 'package:codelearn/view/onboarding/widgets/common/custom_button.dart';
import 'package:codelearn/view/onboarding/widgets/common/custom_textfield.dart';
import 'package:codelearn/view/profile/widgets/edit_profile_app_bar.dart';
import 'package:codelearn/view/profile/widgets/profile_picture_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codelearn/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../bloc/profile/profile_state.dart';
import '../../core/theme/app_color.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileBloc>().state.profile;
    if (profile != null) {
      _fullNameController.text = profile.fullName;
      _phoneController.text = profile.phoneNumber ?? '';
      _bioController.text = profile.bio ?? '';
    }
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(
        UpdateProfileRequested(
          fullName: _fullNameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          bio: _bioController.text.trim(),
        ),
      );
      context
          .read<ProfileBloc>()
          .stream
          .firstWhere((state) => !state.isLoading)
          .then((_) => Get.back());
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;
        if (profile == null) return const Scaffold();
        return Scaffold(
          appBar: EditProfileAppBar(onSave: _handleSave),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 20, bottom: 40),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.accent, width: 3),
                              ),
                              child: state.isPhotoUploading
                                  ? Shimmer.fromColors(
                                      baseColor: AppColors.primary.withValues(alpha: 0.3),
                                      highlightColor: AppColors.accent,
                                      child: const CircleAvatar(radius: 60, backgroundColor: Colors.white),
                                    )
                                  : CircleAvatar(
                                      radius: 60,
                                      backgroundColor: AppColors.accent,
                                      backgroundImage: profile.photoUrl != null ? NetworkImage(profile.photoUrl!) : null,
                                      child: profile.photoUrl == null
                                          ? Text(
                                              profile.fullName.split(' ').map((e) => e[0]).take(2).join().toUpperCase(),
                                              style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                                            )
                                          : null,
                                    ),
                            ),
                            Positioned(
                              bottom: 0, right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))],
                                ),
                                child: CircleAvatar(
                                  backgroundColor: AppColors.accent,
                                  radius: 20,
                                  child: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                        builder: (context) => const ProfilePictureBottomSheet(),
                                      );
                                    },
                                    color: AppColors.primary,
                                    icon: const Icon(Icons.camera_alt, size: 20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.editYourProfile,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16, left: 4),
                          child: Text(
                            l10n.personalInformation,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              CustomTextfield(label: l10n.fullName, prefixIcon: Icons.people_outline, controller: _fullNameController),
                              const SizedBox(height: 16),
                              CustomTextfield(label: l10n.email, prefixIcon: Icons.email_outlined, initialValue: profile.email ?? '', enabled: false),
                              const SizedBox(height: 16),
                              CustomTextfield(label: l10n.phone, prefixIcon: Icons.phone_outlined, controller: _phoneController),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16, left: 4),
                          child: Text(
                            l10n.aboutYou,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: CustomTextfield(label: l10n.bio, prefixIcon: Icons.info_outline, maxLines: 3, controller: _bioController),
                        ),
                        const SizedBox(height: 32),
                        CustomButton(
                          text: l10n.saveChanges,
                          onPressed: _handleSave,
                          icon: Icons.check_circle_outline,
                          isLoading: state.isLoading,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
