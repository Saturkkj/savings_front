import 'package:flutter/material.dart';
import 'cores_app.dart';
import 'oraculo_financeiro.dart';
import 'tela_registrar_transacao.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    // --- SIMULAÇÃO DA MISSÃO ---
    const double rendaFixa = 2000.0;
    const double rendaExtra = 0.0;
    const double gastosAtuais = 1000.0;

    final diagnostico = OraculoFinanceiro.avaliarMasmorra(
      rendaFixa: rendaFixa,
      rendaExtra: rendaExtra,
      gastosTotais: gastosAtuais,
    );

    return Scaffold(
      backgroundColor: CoresApp.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const TelaRegistrarTransacao()));
        },
        backgroundColor: CoresApp.primary,
        elevation: 8,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.black, size: 30),
      ),
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
                      const Icon(Icons.shield, color: CoresApp.primary, size: 28),
                      const SizedBox(width: 10),
                      const Text("Savings RPG", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: CoresApp.primary)),
                    ],
                  ),
                  const Icon(Icons.more_horiz, color: Colors.white),
                ],
              ),
              const SizedBox(height: 25),

              // --- STATUS DO HERÓI ---
              const Text("Olá, João Herói!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const Text("EXP — Nível 7 · Guardião Fiscal", style: TextStyle(color: CoresApp.textMedContrast, fontSize: 12)),
              const SizedBox(height: 12),
              _buildBarraXP(),

              const SizedBox(height: 25),

              // --- CARD DO ORÁCULO (50% DE GASTO = ATENÇÃO) ---
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: CoresApp.cardBackground,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: diagnostico.cor.withOpacity(0.5), width: 1),
                ),
                child: Row(
                  children: [
                    Icon(diagnostico.icone, color: diagnostico.cor, size: 30),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Status: ${diagnostico.status}", style: TextStyle(color: diagnostico.cor, fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(diagnostico.dica, style: const TextStyle(color: CoresApp.textMedContrast, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              Row(
                children: [
                  const Icon(Icons.flag, color: CoresApp.primary, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    "MISSÕES ATIVAS",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CoresApp.primary, letterSpacing: 1.1),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildMissionCard("Poupar R\$200 até o fim do mês", "+50 XP"),
              _buildMissionCard("Registrar 5 gastos seguidos", "+20 XP"),
              _buildMissionCard("Completar lição de orçamento", "+30 XP"),

              const SizedBox(height: 35),

              // --- ÚLTIMAS ATIVIDADES (O RAIO-X RÁPIDO) ---
              const Text("ÚLTIMAS ATIVIDADES", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.1)),
              const SizedBox(height: 15),
              _buildTransacaoItem("Aluguel da Taverna", "R\$ 300,00", Icons.house, "Fixos"),
              _buildTransacaoItem("Mercado das Poções", "R\$ 180,00", Icons.shopping_cart, "Variáveis"),
              _buildTransacaoItem("Pizza", "R\$ 80,00", Icons.local_pizza, "Pessoais"),

              const SizedBox(height: 20),
              Center(
                child: TextButton(
                    onPressed: () {},
                    child: const Text("Ver todo o histórico", style: TextStyle(color: CoresApp.primary, fontSize: 13))
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET AUXILIAR: ITEM DE TRANSAÇÃO
  Widget _buildTransacaoItem(String nome, String valor, IconData icone, String categoria) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: CoresApp.cardBackground, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: CoresApp.background, borderRadius: BorderRadius.circular(10)),
            child: Icon(icone, color: Colors.white70, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nome, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Text(categoria, style: const TextStyle(color: CoresApp.textMedContrast, fontSize: 10)),
              ],
            ),
          ),
          Text("- $valor", style: const TextStyle(color: CoresApp.dangerRed, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  // WIDGET AUXILIAR: BARRA DE XP
  Widget _buildBarraXP() {
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(height: 10, decoration: BoxDecoration(color: CoresApp.cardBackground, borderRadius: BorderRadius.circular(10))),
              FractionallySizedBox(widthFactor: 0.7, child: Container(height: 10, decoration: BoxDecoration(color: CoresApp.primary, borderRadius: BorderRadius.circular(10)))),
            ],
          ),
        ),
        const SizedBox(width: 10),
        const Text("Nv. 7", style: TextStyle(color: CoresApp.primary, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  // WIDGET AUXILIAR: CARDS DE MISSÃO
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
            width: 4,
            height: 30,
            decoration: BoxDecoration(color: CoresApp.primary, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 15),
          Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14))),
          Text(xpValue, style: const TextStyle(color: CoresApp.primary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}