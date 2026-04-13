import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{
  const HomePage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste text home_page'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Teste 2 text home_page'),
      ),
    );
  }
}