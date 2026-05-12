import 'package:equatable/equatable.dart';
import 'package:codelearn/models/user_model.dart';

class AuthState extends Equatable {
  final UserModel? userModel;
  final bool isLoading;
  final String? error;

  final bool passwordResetEmailSent;

  const AuthState({
    this.userModel,
    this.isLoading = false,
    this.error,
    this.passwordResetEmailSent = false,
  });

  AuthState copyWith({
    UserModel? userModel,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool? passwordResetEmailSent,
  }) {
    return AuthState(
      userModel: userModel ?? this.userModel,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      passwordResetEmailSent:
      passwordResetEmailSent ?? this.passwordResetEmailSent,
    );
  }

  @override
  List<Object?> get props => [userModel, isLoading, error, passwordResetEmailSent];
}
