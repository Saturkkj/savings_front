import 'package:flutter/material.dart';
import 'cores_app.dart';

class TelaRecuperarSenha extends StatefulWidget {
  const TelaRecuperarSenha({super.key});

  @override
  State<TelaRecuperarSenha> createState() => _TelaRecuperarSenhaState();
}

class _TelaRecuperarSenhaState extends State<TelaRecuperarSenha> {
  final _emailController = TextEditingController();
  bool _feiticoEnviado = false;

  @override
  void dispose() {
    _emailController.dispose();
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
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CoresApp.cardBackground,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          children: [
            // --- Ícone de Cadeado ---
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: CoresApp.cardBackground,
                    shape: BoxShape.circle,
                  ),
                ),
                const Icon(Icons.lock, size: 50, color: Colors.white),
                // O detalhe do raiozinho no cadeado
                Positioned(
                  child: Icon(Icons.flash_on, size: 20, color: CoresApp.primary),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // --- Títulos ---
            const Text(
              "Recuperar Acesso",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              "Informe seu e-mail de herói e enviaremos um feitiço de recuperação.",
              textAlign: TextAlign.center,
              style: TextStyle(color: CoresApp.textMedContrast, fontSize: 14),
            ),

            const SizedBox(height: 20),
            Container(width: 40, height: 3, color: CoresApp.primary),
            const SizedBox(height: 30),

            // --- COMO FUNCIONA (Passo a Passo) ---
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "COMO FUNCIONA",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.6),
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildPasso(numero: "1", titulo: "Digite seu e-mail", subtitulo: "O e-mail cadastrado na sua guilda", mostrarLinha: true),
            _buildPasso(numero: "2", titulo: "Receba o feitiço", subtitulo: "Um link mágico chegará na sua caixa", mostrarLinha: true),
            _buildPasso(numero: "3", titulo: "Crie nova senha", subtitulo: "Escolha uma senha digna de um herói", mostrarLinha: false),

            const SizedBox(height: 35),

            // --- INPUT DE E-MAIL ---
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Seu e-mail de herói",
                hintStyle: const TextStyle(color: CoresApp.textMedContrast),
                prefixIcon: const Icon(Icons.email_outlined, color: CoresApp.textMedContrast),
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
            ),
            const SizedBox(height: 25),

            // --- BOTÃO ENVIAR ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Aqui entra a lógica de disparar o e-mail (Firebase Auth, etc)
                  // Pra simular a tela que tu mandou, vou só ativar o aviso verde
                  setState(() {
                    _feiticoEnviado = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CoresApp.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text(
                  "Enviar Feitiço de Recuperação",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- VOLTAR PARA O LOGIN ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Lembrou a senha? ", style: TextStyle(color: CoresApp.textMedContrast)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text("Voltar para o login", style: TextStyle(color: CoresApp.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // --- FEEDBACK DE SUCESSO (Aparece ao clicar no botão) ---
            if (_feiticoEnviado)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CoresApp.cardBackground,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: CoresApp.successGreen.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: CoresApp.successGreen.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: CoresApp.successGreen, size: 20),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Feitiço enviado!", style: TextStyle(color: CoresApp.successGreen, fontWeight: FontWeight.bold)),
                          Text("Verifique sua caixa de entrada, herói.", style: TextStyle(color: CoresApp.textMedContrast, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget para desenhar as bolinhas com números e a linhazinha conectando
  Widget _buildPasso({required String numero, required String titulo, required String subtitulo, required bool mostrarLinha}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: CoresApp.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(numero, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            if (mostrarLinha)
              Container(
                width: 2,
                height: 30,
                color: CoresApp.primary.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 2),
              Text(subtitulo, style: const TextStyle(color: CoresApp.textMedContrast, fontSize: 12)),
              if (mostrarLinha) const SizedBox(height: 15),
            ],
          ),
        ),
      ],
    );
  }
}