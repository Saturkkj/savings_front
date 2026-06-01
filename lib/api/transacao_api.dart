import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';

class TransacaoAPI {
  final String baseUrl = 'http://localhost:8080';
  final _storage = const FlutterSecureStorage();

  Future<bool> registrarTransacaoCSV(String descricao, double valorTotal, String categoria, String tipo, {int parcelas = 1}) async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) return false;

      String cabecalho = "descricao,valor,data,tipo,categoria\n";
      String linhasCsv = "";
      DateTime dataHoje = DateTime.now();

      double valorParcela = valorTotal / parcelas;

      for (int i = 0; i < parcelas; i++) {
        DateTime dataDaParcela = DateTime(dataHoje.year, dataHoje.month + i, dataHoje.day);
        String dataFormatada = dataDaParcela.toIso8601String().split('T')[0];

        String sufixo = parcelas > 1 ? " ${i + 1}/$parcelas" : "";
        String descricaoParcela = "$descricao$sufixo";

        linhasCsv += "$descricaoParcela,$valorParcela,$dataFormatada,$tipo,$categoria\n";
      }

      String csvMistico = cabecalho + linhasCsv;

      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/ingestao/csv'));
      request.headers.addAll({'Authorization': 'Bearer $token'});

      request.files.add(http.MultipartFile.fromString(
        'arquivo',
        csvMistico,
        filename: 'extrato_forjado.csv',
        contentType: MediaType('text', 'csv'),
      ));

      print("Enviando CSV com $parcelas parcelas pro servidor...\n$csvMistico");
      final response = await request.send();

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Caô pesado no envio do CSV: $e");
      return false;
    }
  }
}