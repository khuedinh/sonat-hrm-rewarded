import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:sonat_hrm_rewarded/src/packages/authentication_repository/authentication_repository.dart';
import 'package:sonat_hrm_rewarded/src/packages/authentication_repository/models/user.dart';

part 'app_event.dart';
part 'app_state.dart';

const String kFCMTokenKey = 'fcm_token';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
          const AppState.authenticated(),
        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(AppUserChanged()),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) async {
    emit(
      firebase_auth.FirebaseAuth.instance.currentUser != null
          ? const AppState.authenticated()
          : const AppState.unauthenticated(),
    );
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
