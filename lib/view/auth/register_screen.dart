import 'package:codelearn/bloc/auth/auth_event.dart';
import 'package:codelearn/core/utils/validators.dart';
import 'package:codelearn/view/onboarding/widgets/common/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:codelearn/l10n/app_localizations.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../models/user_model.dart';
import '../../routes/app_routes.dart';
import '../onboarding/widgets/common/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  UserRole? _selectedRole;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _selectRole() async {
    final selected = await showModalBottomSheet<UserRole>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppLocalizations.of(context)!.selectRoleHint,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ...UserRole.values.map((role) {
                final roleName = role.toString().split('.').last.capitalize!;
                final icon = role == UserRole.teacher
                    ? Icons.school
                    : Icons.person;
                return ListTile(
                  leading: Icon(icon, color: Theme.of(context).primaryColor),
                  title: Text(roleName),
                  onTap: () => Navigator.pop(context, role),
                );
              }),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedRole = selected;
      });
    }
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate() && _selectedRole != null) {
      context.read<AuthBloc>().add(
        RegisterRequested(
          email: _emailController.text,
          password: _passwordController.text,
          fullName: _fullNameController.text,
          role: _selectedRole!,
        ),
      );
    } else if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseSelectRole),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData roleIcon;
    if (_selectedRole == UserRole.teacher) {
      roleIcon = Icons.school;
    } else if (_selectedRole == UserRole.student) {
      roleIcon = Icons.person;
    } else {
      roleIcon = Icons.person_outline;
    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        } else if (state.userModel != null) {
          //navigate based on user role
          if (state.userModel!.role == UserRole.teacher) {
            Get.offAllNamed(AppRoutes.teacherHome);
          } else {
            Get.offAllNamed(AppRoutes.main);
          }
        }
      },

      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                height: Get.height * 0.3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(100),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 50,
                      left: 20,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.createAccount,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            AppLocalizations.of(context)!.startJourney,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      CustomTextfield(
                        label: AppLocalizations.of(context)!.fullName,
                        hint: AppLocalizations.of(context)!.enterFullName,
                        prefixIcon: Icons.person_outline,
                        controller: _fullNameController,
                        validator: FormValidator.validateFullName,
                      ),
                      const SizedBox(height: 20),
                      CustomTextfield(
                        label: AppLocalizations.of(context)!.email,
                        hint: AppLocalizations.of(context)!.enterEmail,
                        prefixIcon: Icons.email_outlined,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: FormValidator.validateEmail,
                      ),
                      const SizedBox(height: 20),
                      CustomTextfield(
                        label: AppLocalizations.of(context)!.password,
                        hint: AppLocalizations.of(context)!.enterPassword,
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        controller: _passwordController,
                        validator: FormValidator.validatePassword,
                      ),
                      const SizedBox(height: 20),
                      CustomTextfield(
                        label: AppLocalizations.of(context)!.confirmPassword,
                        hint: AppLocalizations.of(context)!.reEnterPassword,
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        controller: _confirmPasswordController,
                        validator: (value) =>
                            FormValidator.validateConfirmPassword(
                              value,
                              _passwordController.text,
                            ),
                      ),
                      const SizedBox(height: 20),

                      // Role Selector (với icon động)
                      GestureDetector(
                        onTap: _selectRole,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.role,
                            prefixIcon: Icon(roleIcon),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          child: Text(
                            _selectedRole
                                    ?.toString()
                                    .split('.')
                                    .last
                                    .capitalize ??
                                AppLocalizations.of(context)!.selectRoleHint,
                            style: TextStyle(
                              fontSize: 16,
                              color: _selectedRole == null
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return CustomButton(
                            text: AppLocalizations.of(context)!.register,
                            onPressed: _handleRegister,
                            isLoading: state.isLoading,
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context)!.alreadyHaveAccount),
                          TextButton(
                            onPressed: () => Get.back(result: AppRoutes.login),
                            child: Text(
                              AppLocalizations.of(context)!.login,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
