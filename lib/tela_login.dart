import 'package:flutter/material.dart';
import 'package:savings_front/tela_navegacao.dart';
import 'tela_recuperar_senha.dart';
import 'cores_app.dart';
import 'tela_cadastro.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  void _entrarNaGuilda() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TelaNavegacao()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Image.asset(
                'assets/images/image.png', height: 200),
            Text("Seu app de Educação Financeira", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CoresApp.textcinza)),
            const SizedBox(height: 50),

            // --- Campo de E-mail ---
            _buildRPGInput(
              controller: _emailController,
              label: "E-mail de herói",
              icon: Icons.alternate_email,
            ),
            const SizedBox(height: 20),

            // --- Campo de Senha ---
            _buildRPGInput(
              controller: _senhaController,
              label: "Senha mística",
              icon: Icons.lock_outline,
              isPassword: true,
            ),

            // --- Esqueci a Senha (O Feitiço) ---
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TelaRecuperarSenha()),
                  );
                },
                child: const Text(
                  "Esqueceu o feitiço?",
                  style: TextStyle(color: CoresApp.yellow, fontSize: 12),
                ),
              ),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  final email = _emailController.text.trim();
                  final senha = _senhaController.text.trim();

                  if (email.isEmpty || senha.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: CoresApp.red,
                        behavior: SnackBarBehavior.floating,
                        content: Row(
                          children: const [
                            Icon(Icons.error_outline, color: Colors.white),
                            SizedBox(width: 10),
                            Expanded(child: Text("Qual foi, herói? Preenche e-mail e senha pra entrar!", style: TextStyle(color: Colors.white))),
                          ],
                        ),
                      ),
                    );
                    return;
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const TelaNavegacao()),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: CoresApp.textYellow),

                child: const Text("ENTRAR NA GUILDA", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TelaCadastro()));
              },
              child: const Text("Novo por aqui? Criar conta de herói", style: TextStyle(color: CoresApp.textcinza)),
            ),
          ],
        ),
      ),
    );
  }

  // Widget de Input Customizado no Estilo do App
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
        labelStyle: const TextStyle(color: CoresApp.textcinza),
        prefixIcon: Icon(icon, color: CoresApp.yellow),
        filled: true,
        fillColor: CoresApp.cardBackground,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: CoresApp.yellow, width: 2),
        ),
      ),
    );
  }
}