import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthAPI {
  final String baseUrl = 'http://localhost:8080';
  final _storage = const FlutterSecureStorage();

  Future<bool> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      print("RESPOSTA DA API: ${response.statusCode}");
      print("CORPO DA RESPOSTA: ${response.body}");

      if (response.statusCode == 200) {
        final token = response.body;
        await _storage.write(key: 'jwt_token', value: token);
        return true;
      }
      return false;
    } catch (e) {
      print("Caô na rede: $e");
      return false;
    }
  }

  Future<bool> registrarUsuario(String nome, String email, String senha,
      double renda, String classeHeroi) async {
    try {
      String perfilBackend = 'CONSERVADOR';
      if (classeHeroi == 'Guerreiro do Orçamento') perfilBackend = 'MODERADO';
      if (classeHeroi == 'Mago dos Investimentos') perfilBackend = 'ARROJADO';

      final bodyEnviado = jsonEncode({
        'nome': nome,
        'email': email,
        'senha': senha,
        'renda': renda,
        'perfilInvestidor': perfilBackend
      });

      print("🧙‍♂️ ENVIANDO PRO SERVIDOR: $bodyEnviado");

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: bodyEnviado,
      );

      print("🚨 STATUS DO SERVIDOR: ${response.statusCode}");
      print("🚨 RESPOSTA DO SERVIDOR: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("💀 Caô pesado na rede: $e");
      return false;
    }
  }
}