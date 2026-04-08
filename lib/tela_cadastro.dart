import 'package:flutter/material.dart';
import 'cores_app.dart';

class TelaCadastro extends StatefulWidget {
  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();

  bool _ocultarSenha = true;
  bool _ocultarConfirmaSenha = true;

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.corPrincipal,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Deixa a barra transparente
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: CoresApp.corSecundaria),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Só algumas informações!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: CoresApp.corSecundaria,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Rápido e seguro pra tu analisar tuas finanças.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 32),

                  // Campo Nome
                  TextFormField(
                    controller: _nomeController,
                    decoration: _buildInputDecoration('Nome Completo', Icons.person),
                    // Validação: se tiver vazio, ele chia
                    validator: (value) => value!.isEmpty ? 'Tu não é ghost, então bota o nome' : null,
                  ),
                  SizedBox(height: 16),

                  // Campo CPF
                  TextFormField(
                    controller: _cpfController,
                    keyboardType: TextInputType.number,
                    decoration: _buildInputDecoration('CPF', Icons.badge),
                    validator: (value) => value!.isEmpty ? 'Vamo tirar uma moto não, bota aí' : null,
                  ),
                  SizedBox(height: 16),

                  // Campo E-mail
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _buildInputDecoration('E-mail', Icons.email),
                    validator: (value) => !value!.contains('@') ? 'Pode ser aquele teu email estranho...' : null,
                  ),
                  SizedBox(height: 16),

                  // Campo Senha
                  TextFormField(
                    controller: _senhaController,
                    obscureText: _ocultarSenha,
                    decoration: _buildInputDecoration('Senha', Icons.lock).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(_ocultarSenha ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _ocultarSenha = !_ocultarSenha),
                      ),
                    ),
                    validator: (value) => value!.length < 6 ? 'A senha tem que ter pelo menos 6 caracteres' : null,
                  ),
                  SizedBox(height: 16),

                  // Campo Confirmar Senha
                  TextFormField(
                    obscureText: _ocultarConfirmaSenha,
                    decoration: _buildInputDecoration('Confirmar Senha', Icons.lock_outline).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(_ocultarConfirmaSenha ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _ocultarConfirmaSenha = !_ocultarConfirmaSenha),
                      ),
                    ),
                    validator: (value) {
                      if (value != _senhaController.text) {
                        return 'Já esqueceu a senha? Tenta de novo...';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32),

                  // Botão de Cadastro
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Cadastrando no sistema...')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CoresApp.corSecundaria,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cadastrar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CoresApp.corPrincipal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade200,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: CoresApp.corPrincipal, width: 2),
      ),
    );
  }
}