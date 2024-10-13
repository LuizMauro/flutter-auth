import 'package:bloc/bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import '../../repositories/user_repository.dart';
import '../authentication/authentication_bloc.dart';
import '../authentication/authentication_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;
  final AuthenticationBloc _authenticationBloc;

  LoginBloc({
    required UserRepository userRepository,
    required AuthenticationBloc authenticationBloc,
  })  : _userRepository = userRepository,
        _authenticationBloc = authenticationBloc,
        super(LoginState.initial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginState.loading());
      try {
        final token = await _userRepository.authenticate(
          email: event.email,
          password: event.password,
        );
        _authenticationBloc.add(LoggedIn(token: token!));
        emit(LoginState.success());
      } catch (_) {
        emit(LoginState.failure());
      }
    });
  }
}
