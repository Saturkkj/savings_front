import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InteligenciaAPI {
  final String baseUrl = 'http://localhost:8080';
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> buscarRelatorioCompleto() async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/inteligencia/relatorio'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      print("Erro: $e");
      return null;
    }
  }
}