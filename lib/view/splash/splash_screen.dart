import 'package:codelearn/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../routes/app_routes.dart';
import '../../services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted || _hasNavigated) return;
      _handleNavigation(context);
    });
  }

  void _handleNavigation(BuildContext context) {
    if (_hasNavigated) return;
    _hasNavigated = true;

    final authState = context.read<AuthBloc>().state;

    if(StorageService.isFirstTime()){
      //navigate to onboarding screen
      StorageService.setFirstTime(false);
      Get.offAllNamed(AppRoutes.onboarding);
    }else if(authState.userModel != null){
      //navigate based on user role
      if(authState.userModel!.role == UserRole.teacher){
        Get.offAllNamed(AppRoutes.teacherHome);
      }else {
        Get.offAllNamed(AppRoutes.main);
      }
    } else {
      //navigate to login screen
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        color: theme.colorScheme.primary,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.school,
                        size: 80,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        Text(
                          'Codelearn',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: theme.colorScheme.surface,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Learn Anytime, Anywhere',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.surface.withValues(alpha: 0.7),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.surface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
