part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthStatusChanged extends AuthEvent {
  final AuthStatus status;
  final Map<String, dynamic>? payload;

  AuthStatusChanged(
    this.status, {
    this.payload,
  });
}

class AuthLogoutRequest extends AuthEvent {}
