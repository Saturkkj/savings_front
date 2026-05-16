import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:savings_front/tela_login.dart';
import 'cores_app.dart';

class TelaConfiguracoes extends StatefulWidget {
  const TelaConfiguracoes({super.key});

  @override
  State<TelaConfiguracoes> createState() => _TelaConfiguracoesState();
}

class _TelaConfiguracoesState extends State<TelaConfiguracoes> {
  bool _notificacoes = true;
  final _storage = const FlutterSecureStorage();

  String nomeHeroi = "Carregando...";
  String cargoHeroi = "Carregando...";
  String rendaTotalStr = "R\$ 0,00";

  @override
  void initState() {
    super.initState();
    _carregarDadosDoCofre();
  }

  // Puxa as infos reais do celular
  Future<void> _carregarDadosDoCofre() async {
    String? nome = await _storage.read(key: 'nome_heroi');
    String? cargo = await _storage.read(key: 'cargo_heroi');
    String? rendaStr = await _storage.read(key: 'renda_total');

    setState(() {
      nomeHeroi = nome ?? "Herói Desconhecido";
      cargoHeroi = cargo ?? "Aventureiro";
      if (rendaStr != null) {
        double renda = double.parse(rendaStr);
        rendaTotalStr = "R\$ ${renda.toStringAsFixed(2).replaceAll('.', ',')}";
      }
    });
  }

  // --- 🔮 MAGIA NOVA: POP-UP DE EDIÇÃO ---
  Future<void> _editarDado(String titulo, String chaveCofre, bool isNumber) async {
    final TextEditingController controller = TextEditingController();

    // Pega o valor que já tá salvo pra colocar no campo de texto
    String? valorAtual = await _storage.read(key: chaveCofre);
    if (valorAtual != null && !isNumber) controller.text = valorAtual;

    if (!mounted) return;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: CoresApp.cardBackground,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: CoresApp.yellow)),
            title: Text(titulo, style: const TextStyle(color: CoresApp.yellow, fontWeight: FontWeight.bold)),
            content: TextField(
              controller: controller,
              keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: isNumber ? "Digite o novo valor (ex: 2500,00)" : "Digite aqui...",
                hintStyle: TextStyle(color: CoresApp.textcinza.withOpacity(0.5)),
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: CoresApp.textcinza)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: CoresApp.yellow)),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar", style: TextStyle(color: CoresApp.textcinza)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: CoresApp.yellow),
                onPressed: () async {
                  String novoValor = controller.text.trim();
                  if (novoValor.isNotEmpty) {
                    // Se for número, troca a vírgula por ponto pro Dart não chorar
                    if (isNumber) novoValor = novoValor.replaceAll(',', '.');

                    // Salva o ouro novo no cofre!
                    await _storage.write(key: chaveCofre, value: novoValor);

                    if (mounted) {
                      Navigator.pop(context);
                      _carregarDadosDoCofre(); // Recarrega a tela na hora!
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Inventário atualizado com sucesso!"), backgroundColor: Colors.green),
                      );
                    }
                  }
                },
                child: const Text("Salvar", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        }
    );
  }

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
              // --- SEÇÃO: DADOS DO HERÓI (Editáveis) ---
              const Text("DADOS DA JORNADA", style: TextStyle(color: CoresApp.textcinza, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              // AGORA ESSES BOTÕES CHAMAM A FUNÇÃO DE EDITAR!
              _buildMenuButton(
                icon: Icons.person_outline,
                title: "Alterar Nome do Herói",
                valor: nomeHeroi,
                onTap: () => _editarDado("Novo Nome", 'nome_heroi', false),
              ),
              _buildMenuButton(
                icon: Icons.work_outline,
                title: "Alterar Cargo",
                valor: cargoHeroi,
                onTap: () => _editarDado("Novo Cargo", 'cargo_heroi', false),
              ),
              _buildMenuButton(
                icon: Icons.payments_outlined,
                title: "Ajustar Renda Total",
                valor: rendaTotalStr,
                onTap: () => _editarDado("Nova Renda Mensal", 'renda_total', true),
              ),

              const SizedBox(height: 30),

              // --- SEÇÃO: CONTA ---
              const Text("CONTA", style: TextStyle(color: CoresApp.textcinza, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildMenuButton(icon: Icons.track_changes, title: "Minhas metas"),
              _buildMenuButton(icon: Icons.emoji_events_outlined, title: "Conquistas"),

              const SizedBox(height: 30),

              // --- SEÇÃO: PREFERÊNCIAS ---
              const Text("PREFERÊNCIAS", style: TextStyle(color: CoresApp.textcinza, fontSize: 12, fontWeight: FontWeight.bold)),
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
                  onPressed: () async {
                    await _storage.deleteAll(); // Limpa o cofre ao sair!
                    if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TelaLogin()));
                  },
                  icon: const Icon(Icons.warning_amber_rounded, color: CoresApp.red),
                  label: const Text(
                    "Sair da Guilda",
                    style: TextStyle(color: CoresApp.red, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CoresApp.red.withOpacity(0.15),
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

  // Botão de menu simples (AGORA COM SUPORTE A ONTAP)
  Widget _buildMenuButton({required IconData icon, required String title, String? valor, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: CoresApp.cardBackground, borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: CoresApp.yellow, size: 22),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (valor != null) Text(valor, style: const TextStyle(color: CoresApp.textcinza, fontSize: 12)),
            const SizedBox(width: 5),
            const Icon(Icons.edit, color: CoresApp.textcinza, size: 16), // Troquei a setinha pro ícone de lápis pra dar a visão que dá pra editar!
          ],
        ),
        onTap: onTap ?? () {},
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
        leading: Icon(icon, color: CoresApp.textcinza, size: 24),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.black,
          activeTrackColor: CoresApp.yellow,
          inactiveThumbColor: CoresApp.textcinza,
          inactiveTrackColor: CoresApp.background,
        ),
      ),
    );
  }
}