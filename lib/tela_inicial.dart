import 'package:flutter/material.dart';
import 'cores_app.dart';
import 'oraculo_financeiro.dart';
import 'tela_registrar_transacao.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    // puxar esses valores do teu banco de dados)
    final diagnostico = OraculoFinanceiro.avaliarMasmorra(
      rendaFixa: 2000.0,
      rendaExtra: 0.0,
      gastosTotais: 1000.0,
    );

    return Scaffold(
      backgroundColor: CoresApp.background,

      // --- O BOTÃO FLUTUANTE (Para registrar novos gastos/investimentos) ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TelaRegistrarTransacao()),
          );
        },
        backgroundColor: CoresApp.primary, // Amarelo Ouro
        elevation: 8,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.black, size: 30),
      ),

      // --- CORPO DA TELA ---
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- CABEÇALHO: NOME DO APP E MENU ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shield, color: CoresApp.primary, size: 28), // Troquei pra shield pra não dar erro de ícone
                      const SizedBox(width: 10),
                      const Text(
                        "Savings",
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

              const SizedBox(height: 25),

              // --- STATUS DO HERÓI (NÍVEL E XP) ---
              const Text(
                "Olá, João Herói!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 5),
              const Text(
                "EXP — Nível 7 · Guardião Fiscal",
                style: TextStyle(color: CoresApp.textMedContrast, fontSize: 12),
              ),
              const SizedBox(height: 12),

              // Barra de Progresso de XP
              Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: CoresApp.cardBackground,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.7, // 70% de XP pro próximo nível
                          child: Container(
                            height: 12,
                            decoration: BoxDecoration(
                              color: CoresApp.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: CoresApp.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Nv. 7",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // ==========================================
              // CARD DO ORÁCULO (Resumo rápido do Status)
              // ==========================================
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: CoresApp.cardBackground,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: diagnostico.cor.withOpacity(0.5), width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: diagnostico.cor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(diagnostico.icone, color: diagnostico.cor, size: 24),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Status: ${diagnostico.status}",
                            style: TextStyle(
                                color: diagnostico.cor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            diagnostico.dica,
                            style: const TextStyle(color: CoresApp.textMedContrast, fontSize: 11),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: CoresApp.textMedContrast, size: 20),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // --- CARD PRINCIPAL: TESOURO DO HERÓI (SALDO) ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: CoresApp.primary,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: CoresApp.primary.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "TESOURO DO HERÓI",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "R\$ 1.240,00",
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Investimento até agora · +R\$180 vs mês anterior",
                      style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // --- MISSÕES ATIVAS ---
              Row(
                children: [
                  const Icon(Icons.flag, color: CoresApp.primary, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    "MISSÕES ATIVAS",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: CoresApp.primary,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Lista de Missões
              _buildMissionCard("Poupar R\$200 até o fim do mês", "+50 XP"),
              _buildMissionCard("Registrar 5 gastos seguidos", "+20 XP"),
              _buildMissionCard("Completar lição de orçamento", "+30 XP"),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET AUXILIAR PARA OS CARDS DE MISSÃO
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
            decoration: BoxDecoration(
              color: CoresApp.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Text(
            xpValue,
            style: const TextStyle(
              color: CoresApp.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}