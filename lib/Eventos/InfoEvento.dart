import 'package:flutter/material.dart';

class InfoEvento extends StatefulWidget {
  const InfoEvento({super.key});

  @override
  State<InfoEvento> createState() => _InfoEventoState();
}

class _InfoEventoState extends State<InfoEvento> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Informações do evento"),
        backgroundColor: Color(0xff344955),
      ),
    );
  }
}
