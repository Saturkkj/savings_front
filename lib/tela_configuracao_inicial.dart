import 'package:flutter/material.dart';
import 'cores_app.dart';
import 'tela_navegacao.dart';

class TelaConfiguracaoInicial extends StatefulWidget {
  const TelaConfiguracaoInicial({super.key});

  @override
  State<TelaConfiguracaoInicial> createState() => _TelaConfiguracaoInicialState();
}

class _TelaConfiguracaoInicialState extends State<TelaConfiguracaoInicial> {
  final _salarioController = TextEditingController();
  final _rendaExtraController = TextEditingController();
  final _cargoController = TextEditingController();

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
              const Text(
                "Prepare seu Inventário",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: CoresApp.yellow),
              ),
              const SizedBox(height: 10),
              const Text(
                "Para o Oráculo te guiar, precisamos saber o tamanho do seu tesouro mensal.",
                style: TextStyle(color: CoresApp.textcinza, fontSize: 14),
              ),
              const SizedBox(height: 40),

              _buildInputRPG(
                controller: _cargoController,
                label: "Seu Cargo / Ocupação",
                icon: Icons.work_outline,
                hint: "Ex: Desenvolvedor, Estudante...",
              ),
              const SizedBox(height: 20),

              _buildInputRPG(
                controller: _salarioController,
                label: "Salário Mensal (Renda Fixa)",
                icon: Icons.account_balance_wallet_outlined,
                hint: "0,00",
                isNumber: true,
              ),
              const SizedBox(height: 20),

              _buildInputRPG(
                controller: _rendaExtraController,
                label: "Renda Extra (Opcional)",
                icon: Icons.add_chart,
                hint: "0,00",
                isNumber: true,
              ),

              const SizedBox(height: 50),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Aqui salva no banco
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const TelaNavegacao()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CoresApp.yellow,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("COMEÇAR JORNADA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputRPG({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: CoresApp.textcinza.withOpacity(0.5)),
            prefixIcon: Icon(icon, color: CoresApp.yellow),
            filled: true,
            fillColor: CoresApp.cardBackground,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: CoresApp.yellow.withOpacity(0.5)),
            ),
          ),
        ),
      ],
    );
  }
}