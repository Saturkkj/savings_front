import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RecomendacaoAPI {
  final String baseUrl = 'http://localhost:8080';
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> buscarConselhoIA({double? valorDivida, int? mesesDeDivida}) async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) return null;
      
      print("A CHAVE: [$token]");

      Map<String, dynamic> bodyDaRequisicao = {};
      if (valorDivida != null && mesesDeDivida != null) {
        bodyDaRequisicao = {
          "valorDivida": valorDivida,
          "mesesDeDivida": mesesDeDivida
        };
      }

      print("Invocando o Oráculo em $baseUrl/recomendacao...");

      final response = await http.post(
        Uri.parse('$baseUrl/recomendacao'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: bodyDaRequisicao.isNotEmpty ? jsonEncode(bodyDaRequisicao) : jsonEncode({}),
      );

      print("STATUS DO ORÁCULO: ${response.statusCode}");
      print("RESPOSTA DO SERVIDOR: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      print("Erro na rede: $e");
      return null;
    }
  }
}