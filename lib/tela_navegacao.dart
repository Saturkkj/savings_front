import 'package:flutter/material.dart';
import 'cores_app.dart';
import 'tela_inicial.dart';
import 'tela_analises.dart';
import 'tela_aprender.dart';
import 'tela_configuracoes.dart';

class TelaNavegacao extends StatefulWidget {
  const TelaNavegacao({super.key});

  @override
  State<TelaNavegacao> createState() => _TelaNavegacaoState();
}

class _TelaNavegacaoState extends State<TelaNavegacao> {
  int _indiceAtual = 0;

  // Lista com as telas que a gente já forjou
  final List<Widget> _telas = [
    const TelaInicial(),
    const TelaAnalises(),
    const TelaAprender(),
    const TelaConfiguracoes()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.background,
      body: _telas[_indiceAtual],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF2C1960),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: CoresApp.yellow,
        unselectedItemColor: CoresApp.textcinza,
        currentIndex: _indiceAtual,
        onTap: (index) {
          setState(() {
            _indiceAtual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Análises'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Aprender'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config'),
        ],
      ),
    );
  }
}