import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/blocs/authentication/authentication_event.dart';
import 'package:flutter_login/blocs/authentication/authentication_state.dart';
import 'package:flutter_login/repositories/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(AuthenticationUninitialized()) {
    on<AppStarted>((event, emit) async {
      final hasToken = await _userRepository.hasToken();

      if (hasToken) {
        emit(AuthenticationAuthenticated());
      } else {
        emit(AuthenticationUnauthenticated());
      }
    });

    on<LoggedIn>((event, emit) async {
      emit(AuthenticationLoading());
      await _userRepository.persistToken(event.token);
      emit(AuthenticationAuthenticated());
    });

    on<LoggedOut>((event, emit) async {
      emit(AuthenticationLoading());
      await _userRepository.deleteToken();
      emit(AuthenticationUnauthenticated());
    });
  }
}
