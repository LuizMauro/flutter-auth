import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/blocs/authentication/authentication_state.dart';
import 'package:flutter_login/ui/screens/SplashScreen.dart';
import 'package:flutter_login/ui/screens/register_screen.dart';
import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/authentication/authentication_event.dart';
import 'repositories/user_repository.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/home_screen.dart';

void main() {
  const urlApi = 'http://192.168.15.114:3000';

  final userRepository = UserRepository(baseUrl: urlApi);

  runApp(
    BlocProvider(
      create: (context) =>
          AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
      child: MyApp(userRepository: userRepository),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  const MyApp({super.key, required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bloc Login',
      routes: {
        '/login': (context) => LoginScreen(userRepository: _userRepository),
        '/register': (context) =>
            RegisterScreen(userRepository: _userRepository),
        '/home': (context) => HomeScreen(userRepository: _userRepository),
      },
      home: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationAuthenticated) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          } else if (state is AuthenticationUnauthenticated) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
          }
        },
        child: const SplashScreen(),
      ),
    );
  }
}
