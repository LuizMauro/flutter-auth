// ui/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/blocs/authentication/authentication_event.dart';
import 'package:flutter_login/models/user.dart';
import 'package:flutter_login/repositories/user_repository.dart';
import '../../blocs/authentication/authentication_bloc.dart';
import '../../blocs/authentication/authentication_state.dart';

class HomeScreen extends StatefulWidget {
  final UserRepository userRepository;
  const HomeScreen({super.key, required this.userRepository});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<User> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = widget.userRepository.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthenticationBloc>().state;

    if (authState is AuthenticationUnauthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      });
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Inicial'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthenticationBloc>().add(LoggedOut());
            },
          ),
        ],
      ),
      body: FutureBuilder<User>(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Text('Bem-vindo, ${snapshot.data!.name}!'),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar dados do usuário'),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
