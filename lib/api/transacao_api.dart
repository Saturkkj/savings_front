import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TransacaoAPI {
  final String baseUrl = 'http://localhost:8080';
  final _storage = const FlutterSecureStorage();

  Future<bool> registrarGasto(String descricao, double valor, String categoria, bool isGasto) async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) return false;

      String tipo = isGasto ? "DESPESA" : "RECEITA";
      String dataAtual = DateTime.now().toIso8601String().split('T')[0];
      String conteudoCsv = "descricao,valor,data,tipo,categoria\n$descricao,$valor,$dataAtual,$tipo,$categoria";

      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/ingestao/csv'));
      request.headers['Authorization'] = 'Bearer $token';

      request.files.add(http.MultipartFile.fromString(
        'arquivo',
        conteudoCsv,
        filename: 'extrato.csv',
      ));

      var response = await request.send();

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Caô ao registrar a transação: $e");
      return false;
    }
  }
}