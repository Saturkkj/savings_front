import 'package:flutter/material.dart';

import 'tela_login.dart';
import 'cores_app.dart';

void main() {

  runApp(MeuAppUPX());
}

class MeuAppUPX extends StatelessWidget {
  const MeuAppUPX({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App UPX Finanças',

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      home: LoginScreen(),
    );
  }
}