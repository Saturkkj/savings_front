import 'package:flutter/material.dart';
import 'tela_login.dart';

void main() {
  runApp(const MeuAppUPX());
}

class MeuAppUPX extends StatelessWidget {
  const MeuAppUPX({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Savings RPG',
      home: const TelaLogin(),
    );
  }
}