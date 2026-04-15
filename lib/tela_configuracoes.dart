import 'package:flutter/material.dart';
import 'package:savings_front/tela_inicial.dart';
import 'package:savings_front/tela_login.dart';
import 'cores_app.dart';

class TelaConfiguracoes extends StatefulWidget {
  const TelaConfiguracoes({super.key});

  @override
  State<TelaConfiguracoes> createState() => _TelaConfiguracoesState();
}

class _TelaConfiguracoesState extends State<TelaConfiguracoes> {
  bool _notificacoes = true;
  bool _modoEscuro = true;
  bool _sonsRpg = false;

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
              // Cabeçalho igual ao que já fizemos...

              // --- SEÇÃO: DADOS DO HERÓI (Editáveis) ---
              const Text("DADOS DA JORNADA", style: TextStyle(color: CoresApp.textMedContrast, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildMenuButton(icon: Icons.work_outline, title: "Alterar Cargo", valor: "Engenheiro de Software"),
              _buildMenuButton(icon: Icons.payments_outlined, title: "Ajustar Salário", valor: "R\$ 2.000,00"),
              _buildMenuButton(icon: Icons.add_circle_outline, title: "Ajustar Renda Extra", valor: "R\$ 0,00"),

              const SizedBox(height: 30),

              // --- SEÇÃO: CONTA ---
              const Text("CONTA", style: TextStyle(color: CoresApp.textMedContrast, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildMenuButton(icon: Icons.person_outline, title: "Perfil do herói"),
              _buildMenuButton(icon: Icons.track_changes, title: "Minhas metas"),
              _buildMenuButton(icon: Icons.emoji_events_outlined, title: "Conquistas"),

              const SizedBox(height: 30),

              // --- SEÇÃO: PREFERÊNCIAS ---
              const Text("PREFERÊNCIAS", style: TextStyle(color: CoresApp.textMedContrast, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildMenuSwitch(
                icon: Icons.notifications_active_outlined,
                title: "Notificações de missão",
                value: _notificacoes,
                onChanged: (val) => setState(() => _notificacoes = val),
              ),

              const SizedBox(height: 40),

              // --- BOTÃO SAIR DA GUILDA ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TelaLogin()));
                  },
                  icon: const Icon(Icons.warning_amber_rounded, color: CoresApp.dangerRed),
                  label: const Text(
                    "Sair da Guilda",
                    style: TextStyle(color: CoresApp.dangerRed, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CoresApp.dangerRed.withOpacity(0.15),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  // Botão de menu simples (com a setinha)
  Widget _buildMenuButton({required IconData icon, required String title, String? valor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: CoresApp.cardBackground, borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: CoresApp.primary, size: 22),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (valor != null) Text(valor, style: const TextStyle(color: CoresApp.textMedContrast, fontSize: 12)),
            const SizedBox(width: 5),
            const Icon(Icons.chevron_right, color: CoresApp.textMedContrast, size: 18),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  // Botão de menu com o Switch (liga/desliga)
  Widget _buildMenuSwitch({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: CoresApp.cardBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: CoresApp.textMedContrast, size: 24),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.black,
          activeTrackColor: CoresApp.primary,
          inactiveThumbColor: CoresApp.textMedContrast,
          inactiveTrackColor: CoresApp.background,
        ),
      ),
    );
  }
}