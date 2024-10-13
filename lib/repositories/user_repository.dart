import 'dart:convert';

import 'package:flutter_login/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRepository {
  final String baseUrl;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  UserRepository({required this.baseUrl});

  get headers => null;

  Future<String?> authenticate({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['accessToken'];
    } else {
      throw Exception('Falha ao autenticar');
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode != 201) {
      throw Exception('Falha ao registrar');
    }
  }

  Future<User> getUserProfile() async {
    final token = await getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/user/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Falha ao carregar perfil do usuário');
    }
  }

  Future<void> persistToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<void> deleteToken() async {
    await _storage.deleteAll();
  }

  Future<bool> hasToken() async {
    final token = await _storage.read(key: 'token');
    return token != null;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }
}
