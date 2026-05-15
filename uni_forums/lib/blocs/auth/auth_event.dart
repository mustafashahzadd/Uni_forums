part of 'auth_bloc.dart';

sealed class AuthEvent {}

class AuthSignUpEvent extends AuthEvent {
  final String email;
  final String password;
  AuthSignUpEvent({required this.email, required this.password});
}

class AuthSignInEvent extends AuthEvent {
  final String email;
  final String password;
  AuthSignInEvent({required this.email, required this.password});
}

class AuthSignOutEvent extends AuthEvent {}

class AuthCheckEvent extends AuthEvent {}
