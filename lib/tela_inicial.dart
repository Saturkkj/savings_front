import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'cores_app.dart';
import 'oraculo_financeiro.dart';
import 'tela_registrar_transacao.dart';
import 'api/recomendacao_api.dart';
import 'api/analise_api.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final _storage = const FlutterSecureStorage();

  double _rendaRealDoUsuario = 0.0;
  double _gastosTotaisReais = 0.0;
  String _nomeDoHeroi = "Herói";
  List<dynamic> _anomaliasRecentes = [];

  bool _carregandoTela = true;
  bool _carregandoIA = true;

  String _conselhoDaIA = "O Oráculo está meditando sobre seu tesouro...";
  bool _temDividaIA = false;

  @override
  void initState() {
    super.initState();
    _carregarDadosDaMasmorra();
  }

  Future<void> _carregarDadosDaMasmorra() async {
    setState(() {
      _carregandoTela = true;
      _carregandoIA = true;
    });

    String? rendaSalva = await _storage.read(key: 'renda_total');
    String? nomeSalvo = await _storage.read(key: 'nome_heroi');
    final relatorio = await AnaliseAPI().buscarRelatorioCompleto();

    if (mounted) {
      setState(() {
        if (rendaSalva != null) _rendaRealDoUsuario = double.parse(rendaSalva);
        if (nomeSalvo != null) _nomeDoHeroi = nomeSalvo;

        if (relatorio != null) {
          List<dynamic> categorias = relatorio['mediasPorCategoria'] ?? [];

          _gastosTotaisReais = categorias.fold(0.0, (soma, item) {
            double valorDaCategoria = double.tryParse(item['totalGastos'].toString()) ?? 0.0;
            return soma + valorDaCategoria;
          });

          if (relatorio['anomalias'] != null && relatorio['anomalias']['anomalias'] != null) {
            _anomaliasRecentes = relatorio['anomalias']['anomalias'];
          }
        }
        _carregandoTela = false;
      });
    }

    final resultadoIA = await RecomendacaoAPI().buscarConselhoIA();

    if (mounted) {
      setState(() {
        if (resultadoIA != null) {
          _conselhoDaIA = resultadoIA['recomendacaoIA'] ?? "O Oráculo está em silêncio hoje.";
          _temDividaIA = resultadoIA['modoDivida'] ?? false;
        } else {
          _conselhoDaIA = "Error, tente novamente mais tarde.";
        }
        _carregandoIA = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregandoTela) {
      return const Scaffold(
        backgroundColor: CoresApp.background,
        body: Center(child: CircularProgressIndicator(color: CoresApp.yellow)),
      );
    }

    final diagnosticoLocal = OraculoFinanceiro.avaliarMasmorra(
      rendaFixa: _rendaRealDoUsuario,
      rendaExtra: 0.0,
      gastosTotais: _gastosTotaisReais,
    );

    return Scaffold(
      backgroundColor: CoresApp.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push(context, MaterialPageRoute(builder: (context) => const TelaRegistrarTransacao()));
          if (resultado == true) {
            _carregarDadosDaMasmorra();
          }
        },
        backgroundColor: CoresApp.yellow,
        elevation: 8,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.black, size: 30),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: CoresApp.yellow,
          onRefresh: _carregarDadosDaMasmorra,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.shield, color: CoresApp.yellow, size: 28),
                        SizedBox(width: 10),
                        Text("Savings RPG", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: CoresApp.yellow)),
                      ],
                    ),
                    const Icon(Icons.more_horiz, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 25),

                Text("Olá, $_nomeDoHeroi!", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const Text("EXP — Nível 7 · Guardião Fiscal", style: TextStyle(color: CoresApp.textcinza, fontSize: 12)),
                const SizedBox(height: 12),
                _buildBarraXP(),

                const SizedBox(height: 25),

                // --- O CARD DO ORÁCULO AUTOMÁTICO ---
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: CoresApp.cardBackground,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: _temDividaIA ? CoresApp.red.withOpacity(0.6) : diagnosticoLocal.cor.withOpacity(0.5),
                        width: 1.5
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                              _temDividaIA ? Icons.warning_amber_rounded : Icons.auto_awesome,
                              color: _temDividaIA ? CoresApp.red : diagnosticoLocal.cor,
                              size: 24
                          ),
                          const SizedBox(width: 10),
                          Text(
                              _temDividaIA ? "Profecia Sombria" : "Conselho do Oráculo",
                              style: TextStyle(
                                  color: _temDividaIA ? CoresApp.red : diagnosticoLocal.cor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              )
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      _carregandoIA
                          ? const Center(
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: CircularProgressIndicator(color: CoresApp.yellow)
                          )
                      )
                          : Text(
                          _conselhoDaIA,
                          style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5)
                      ),

                      const SizedBox(height: 15),
                      const Divider(color: Colors.white24, height: 1),
                      const SizedBox(height: 10),

                      Text(
                          "Você comprometeu ${diagnosticoLocal.porcentagemGasta.toStringAsFixed(1)}% do seu tesouro este mês.",
                          style: const TextStyle(color: CoresApp.textcinza, fontSize: 11, fontStyle: FontStyle.italic)
                      ),
                    ],
                  ),
                ),
                // --- FIM DO NOVO CARD DO ORÁCULO ---

                const SizedBox(height: 35),

                Row(
                  children: const [
                    Icon(Icons.flag, color: CoresApp.yellow, size: 20),
                    SizedBox(width: 8),
                    Text("MISSÕES ATIVAS", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CoresApp.yellow, letterSpacing: 1.1)),
                  ],
                ),
                const SizedBox(height: 15),
                _buildMissionCard("Poupar R\$200 até o fim do mês", "+50 XP"),
                _buildMissionCard("Completar lição de orçamento", "+30 XP"),

                const SizedBox(height: 35),

                const Text("ALERTAS DA TAVERNA (ANOMALIAS)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.1)),
                const SizedBox(height: 15),

                if (_anomaliasRecentes.isEmpty)
                  const Text("Nenhum gasto fora do comum. O tesouro está seguro!", style: TextStyle(color: CoresApp.textcinza, fontStyle: FontStyle.italic))
                else
                  ..._anomaliasRecentes.map((anomalia) {
                    return _buildTransacaoItem(
                        anomalia['descricao'] ?? "Gasto Misterioso",
                        "R\$ ${anomalia['valor'].toStringAsFixed(2).replaceAll('.', ',')}",
                        Icons.warning_amber_rounded,
                        anomalia['categoria'] ?? "Desconhecido"
                    );
                  }).toList(),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransacaoItem(String nome, String valor, IconData icone, String categoria) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: CoresApp.cardBackground,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: CoresApp.red.withOpacity(0.3))
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: CoresApp.red.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icone, color: CoresApp.red, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nome, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Text(categoria, style: const TextStyle(color: CoresApp.textcinza, fontSize: 10)),
              ],
            ),
          ),
          Text(valor, style: const TextStyle(color: CoresApp.red, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildBarraXP() {
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(height: 10, decoration: BoxDecoration(color: CoresApp.cardBackground, borderRadius: BorderRadius.circular(10))),
              FractionallySizedBox(widthFactor: 0.7, child: Container(height: 10, decoration: BoxDecoration(color: CoresApp.yellow, borderRadius: BorderRadius.circular(10)))),
            ],
          ),
        ),
        const SizedBox(width: 10),
        const Text("Nv. 7", style: TextStyle(color: CoresApp.yellow, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  Widget _buildMissionCard(String title, String xpValue) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CoresApp.cardBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 4, height: 30,
            decoration: BoxDecoration(color: CoresApp.yellow, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 15),
          Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14))),
          Text(xpValue, style: const TextStyle(color: CoresApp.yellow, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}