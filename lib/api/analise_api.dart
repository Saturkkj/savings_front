import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AnaliseAPI {
  final String baseUrl = 'http://localhost:8080';
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> buscarRelatorioCompleto({int? ano, int? mes}) async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) return null;

      String urlFinal = '$baseUrl/inteligencia/relatorio';
      if (ano != null && mes != null) {
        urlFinal += '?ano=$ano&mes=$mes';
      }

      final response = await http.get(
        Uri.parse(urlFinal),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      print("Caô ao buscar relatório: $e");
      return null;
    }
  }
}