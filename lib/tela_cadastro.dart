import 'package:flutter/material.dart';
import 'package:savings_front/tela_configuracao_inicial.dart';
import 'cores_app.dart';
import 'tela_login.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  String classeSelecionada = 'Poupador Épico';
  final List<String> classes = ['Poupador Épico', 'Guerreiro do Orçamento', 'Mago dos Investimentos'];

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: CoresApp.textPrimaryVibrant),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TelaLogin())),
        ),
        iconTheme: const IconThemeData(color: CoresApp.primary),
        title: const Text("Nova Jornada", style: TextStyle(color: CoresApp.primary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                "Escolha sua Identidade",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)
            ),
            const SizedBox(height: 20),

            // --- SELEÇÃO DE CLASSE ---
            const Text("Sua Classe de Herói:", style: TextStyle(color: CoresApp.textMedContrast)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: CoresApp.cardBackground,
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: classeSelecionada,
                  dropdownColor: CoresApp.cardBackground,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  icon: const Icon(Icons.keyboard_arrow_down, color: CoresApp.primary),
                  isExpanded: true,
                  items: classes.map((String classe) {
                    return DropdownMenuItem(value: classe, child: Text(classe));
                  }).toList(),
                  onChanged: (String? novaClasse) {
                    setState(() { classeSelecionada = novaClasse!; });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- FORMULÁRIO DE CADASTRO ---
            _buildRPGInput(
              controller: _nomeController,
              label: "Nome do Herói",
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 20),

            _buildRPGInput(
              controller: _emailController,
              label: "E-mail de Herói",
              icon: Icons.alternate_email,
            ),
            const SizedBox(height: 20),

            _buildRPGInput(
              controller: _senhaController,
              label: "Criar Senha Mística",
              icon: Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 20),

            _buildRPGInput(
              controller: _confirmarSenhaController,
              label: "Confirmar Senha",
              icon: Icons.lock_reset_outlined,
              isPassword: true,
            ),

            const SizedBox(height: 40),

            // --- BOTÃO DE CONFIRMAR CADASTRO ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  final nome = _nomeController.text.trim();
                  final email = _emailController.text.trim();
                  final senha = _senhaController.text.trim();
                  final confirma = _confirmarSenhaController.text.trim();

                  if (nome.isEmpty || email.isEmpty || senha.isEmpty || confirma.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: CoresApp.dangerRed,
                        behavior: SnackBarBehavior.floating,
                        content: Row(
                          children: const [
                            Icon(Icons.warning_amber_rounded, color: Colors.white),
                            SizedBox(width: 10),
                            Expanded(child: Text("Faltou tinta no pergaminho! Preencha tudo.", style: TextStyle(color: Colors.white))),
                          ],
                        ),
                      ),
                    );
                    return;
                  }

                  if (senha != confirma) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.orange,
                        behavior: SnackBarBehavior.floating,
                        content: Row(
                          children: const [
                            Icon(Icons.lock_clock, color: Colors.white),
                            SizedBox(width: 10),
                            Expanded(child: Text("As senhas não batem! Confere aí as runas mágicas.", style: TextStyle(color: Colors.white))),
                          ],
                        ),
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TelaConfiguracaoInicial()),
                  );
                },

                style: ElevatedButton.styleFrom(
                    backgroundColor: CoresApp.textPrimaryVibrant),

                child: const Text(
                    "FORJAR MINHA CONTA",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- O MESMO WIDGET DE INPUT DA TELA DE LOGIN ---
  Widget _buildRPGInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: CoresApp.textMedContrast),
        prefixIcon: Icon(icon, color: CoresApp.primary),
        filled: true,
        fillColor: CoresApp.cardBackground,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: CoresApp.primary, width: 2),
        ),
      ),
    );
  }
}