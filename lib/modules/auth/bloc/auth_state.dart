part of 'auth_bloc.dart';

abstract class AuthState {
  final AuthStatus status;

  AuthState({
    required this.status,
  });
}

class AuthUnknownState extends AuthState {
  AuthUnknownState()
      : super(
          status: AuthStatus.unknown,
        );
}

class AuthenticatedState extends AuthState {
  AuthenticatedState()
      : super(
          status: AuthStatus.authenticated,
        );
}

class UnAuthenticatedState extends AuthState {
  final bool showIntro;
  final String? error;

  UnAuthenticatedState({
    this.error,
    this.showIntro = true,
  }) : super(status: AuthStatus.unauthenticated);
}
