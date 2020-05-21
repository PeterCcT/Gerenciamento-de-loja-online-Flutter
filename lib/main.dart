import 'package:flutter/material.dart';
import 'package:gerenciadorlojavirtual/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.purple
      ),
      debugShowCheckedModeBanner: false,
      title: 'Gerenciador loja online',
      home: LoginScreen(),
    );
  }
}
