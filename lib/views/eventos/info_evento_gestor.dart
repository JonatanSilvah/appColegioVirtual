import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:projeto_cbq/models/modelEvento.dart';

class infoEventoGestor extends StatefulWidget {
  ModelEvento evento;
  String idEvento;
  infoEventoGestor(this.evento, this.idEvento);

  @override
  State<infoEventoGestor> createState() => _infoEventoGestorState();
}

class _infoEventoGestorState extends State<infoEventoGestor> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  bool _editarEvento = false;
  List<DropdownMenuItem<String>> dropOpcoes = [];

  String? _escolhaDropDown = "Aguardando ínicio";

  _carregarItem() {
    dropOpcoes.add(DropdownMenuItem(
      child: Text("Aguardando ínicio"),
      value: "Aguardando ínicio",
    ));
    dropOpcoes.add(DropdownMenuItem(
      child: Text("Em andamento"),
      value: "Em andamento",
    ));
    dropOpcoes.add(DropdownMenuItem(
      child: Text("Finalizado"),
      value: "Finalizado",
    ));
  }

  _atualizarStatus() async {
    Map<String, dynamic> dadosAtt = {"status": _escolhaDropDown};
    db.collection("eventos").doc(widget.idEvento).update(dadosAtt);
    db
        .collection("turmas")
        .doc(widget.evento.turmaEvento)
        .collection("eventos")
        .doc(widget.idEvento)
        .update(dadosAtt);

    final snackbar = SnackBar(
      backgroundColor: Colors.green,
      content: Text("Evento atualizado com sucesso."),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);

     
    
  }

  @override
  void initState() {
    super.initState();
    _carregarItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Informações do evento"),
        backgroundColor: Color(0xff0b222c),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          color: Color(0xff344955),
          padding: EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                Divider(
                  color: Colors.grey,
                ),
                Gap(12),
                Text(
                  "Status:",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Colors.white),
                ),
                Gap(12),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    fillColor: Color(0xfff9aa33),
                    filled: true,
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  value: _escolhaDropDown,
                  hint: Text(
                    widget.evento.status,
                    style: TextStyle(color: Colors.black),
                  ),
                  items: dropOpcoes,
                  onChanged: ((value) {
                    setState(() {
                      _escolhaDropDown = value;
                    });
                  }),
                ),
                Gap(12),
                Divider(
                  color: Colors.grey,
                ),
                Gap(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                Divider(
                  color: Colors.grey,
                ),
                Gap(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                Divider(
                  color: Colors.grey,
                ),
                Gap(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                Gap(12),
                ElevatedButton(
                  onPressed: () {
                    _atualizarStatus();
                  },
                  child: Text(
                    "Salvar",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xfff9aa33),
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              ],
            ),
          )),
    );
  }
}
