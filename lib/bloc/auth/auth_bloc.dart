import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:codelearn/bloc/auth/auth_event.dart';
import 'package:codelearn/bloc/auth/auth_state.dart';
import 'package:get/get.dart';
import '../../repositories/auth_repository.dart';
import '../../routes/app_routes.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription? _authStateSubscription;

  AuthBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(const AuthState()) {
    _authStateSubscription = _authRepository.authStateChanges.listen(
          (user) => add(AuthStateChanged(user)),
    );

    on<AuthStateChanged>(_onAuthStateChanged);
    on<RegisterRequested>(_onRegisterRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);

  }

  Future<void> _onAuthStateChanged(
      AuthStateChanged event,
      Emitter<AuthState> emit,
      ) async {
    if (event.user != null) {
      emit(
        state.copyWith(
          userModel: event.user,
          isLoading: false,
          clearError: true,
          passwordResetEmailSent: false,
        ),
      );
    } else {
      emit(const AuthState());
    }
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true, passwordResetEmailSent: false));
      final user = await _authRepository.signUp(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
        role: event.role,
      );
      emit(state.copyWith(userModel: user, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false, passwordResetEmailSent: false));
    }
  }

  Future<void> _onLoginRequested(
      LoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true, passwordResetEmailSent: false));
      await _authRepository.signIn(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false, passwordResetEmailSent: false));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true, passwordResetEmailSent: false));
      await _authRepository.signOut();
      emit(const AuthState());
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false, passwordResetEmailSent: false));
    }
  }

  Future<void> _onUpdateProfileRequested(
      UpdateProfileRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true, passwordResetEmailSent: false));
      await _authRepository.updateProfile(
        fullName: event.fullName,
        photoUrl: event.photoUrl,
        phoneNumber: event.phoneNumber,
        bio: event.bio,
      );
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false, passwordResetEmailSent: false));
    }
  }

  Future<void> _onForgotPasswordRequested(
      ForgotPasswordRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true, passwordResetEmailSent: false));
      await _authRepository.resetPassword(event.email);
      emit(state.copyWith(
        isLoading: false,
        passwordResetEmailSent: true,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false, passwordResetEmailSent: false));
    }
  }

  Future<void> _onGoogleSignInRequested(
      GoogleSignInRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true, passwordResetEmailSent: false));
      await _authRepository.signInWithGoogle();
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }


  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
