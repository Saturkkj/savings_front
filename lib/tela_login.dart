import 'package:flutter/material.dart';
import 'package:savings_front/cores_app.dart';
import 'package:savings_front/tela_cadastro.dart';


  class LoginScreen extends StatefulWidget {
    @override
    _LoginScreenState createState() => _LoginScreenState();
  }

  class _LoginScreenState extends State<LoginScreen> {
    bool _ocultarSenha = true;

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: CoresApp.corSecundaria,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Ícone ou Logo do teu App
                  Container(
                    height: 220 ,

                    margin: const EdgeInsets.only(bottom: 24.0),
                    child: Image.asset(
                      'assets/images/logo.png'
                    )
                  ),

                  Text(
                    'Acesse para ver seus insights financeiros',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 48),

                  // Campo de E-mail
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-mail',

                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Campo de Senha
                  TextFormField(
                    obscureText: _ocultarSenha,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _ocultarSenha ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _ocultarSenha = !_ocultarSenha;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  // Esqueci a senha
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {

                      },
                      child: Text(
                        'Esqueceu a senha?',
                        style: TextStyle(color: Colors.blue.shade700),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Botão
                  ElevatedButton(
                    onPressed: () {

                      print("Bora pro app!");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CoresApp.corPrincipal,
                      foregroundColor: CoresApp.corClara,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Link pra criar conta nova
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Ainda não tem conta?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (Context) => TelaCadastro()),
                          );
                        },
                        child: Text(
                          'Cadastre-se',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }