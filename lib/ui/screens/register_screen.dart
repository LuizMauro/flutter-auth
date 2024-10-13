import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_login/blocs/authentication/authentication_state.dart';
import '../../repositories/user_repository.dart';

class RegisterScreen extends StatefulWidget {
  final UserRepository userRepository;

  const RegisterScreen({super.key, required this.userRepository});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Adicionamos FocusNodes para controlar o foco dos campos
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isSubmitting = false; // Estado para controlar o indicador de progresso

  UserRepository get _userRepository => widget.userRepository;

  @override
  void dispose() {
    // Liberar os recursos dos controladores e FocusNodes
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onRegisterButtonPressed() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      await _userRepository.register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      setState(() {
        _isSubmitting = false;
      });
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao registrar')),
      );
    }
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
      appBar: AppBar(
        title: const Text('Registrar'),
      ),
      body: GestureDetector(
        onTap: () {
          // Fecha o teclado ao tocar fora dos campos de entrada
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Registrar',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    TextFormField(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: Icon(Icons.person, color: Colors.blue),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        // Mover o foco para o campo de email
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      },
                    ),
                    const SizedBox(height: 20.0),
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
                        // Executar o registro ao pressionar "Enviar" no teclado
                        if (!_isSubmitting) {
                          _onRegisterButtonPressed();
                        }
                      },
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            _isSubmitting ? null : _onRegisterButtonPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 2.0,
                                ),
                              )
                            : const Text(
                                'Registrar',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Já possui uma conta? Login',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
