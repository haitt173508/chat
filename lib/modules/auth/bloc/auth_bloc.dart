import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_365/core/constants/app_constants.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/service/firebase_service.dart';
import 'package:chat_365/utils/data/enums/auth_status.dart';
import 'package:sp_util/sp_util.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authRepo) : super(AuthUnknownState()) {
    on<AuthStatusChanged>((event, emit) async {
      switch (event.status) {
        case AuthStatus.unknown:
          emit(AuthUnknownState());
          break;
        case AuthStatus.authenticated:
          emit(AuthenticatedState());
          break;
        case AuthStatus.unauthenticated:
          emit(UnAuthenticatedState());
          break;
      }
    });
    on<AuthLogoutRequest>((event, emit) async {
      await _authRepo.logout();
      add(AuthStatusChanged(AuthStatus.unauthenticated));
      // await Future.delayed(const Duration(milliseconds: 200));
      // await authRepo.logout();
      // userType = UserType.guest;
      // emit(UnAuthenticatedState(showIntro: false));

      //
      SpUtil.remove(AppConst.LIST_MESSAGE_UNREAD);
      FirebaseService().logoutFirebase();
    });

    _statusSubscription = _authRepo.status.listen((status) {
      add(AuthStatusChanged(status));
    });
  }

  final AuthRepo _authRepo;
  late final StreamSubscription<AuthStatus> _statusSubscription;

  @override
  Future<void> close() {
    _statusSubscription.cancel();
    _authRepo.dispose();
    return super.close();
  }
}
