import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:projeto_cbq/models/modelEvento.dart';

class InfoEvento extends StatefulWidget {
  ModelEvento evento;
  InfoEvento(this.evento);

  @override
  State<InfoEvento> createState() => _InfoEventoState();
}

class _InfoEventoState extends State<InfoEvento> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Informações do evento"),
        backgroundColor: Color(0xff0b222c),
      ),
      body: Container(
        color: Color(0xff344955),
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Nome:",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Colors.white),
                ),
                Gap(5),
                Text(
                  widget.evento.nomeEvento.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xfff9aa33)),
                ),
              ],
            ),
            Gap(12),
            Row(
              children: [
                Text(
                  "Status:",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Colors.white),
                ),
                Gap(5),
                Text(
                  widget.evento.status.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xfff9aa33)),
                ),
              ],
            ),
            Gap(12),
            Row(
              children: [
                Text(
                  "Ano íncial:",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Colors.white),
                ),
                Gap(5),
                Text(
                  widget.evento.dataInicial.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xfff9aa33)),
                ),
              ],
            ),
            Gap(12),
            Row(
              children: [
                Text(
                  "Data final:",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Colors.white),
                ),
                Gap(5),
                Text(
                  widget.evento.dataFinal.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xfff9aa33)),
                ),
              ],
            ),
            Gap(12),
            Row(
              children: [
                Text(
                  "Cidade:",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Colors.white),
                ),
                Gap(5),
                Text(
                  widget.evento.cidadeEvento.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xfff9aa33)),
                ),
              ],
            ),
            Gap(12),
            Divider(
              color: Colors.grey,
            ),
            Gap(12),
            Text(
              "Descriçaõ:",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Colors.white),
            ),
            Gap(5),
            Text(
              widget.evento.descricao.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xfff9aa33)),
            ),
          ],
        ),
      ),
    );
  }
}
