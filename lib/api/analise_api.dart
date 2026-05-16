import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AnaliseAPI {
  final String baseUrl = 'http://localhost:8080';
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> buscarRelatorioCompleto() async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) return null;

      // Pegando o mês e ano atual pra filtrar
      final agora = DateTime.now();
      final response = await http.get(
        Uri.parse('$baseUrl/inteligencia/relatorio?ano=${agora.year}&mes=${agora.month}'), // [cite: 68, 69]
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes)); // [cite: 78]
      }
      return null;
    } catch (e) {
      print("Caô na rede ao buscar o mapa do tesouro: $e");
      return null;
    }
  }
}