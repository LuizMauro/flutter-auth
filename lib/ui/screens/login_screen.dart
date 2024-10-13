import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_login/blocs/authentication/authentication_state.dart';
import 'package:flutter_login/blocs/login/login_bloc.dart';
import 'package:flutter_login/blocs/login/login_event.dart';
import 'package:flutter_login/blocs/login/login_state.dart';
import 'package:flutter_login/repositories/user_repository.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository userRepository;

  const LoginScreen({super.key, required this.userRepository});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc _loginBloc;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Adicionamos FocusNodes para controlar o foco dos campos
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  UserRepository get _userRepository => widget.userRepository;

  @override
  void initState() {
    super.initState();

    _loginBloc = LoginBloc(
      userRepository: _userRepository,
      authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
    );
  }

  @override
  void dispose() {
    // Liberar os recursos dos controladores e FocusNodes
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onLoginButtonPressed() {
    _loginBloc.add(LoginSubmitted(
      email: _emailController.text,
      password: _passwordController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthenticationBloc>().state;

    if (authState is AuthenticationAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      });
      return Container();
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Fecha o teclado ao tocar fora dos campos de entrada
          FocusScope.of(context).unfocus();
        },
        child: BlocListener<LoginBloc, LoginState>(
          bloc: _loginBloc,
          listener: (context, state) {
            if (state.isFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Falha no login')),
              );
            }

            // Removido o indicador de progresso aqui, pois será mostrado no botão
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            bloc: _loginBloc,
            builder: (context, state) {
              return _buildLoginForm(state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(LoginState state) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Flutter Login',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 30.0),
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.blue),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    // Mover o foco para o campo de senha
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.blue),
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    // Executar o login ao pressionar "Enviar" no teclado
                    if (!state.isSubmitting) {
                      _onLoginButtonPressed();
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width:
                      double.infinity, // Botão ocupar toda a largura disponível
                  child: ElevatedButton(
                    onPressed:
                        state.isSubmitting ? null : _onLoginButtonPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Cor de fundo do botão
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    child: state.isSubmitting
                        ? const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2.0,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    'Criar uma conta',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
