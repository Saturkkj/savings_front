import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'cores_app.dart';
import 'oraculo_financeiro.dart';

class TelaAnalises extends StatefulWidget {
  const TelaAnalises({super.key});

  @override
  State<TelaAnalises> createState() => _TelaAnalisesState();
}

class _TelaAnalisesState extends State<TelaAnalises> {
  final double rendaFixaMes = 2000.0;
  final double rendaExtraMes = 0.0;
  final double gastosTotaisMes = 1000.0;

  int touchedIndex = -1;

  void _mostrarExplicacao(String categoria) {
    String descricao = "";
    String dica = "";
    IconData icone = Icons.help_outline;
    List<Map<String, dynamic>> gastosDetalhados = [];

    if (categoria == "Fixos") {
      icone = Icons.home_work;
      descricao = "Gastos essenciais que garantem sua sobrevivência.";
      dica = "O ideal é que não passem de 50% da sua renda total.";
      gastosDetalhados = [
        {"nome": "Aluguel da Taverna", "valor": "R\$ 300,00", "icone": Icons.house},
        {"nome": "Sinal Mágico (Internet)", "valor": "R\$ 80,00", "icone": Icons.wifi},
        {"nome": "Energia (Luz)", "valor": "R\$ 70,00", "icone": Icons.lightbulb},
      ];
    } else if (categoria == "Variáveis") {
      icone = Icons.shopping_cart;
      descricao = "Itens necessários com valores que oscilam.";
      dica = "Tente manter em até 30% para não comprometer o tesouro.";
      gastosDetalhados = [
        {"nome": "Mercado das Poções", "valor": "R\$ 180,00", "icone": Icons.local_grocery_store},
        {"nome": "Carruagem (Uber/Ônibus)", "valor": "R\$ 70,00", "icone": Icons.directions_bus},
      ];
    } else if (categoria == "Pessoais") {
      icone = Icons.sports_esports;
      descricao = "Recompensas e lazer para manter sua sanidade.";
      dica = "Sabia que apenas 20% dos seus gastos devem ir para lazer?";
      gastosDetalhados = [
        {"nome": "Pizza", "valor": "R\$ 80,00", "icone": Icons.local_pizza},
        {"nome": "Jogos na Steam", "valor": "R\$ 120,00", "icone": Icons.videogame_asset},
      ];
    } else {
      icone = Icons.question_mark;
      descricao = "Imprevistos e gastos fora do padrão.";
      dica = "Tenha sempre uma reserva para emergências.";
      gastosDetalhados = [
        {"nome": "Conserto da Espada", "valor": "R\$ 100,00", "icone": Icons.build},
      ];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFF2C1960),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, color: Colors.white24)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(icone, color: CoresApp.primary, size: 28),
                  const SizedBox(width: 12),
                  Text("Categoria: $categoria", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),
              Text(descricao, style: const TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CoresApp.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: CoresApp.primary.withOpacity(0.3)),
                ),
                child: Text("Dica: $dica", style: const TextStyle(color: CoresApp.primary, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 25),
              const Text("RAIO-X DOS GASTOS", style: TextStyle(color: CoresApp.textMedContrast, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: gastosDetalhados.length,
                  itemBuilder: (context, index) {
                    final item = gastosDetalhados[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(item['icone'], color: Colors.white60),
                      title: Text(item['nome'], style: const TextStyle(color: Colors.white, fontSize: 14)),
                      trailing: Text(item['valor'], style: const TextStyle(color: CoresApp.dangerRed, fontWeight: FontWeight.bold)),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ResultadoOraculo diagnostico = OraculoFinanceiro.avaliarMasmorra(
      rendaFixa: rendaFixaMes,
      rendaExtra: rendaExtraMes,
      gastosTotais: gastosTotaisMes,
    );

    return Scaffold(
      backgroundColor: CoresApp.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Mapa do Tesouro", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: CoresApp.primary)),
              const SizedBox(height: 25),

              _buildPainelOraculo(diagnostico),

              const SizedBox(height: 35),

              Container(
                height: 250,
                decoration: BoxDecoration(color: CoresApp.cardBackground, borderRadius: BorderRadius.circular(20)),
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        if (response != null && response.touchedSection != null && event is FlTapUpEvent) {
                          setState(() {
                            touchedIndex = response.touchedSection!.touchedSectionIndex;
                            List<String> nomes = ["Fixos", "Variáveis", "Pessoais", "Outros"];
                            _mostrarExplicacao(nomes[touchedIndex]);
                          });
                        }
                      },
                    ),
                    sectionsSpace: 4,
                    centerSpaceRadius: 50,
                    sections: [
                      _buildSection(0, 45, "Fixos", const Color(0xFF8A2BE2)),
                      _buildSection(1, 25, "Variáveis", CoresApp.primary),
                      _buildSection(2, 20, "Pessoais", CoresApp.dangerRed),
                      _buildSection(3, 10, "Outros", const Color(0xFF00CED1)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
              _buildLegenda("Gastos Fixos (45%)", const Color(0xFF8A2BE2), "Fixos"),
              _buildLegenda("Gastos Variáveis (25%)", CoresApp.primary, "Variáveis"),
              _buildLegenda("Gastos Pessoais (20%)", CoresApp.dangerRed, "Pessoais"),
              _buildLegenda("Outros (10%)", const Color(0xFF00CED1), "Outros"),
            ],
          ),
        ),
      ),
    );
  }

  // Widgets Auxiliares
  PieChartSectionData _buildSection(int index, double valor, String titulo, Color cor) {
    return PieChartSectionData(
      color: cor,
      value: valor,
      title: '${valor.toInt()}%',
      radius: index == touchedIndex ? 70 : 60,
      titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _buildLegenda(String texto, Color cor, String id) {
    return GestureDetector(
        onTap: () => _mostrarExplicacao(id),
    child: Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: CoresApp.cardBackground, borderRadius: BorderRadius.circular(15)),
    child: Row(
    children: [
    Container(width: 12, height: 12, decoration: BoxDecoration(color: cor, shape: BoxShape.circle)),
    const SizedBox(width: 12),
    Text(texto, style: const TextStyle(color: Colors.white, fontSize: 14)),
    const Spacer(),
    const Icon(Icons.info_outline, color: Colors.white24, size: 18),
    ],
    ),
    ),
    );
    }

  Widget _buildPainelOraculo(ResultadoOraculo diagnostico) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CoresApp.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: diagnostico.cor.withOpacity(0.5), width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(diagnostico.icone, color: diagnostico.cor, size: 28),
              const SizedBox(width: 10),
              Text("Status: ${diagnostico.status}", style: TextStyle(color: diagnostico.cor, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15),
          Text("Você comprometeu ${diagnostico.porcentagemGasta.toStringAsFixed(1)}% da sua renda", style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}