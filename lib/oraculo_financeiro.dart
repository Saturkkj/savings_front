import 'package:flutter/material.dart';
import 'cores_app.dart';

class ResultadoOraculo {
  final String status;
  final Color cor;
  final IconData icone;
  final String dica;
  final double porcentagemGasta;

  ResultadoOraculo({
    required this.status,
    required this.cor,
    required this.icone,
    required this.dica,
    required this.porcentagemGasta,
  });
}

class OraculoFinanceiro {
  static ResultadoOraculo avaliarMasmorra({
    required double rendaFixa,
    required double rendaExtra,
    required double gastosTotais,
  }) {
    double rendaTotal = rendaFixa + rendaExtra;
    double porcentagem = 0;

    if (rendaTotal > 0) {
      porcentagem = (gastosTotais / rendaTotal) * 100;
    }

    if (porcentagem < 40) {
      return ResultadoOraculo(
        status: "Excelente",
        cor: CoresApp.successGreen,
        icone: Icons.sentiment_very_satisfied,
        dica: "Seu tesouro está seguro! Que tal investir 20% do que sobrou para multiplicar suas moedas?",
        porcentagemGasta: porcentagem,
      );
    } else if (porcentagem >= 40 && porcentagem < 70) {
      return ResultadoOraculo(
        status: "Atenção",
        cor: CoresApp.primary,
        icone: Icons.sentiment_neutral,
        dica: "Você comprometeu ${porcentagem.toStringAsFixed(0)}% da renda. Cuidado na taverna! Separe 10% num cofrinho de emergência.",
        porcentagemGasta: porcentagem,
      );
    } else if (porcentagem >= 70 && porcentagem < 90) {
      return ResultadoOraculo(
        status: "Em Risco",
        cor: Colors.orange,
        icone: Icons.warning_amber_rounded,
        dica: "Alerta! ${porcentagem.toStringAsFixed(0)}% da renda já foi. Evite gastos de lazer e foque apenas no essencial.",
        porcentagemGasta: porcentagem,
      );
    } else {
      return ResultadoOraculo(
        status: "No Vermelho",
        cor: CoresApp.dangerRed, // Vermelho
        icone: Icons.error_outline,
        dica: "HP Crítico! Você gastou mais de 90% da sua renda. Cuidado para não cair nas garras do cheque especial!",
        porcentagemGasta: porcentagem,
      );
    }
  }
}