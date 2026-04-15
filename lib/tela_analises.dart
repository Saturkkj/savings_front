import 'package:flutter/material.dart';
import 'cores_app.dart';
import 'oraculo_financeiro.dart';

class TelaAnalises extends StatefulWidget {
  const TelaAnalises({super.key});

  @override
  State<TelaAnalises> createState() => _TelaAnalisesState();
}

class _TelaAnalisesState extends State<TelaAnalises> {
  // puxar isso do banco de dados/Firebase
  final double rendaFixaMes = 2000.0;
  final double rendaExtraMes = 0.0;
  final double gastosTotaisMes = 1000.0;

  @override
  Widget build(BuildContext context) {
    ResultadoOraculo diagnostico = OraculoFinanceiro.avaliarMasmorra(
      rendaFixa: rendaFixaMes,
      rendaExtra: rendaExtraMes,
      gastosTotais: gastosTotaisMes,
    );

    double rendaTotal = rendaFixaMes + rendaExtraMes;

    return Scaffold(
      backgroundColor: CoresApp.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- CABEÇALHO ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bar_chart, color: CoresApp.primary, size: 30),
                      const SizedBox(width: 10),
                      const Text(
                        "Mapa do Tesouro",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: CoresApp.primary,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.more_horiz, color: Colors.white),
                ],
              ),
              const SizedBox(height: 5),
              const Text(
                "O Oráculo avalia sua jornada",
                style: TextStyle(color: CoresApp.textMedContrast, fontSize: 14),
              ),
              const SizedBox(height: 25),

              // ==========================================
              // O ORÁCULO FINANCEIRO (INTELIGÊNCIA)
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CoresApp.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: diagnostico.cor.withOpacity(0.5), width: 2),
                ),
                child: Column(
                  children: [
                    // Título e Ícone do Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(diagnostico.icone, color: diagnostico.cor, size: 28),
                        const SizedBox(width: 10),
                        Text(
                          "Status: ${diagnostico.status}",
                          style: TextStyle(color: diagnostico.cor, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Barra de Progresso do Salário (O HP do Mês)
                    Row(
                      children: [
                        Text("R\$ 0", style: TextStyle(color: CoresApp.textMedContrast.withOpacity(0.5), fontSize: 10)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: 15,
                                decoration: BoxDecoration(
                                  color: CoresApp.background,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: (diagnostico.porcentagemGasta / 100).clamp(0.0, 1.0),
                                child: Container(
                                  height: 15,
                                  decoration: BoxDecoration(
                                    color: diagnostico.cor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text("R\$ ${rendaTotal.toStringAsFixed(0)}", style: const TextStyle(color: CoresApp.textMedContrast, fontSize: 10)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Você comprometeu ${diagnostico.porcentagemGasta.toStringAsFixed(1)}% da sua renda",
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),

                    // A Dica do Oráculo
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: diagnostico.cor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline, color: diagnostico.cor, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              diagnostico.dica,
                              style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // --- SELETOR DE MESES ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMes("Jan", false),
                  _buildMes("Fev", false),
                  _buildMes("Mar", false),
                  _buildMes("Abr", true),
                ],
              ),
              const SizedBox(height: 25),

              // --- GRÁFICO DE BARRAS ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CoresApp.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Gastos por categoria (R\$)",
                      style: TextStyle(color: CoresApp.textMedContrast, fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBarraGrafico("Comida", 80, const Color(0xFF8A2BE2)),
                        _buildBarraGrafico("Trans.", 60, CoresApp.primary),
                        _buildBarraGrafico("Lazer", 120, CoresApp.dangerRed),
                        _buildBarraGrafico("Estudo", 40, CoresApp.successGreen),
                        _buildBarraGrafico("Outros", 70, const Color(0xFF00CED1)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- CARDS DE RECEITA E GASTOS ---
              Row(
                children: [
                  Expanded(
                    child: _buildResumoCard(
                      "Receita total",
                      "R\$ 2.100",
                      "▲ 8% mês",
                      CoresApp.successGreen,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildResumoCard(
                      "Gastos totais",
                      "R\$ 860",
                      "▼ 3% mês",
                      CoresApp.dangerRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),

              // --- STATUS DO HERÓI (BARRAS DE PROGRESSO) ---
              Row(
                children: [
                  const Icon(Icons.close, color: CoresApp.primary, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    "STATUS DO HERÓI",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: CoresApp.primary,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _buildBarraStatus("Controle de gastos", 0.78, "78%", CoresApp.successGreen),
              const SizedBox(height: 15),
              _buildBarraStatus("Poder de poupança", 0.55, "55%", CoresApp.primary),
              const SizedBox(height: 15),
              _buildBarraStatus("Investimento", 0.30, "30%", const Color(0xFF8A2BE2)),
              const SizedBox(height: 15),
              _buildBarraStatus("Disciplina financeira", 0.62, "62%", const Color(0xFF00CED1)),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildMes(String nome, bool ativo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: ativo ? CoresApp.primary : CoresApp.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        nome,
        style: TextStyle(
          color: ativo ? Colors.black : CoresApp.textMedContrast,
          fontWeight: ativo ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildBarraGrafico(String label, double altura, Color cor) {
    return Column(
      children: [
        Container(
          width: 40,
          height: altura,
          decoration: BoxDecoration(
            color: cor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(color: CoresApp.textMedContrast, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildResumoCard(String titulo, String valor, String tag, Color corTag) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CoresApp.cardBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: CoresApp.background, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(color: CoresApp.textMedContrast, fontSize: 12)),
          const SizedBox(height: 8),
          Text(valor, style: TextStyle(color: CoresApp.primary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: corTag.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              tag,
              style: TextStyle(color: corTag, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarraStatus(String titulo, double proporcao, String porcentagemStr, Color cor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 14)),
            Text(porcentagemStr, style: TextStyle(color: cor, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: CoresApp.background,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            FractionallySizedBox(
              widthFactor: proporcao,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: cor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}