part of 'auth_bloc.dart';

sealed class AuthState {}

class AuthStateInitial extends AuthState {}
class AuthStateLoading extends AuthState {}
class AuthStateAuthenticated extends AuthState {
  final String email;
  AuthStateAuthenticated({required this.email});
}
class AuthStateUnauthenticated extends AuthState {}
class AuthStateFailure extends AuthState {
  final String error;
  AuthStateFailure({required this.error});
}
