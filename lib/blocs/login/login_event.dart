import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  final String email;

  LoginEmailChanged({required this.email});

  @override
  List<Object?> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  LoginPasswordChanged({required this.password});

  @override
  List<Object?> get props => [password];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  LoginSubmitted({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
