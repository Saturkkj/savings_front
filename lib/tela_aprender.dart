import 'package:flutter/material.dart';
import 'cores_app.dart';

class TelaAprender extends StatelessWidget {
  const TelaAprender({super.key});

  @override
  Widget build(BuildContext context) {
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
                      const Icon(Icons.menu_book, color: CoresApp.yellow, size: 28),
                      const SizedBox(width: 10),
                      Text(
                        "Grimório",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: CoresApp.yellow,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.diamond_outlined, color: Colors.cyanAccent, size: 18),
                      const SizedBox(width: 5),
                      const Text("340 gemas", style: TextStyle(color: CoresApp.textcinza)),
                      const SizedBox(width: 15),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // --- MISSÃO DO DIA (DESTAQUE) ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CoresApp.rosaRoxo.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: CoresApp.rosaRoxo.withOpacity(0.5), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: CoresApp.yellow,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text(
                        "🔥 MISSÃO DO DIA",
                        style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "O Segredo dos Juros Compostos",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Aprenda como seu dinheiro pode trabalhar por você.",
                      style: TextStyle(color: CoresApp.textcinza, fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "+80 XP · 5 min",
                          style: TextStyle(color: CoresApp.textcinza, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CoresApp.yellow,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          icon: const Icon(Icons.play_arrow, size: 18),
                          label: const Text("Iniciar", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // --- TRILHAS DE CONHECIMENTO ---
              Text(
                "TRILHAS DE CONHECIMENTO",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.6),
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 15),

              // Lista das Trilhas
              _buildTrilhaCard(
                icon: Icons.shield,
                title: "Orçamento Básico",
                subtitle: "+40 XP · 3 aulas",
                progress: 0.8,
                statusText: "",
              ),
              _buildTrilhaCard(
                icon: Icons.savings, // O porquinho
                title: "Investimento Inicial",
                subtitle: "+60 XP · 5 aulas",
                progress: 0.3,
                statusText: "",
              ),
              _buildTrilhaCard(
                icon: Icons.map,
                title: "Metas Financeiras",
                subtitle: "+30 XP · 2 aulas",
                progress: 1.0, // Completo
                statusText: "✓ Completo",
                isComplete: true,
              ),

              // Trilhas Bloqueadas (A Magia do RPG)
              _buildTrilhaBloqueadaCard(icon: Icons.auto_awesome, title: "Renda Extra"),
              _buildTrilhaBloqueadaCard(icon: Icons.account_balance, title: "Tesouro Direto"),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  // Card de Trilha Ativa ou Completa
  Widget _buildTrilhaCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required double progress,
    required String statusText,
    bool isComplete = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CoresApp.cardBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    if (isComplete)
                      Text(statusText, style: const TextStyle(color: CoresApp.greenWater, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                if (!isComplete)
                  Text(subtitle, style: const TextStyle(color: CoresApp.textcinza, fontSize: 12)),
                const SizedBox(height: 10),

                // Barra de Progresso Customizada
                if (!isComplete)
                  Stack(
                    children: [
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: CoresApp.background,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: CoresApp.yellow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Card de Trilha Bloqueada (Cinza/Roxo escuro)
  Widget _buildTrilhaBloqueadaCard({required IconData icon, required String title}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CoresApp.cardBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: CoresApp.textcinza.withOpacity(0.5), size: 28),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: CoresApp.textcinza.withOpacity(0.7), fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.lock, size: 12, color: CoresApp.textcinza.withOpacity(0.5)),
                  const SizedBox(width: 4),
                  Text("Bloqueado", style: TextStyle(color: CoresApp.textcinza.withOpacity(0.5), fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}