import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'cores_app.dart';
import 'tela_navegacao.dart';
import 'api/auth_api.dart'; // O nosso mensageiro

class TelaConfiguracaoInicial extends StatefulWidget {
  final String nomeHeroi;
  final String emailHeroi;
  final String senhaHeroi;
  final String classeHeroi;

  const TelaConfiguracaoInicial({
    super.key,
    required this.nomeHeroi,
    required this.emailHeroi,
    required this.senhaHeroi,
    required this.classeHeroi
  });

  @override
  State<TelaConfiguracaoInicial> createState() => _TelaConfiguracaoInicialState();
}

class _TelaConfiguracaoInicialState extends State<TelaConfiguracaoInicial> {
  final _salarioController = TextEditingController();
  final _rendaExtraController = TextEditingController();
  final _cargoController = TextEditingController();

  final _storage = const FlutterSecureStorage();
  bool _estaCarregando = false;

  Future<void> _finalizarJornada() async {
    setState(() => _estaCarregando = true);

    // 1. Calcula a renda total substituindo a vírgula do brasileiro pelo ponto do Dart
    double salario = double.tryParse(_salarioController.text.replaceAll(',', '.')) ?? 0.0;
    double extra = double.tryParse(_rendaExtraController.text.replaceAll(',', '.')) ?? 0.0;
    double rendaTotal = salario + extra;

    if (rendaTotal <= 0) {
      setState(() => _estaCarregando = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("O herói precisa de moedas para começar!"), backgroundColor: Colors.redAccent));
      return;
    }

    // 2. Manda pro servidor da Meg cadastrar
    bool sucessoCadastro = await AuthAPI().registrarUsuario(
        widget.nomeHeroi, widget.emailHeroi, widget.senhaHeroi, rendaTotal, widget.classeHeroi
    );

    if (sucessoCadastro) {
      // 3. Cadastrou? Já loga e pega o JWT!
      bool sucessoLogin = await AuthAPI().login(widget.emailHeroi, widget.senhaHeroi);

      if (sucessoLogin) {
        // 4. Guarda tudo no cofre!
        await _storage.write(key: 'renda_total', value: rendaTotal.toString());
        await _storage.write(key: 'nome_heroi', value: widget.nomeHeroi);
        await _storage.write(key: 'cargo_heroi', value: _cargoController.text.isNotEmpty ? _cargoController.text : "Aventureiro");

        setState(() => _estaCarregando = false);
        if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TelaNavegacao()));
      }
    } else {
      setState(() => _estaCarregando = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Caô ao forjar o personagem no servidor!"), backgroundColor: Colors.redAccent));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text("Prepare seu Inventário", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: CoresApp.yellow)),
              const SizedBox(height: 10),
              const Text("Para o Oráculo te guiar, precisamos saber o tamanho do seu tesouro mensal.", style: TextStyle(color: CoresApp.textcinza, fontSize: 14)),
              const SizedBox(height: 40),

              _buildInputRPG(controller: _cargoController, label: "Seu Cargo / Ocupação", icon: Icons.work_outline, hint: "Ex: Desenvolvedor, Estudante..."),
              const SizedBox(height: 20),
              _buildInputRPG(controller: _salarioController, label: "Salário Mensal (Renda Fixa)", icon: Icons.account_balance_wallet_outlined, hint: "0,00", isNumber: true),
              const SizedBox(height: 20),
              _buildInputRPG(controller: _rendaExtraController, label: "Renda Extra (Opcional)", icon: Icons.add_chart, hint: "0,00", isNumber: true),

              const SizedBox(height: 50),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _estaCarregando ? null : _finalizarJornada,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CoresApp.yellow,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: _estaCarregando
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text("COMEÇAR JORNADA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputRPG({required TextEditingController controller, required String label, required IconData icon, required String hint, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: CoresApp.textcinza.withOpacity(0.5)),
            prefixIcon: Icon(icon, color: CoresApp.yellow),
            filled: true,
            fillColor: CoresApp.cardBackground,
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.transparent)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: CoresApp.yellow.withOpacity(0.5))),
          ),
        ),
      ],
    );
  }
}