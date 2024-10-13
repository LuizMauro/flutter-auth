import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  const LoginState({
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
  });

  factory LoginState.initial() {
    return const LoginState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory LoginState.loading() {
    return const LoginState(
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory LoginState.failure() {
    return const LoginState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory LoginState.success() {
    return const LoginState(
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  @override
  List<Object?> get props => [isSubmitting, isSuccess, isFailure];
}
