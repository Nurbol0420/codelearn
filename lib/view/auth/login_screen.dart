import 'package:codelearn/bloc/auth/auth_event.dart';
import 'package:codelearn/core/utils/validators.dart';
import 'package:codelearn/routes/app_routes.dart';
import 'package:codelearn/view/onboarding/widgets/common/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:codelearn/l10n/app_localizations.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../models/user_model.dart';
import '../onboarding/widgets/common/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequested(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;

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
              // Top Wave
              Container(
                height: size.height * 0.3,
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
                    bottomLeft: Radius.circular(100),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.school, color: Colors.white, size: 50),
                      const SizedBox(height: 10),
                      Text(
                        l10n.welcomeBack,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Email
                      CustomTextfield(
                        label: l10n.email,
                        prefixIcon: Icons.email_outlined,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: FormValidator.validateEmail,
                      ),
                      const SizedBox(height: 20),

                      CustomTextfield(
                        label: l10n.password,
                        prefixIcon: Icons.lock_outline,
                        controller: _passwordController,
                        obscureText: true,
                        validator: FormValidator.validatePassword,
                      ),
                      const SizedBox(height: 20),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () =>
                              Get.toNamed(AppRoutes.forgotPassword),
                          child: Text(
                            l10n.forgotPassword,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Login Button
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return CustomButton(
                            text: l10n.login,
                            onPressed: _handleLogin,
                            isLoading: state.isLoading,
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(l10n.orContinueWith),
                          ),
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Social Login Buttons
                      // Social Login Buttons
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final isBusy = state.isLoading;

                          return Row(
                            children: [
                              // GOOGLE
                              Expanded(
                                child: _socialLoginButton(
                                  icon: Icons.g_mobiledata_outlined,
                                  onPressed: isBusy
                                      ? () {}
                                      : () => context.read<AuthBloc>().add(const GoogleSignInRequested()),
                                ),
                              ),
                              const SizedBox(width: 16),

                              Expanded(
                                child: _socialLoginButton(
                                  icon: Icons.facebook,
                                  onPressed: isBusy ? () {} : () { /* TODO: dispatch FacebookSignInRequested */ },
                                ),
                              ),
                              const SizedBox(width: 16),

                              Expanded(
                                child: _socialLoginButton(
                                  icon: Icons.apple,
                                  onPressed: isBusy ? () {} : () { /* TODO: dispatch AppleSignInRequested */ },
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(l10n.dontHaveAccount),
                          TextButton(
                            onPressed: () => Get.toNamed(AppRoutes.register),
                            child: Text(
                              l10n.register,
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

  Widget _socialLoginButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return CustomButton(
      icon: icon,
      isFullWidth: true,
      height: 50,
      text: '',
      onPressed: onPressed,
      isOutlined: true,
    );
  }
}
