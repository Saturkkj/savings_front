import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'cores_app.dart';
import 'oraculo_financeiro.dart';
import 'api/analise_api.dart';

class TelaAnalises extends StatefulWidget {
  const TelaAnalises({super.key});

  @override
  State<TelaAnalises> createState() => _TelaAnalisesState();
}

class _TelaAnalisesState extends State<TelaAnalises> {
  final _storage = const FlutterSecureStorage();

  double rendaFixaMes = 0.0;
  double gastosTotaisMes = 0.0;
  List<dynamic> categoriasDaIA = [];
  bool _carregando = true;

  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _carregarDadosReais();
  }

  Future<void> _carregarDadosReais() async {
    setState(() => _carregando = true);

    String? rendaSalva = await _storage.read(key: 'renda_total');
    final relatorio = await AnaliseAPI().buscarRelatorioCompleto();

    if (mounted) {
      setState(() {
        if (rendaSalva != null) rendaFixaMes = double.parse(rendaSalva);

        if (relatorio != null) {
          categoriasDaIA = relatorio['mediasPorCategoria'] ?? [];
          gastosTotaisMes = categoriasDaIA.fold(0.0, (soma, item) => soma + (item['totalGastos'] ?? 0.0));
        }
        _carregando = false;
      });
    }
  }

  // --- O TEU RAIO-X RESTAURADO COM DADOS AGREGADOS ---
  void _mostrarExplicacao(dynamic itemDaIA) {
    String categoria = itemDaIA['categoria'];
    double total = itemDaIA['totalGastos'];
    double media = itemDaIA['mediaGastos'] ?? 0.0;
    int qtd = itemDaIA['quantidadeTransacoes'] ?? 0;

    IconData icone = Icons.analytics;
    String descricao = "Análise inteligente desta categoria.";

    if (categoria.toLowerCase().contains("fixo") || categoria.toLowerCase().contains("moradia")) icone = Icons.home_work;
    if (categoria.toLowerCase().contains("comida") || categoria.toLowerCase().contains("variável")) icone = Icons.shopping_cart;
    if (categoria.toLowerCase().contains("pessoal") || categoria.toLowerCase().contains("lazer")) icone = Icons.sports_esports;

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
                  Icon(icone, color: CoresApp.yellow, size: 28),
                  const SizedBox(width: 12),
                  Text("Categoria: $categoria", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),
              Text(descricao, style: const TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 25),

              const Text("RAIO-X DOS GASTOS", style: TextStyle(color: CoresApp.textcinza, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
              const SizedBox(height: 15),

              // Aqui a gente mostra o que o backend da Meg manda!
              _buildInfoLinha("Média de Gastos", "R\$ ${media.toStringAsFixed(2).replaceAll('.', ',')}", Icons.calculate_outlined),
              _buildInfoLinha("Qtd. de Transações", "$qtd registradas", Icons.receipt_long),
              const Divider(color: Colors.white24, height: 30),
              _buildInfoLinha("Total Acumulado", "R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}", Icons.account_balance_wallet, isDestaque: true),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Widget auxiliar pro Raio-X
  Widget _buildInfoLinha(String titulo, String valor, IconData icone, {bool isDestaque = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icone, color: Colors.white60, size: 20),
          const SizedBox(width: 12),
          Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 14)),
          const Spacer(),
          Text(
              valor,
              style: TextStyle(
                  color: isDestaque ? CoresApp.red : CoresApp.yellow,
                  fontWeight: FontWeight.bold,
                  fontSize: isDestaque ? 16 : 14
              )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        backgroundColor: CoresApp.background,
        body: Center(child: CircularProgressIndicator(color: CoresApp.yellow)),
      );
    }

    ResultadoOraculo diagnostico = OraculoFinanceiro.avaliarMasmorra(
      rendaFixa: rendaFixaMes,
      rendaExtra: 0.0,
      gastosTotais: gastosTotaisMes,
    );

    return Scaffold(
      backgroundColor: CoresApp.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _carregarDadosReais,
          color: CoresApp.yellow,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Mapa do Tesouro", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: CoresApp.yellow)),
                const SizedBox(height: 25),

                _buildPainelOraculo(diagnostico),

                const SizedBox(height: 35),

                Container(
                  height: 250,
                  decoration: BoxDecoration(color: CoresApp.cardBackground, borderRadius: BorderRadius.circular(20)),
                  child: categoriasDaIA.isEmpty
                      ? const Center(child: Text("Nenhum tesouro gasto ainda...", style: TextStyle(color: Colors.white54)))
                      : PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (event, response) {
                          if (response != null && response.touchedSection != null && event is FlTapUpEvent) {
                            setState(() {
                              touchedIndex = response.touchedSection!.touchedSectionIndex;
                              _mostrarExplicacao(categoriasDaIA[touchedIndex]);
                            });
                          }
                        },
                      ),
                      sectionsSpace: 4,
                      centerSpaceRadius: 50,
                      sections: List.generate(categoriasDaIA.length, (i) {
                        final item = categoriasDaIA[i];
                        final cores = [const Color(0xFF8A2BE2), CoresApp.yellow, CoresApp.red, const Color(0xFF00CED1), Colors.orangeAccent];
                        return _buildSection(i, item['totalGastos'], cores[i % cores.length]);
                      }),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                ...categoriasDaIA.asMap().entries.map((entry) {
                  final i = entry.key;
                  final item = entry.value;
                  final cores = [const Color(0xFF8A2BE2), CoresApp.yellow, CoresApp.red, const Color(0xFF00CED1), Colors.orangeAccent];
                  final porc = (item['totalGastos'] / (gastosTotaisMes > 0 ? gastosTotaisMes : 1)) * 100;

                  return _buildLegenda(
                      "${item['categoria']} (${porc.toStringAsFixed(0)}%)",
                      cores[i % cores.length],
                      item
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PieChartSectionData _buildSection(int index, double valor, Color cor) {
    return PieChartSectionData(
      color: cor,
      value: valor,
      title: 'R\$${valor.toInt()}',
      radius: index == touchedIndex ? 70 : 60,
      titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _buildLegenda(String texto, Color cor, dynamic item) {
    return GestureDetector(
      onTap: () => _mostrarExplicacao(item),
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