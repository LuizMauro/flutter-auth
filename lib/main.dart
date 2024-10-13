import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/blocs/todo/todo_bloc.dart';
import 'package:flutter_login/blocs/todo/todo_event.dart';
import 'package:flutter_login/ui/screens/SplashScreen.dart';
import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/authentication/authentication_event.dart';
import 'blocs/authentication/authentication_state.dart';
import 'repositories/user_repository.dart';
import 'repositories/todo_repository.dart';

import 'ui/screens/login_screen.dart';
import 'ui/screens/register_screen.dart';
import 'ui/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const urlApi = 'http://192.168.15.114:3000';

  final userRepository = UserRepository(baseUrl: urlApi);
  final todoRepository = TodoRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) =>
              AuthenticationBloc(userRepository: userRepository)
                ..add(AppStarted()),
        ),
        BlocProvider<TodoBloc>(
          create: (context) =>
              TodoBloc(todoRepository: todoRepository)..add(LoadTodos()),
        ),
      ],
      child: MyApp(
        userRepository: userRepository,
        todoRepository: todoRepository,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;
  final TodoRepository _todoRepository;

  const MyApp({
    super.key,
    required UserRepository userRepository,
    required TodoRepository todoRepository,
  })  : _userRepository = userRepository,
        _todoRepository = todoRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bloc Login',
      routes: {
        '/login': (context) => LoginScreen(userRepository: _userRepository),
        '/register': (context) =>
            RegisterScreen(userRepository: _userRepository),
        '/home': (context) => HomeScreen(todoRepository: _todoRepository),
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
