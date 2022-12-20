import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';


import 'package:projeto_cbq/models/modelEvento.dart';
import 'package:projeto_cbq/models/user.dart';
import 'package:projeto_cbq/views/alunos/info_aluno.dart';
import 'package:projeto_cbq/views/turmas/add_aluno_turma.dart';

import 'package:projeto_cbq/views/alunos/info_aluno.dart';

class InfoTurma extends StatefulWidget {
  String? idTurma;
  String? nomeTurma;
  String? anoTurma;
  String? cidadeTurma;
  String? anoFinal;
  InfoTurma(this.idTurma, this.nomeTurma, this.anoTurma, this.cidadeTurma,
      this.anoFinal);

  @override
  State<InfoTurma> createState() => _InfoTurmaState();
}

class _InfoTurmaState extends State<InfoTurma> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _controller = StreamController<QuerySnapshot>.broadcast();

  String name = "";
  bool _expandEvento = false;
  bool _expandAlunos = false;

  _adicionarListenerTurma() async {
    final stream = db
        .collection("turmas")
        .doc(widget.idTurma)
        .collection("alunos")
        .snapshots()
        .listen((event) {
      _controller.add(event);
    });
    _recuperarEventos();
  }

  _removerAluno(Usuario usuario) async {
    db
        .collection("turmas")
        .doc(widget.idTurma)
        .collection("alunos")
        .doc(usuario.idUsuario)
        .delete();
    db
        .collection("usuarios")
        .doc("tipoUsuario")
        .collection("alunos")
        .doc(usuario.idUsuario)
        .collection("turmas")
        .doc(widget.idTurma)
        .delete();

    await _adicionarListenerTurma();
    await _recuperarEventos();
  }

  List<ModelEvento> _eventosSalvos = [];

  Future<List<ModelEvento>> _recuperarEventos() async {
    QuerySnapshot snapshot = await db
        .collection("turmas")
        .doc(widget.idTurma)
        .collection("eventos")
        .get();

    for (DocumentSnapshot item in snapshot.docs) {
      var dados = item.data() as Map;
      ModelEvento evento = ModelEvento();
      evento.nomeEvento = dados["nome"];
      evento.dataInicial = dados["dataInicial"];
      evento.status = dados["status"];

      setState(() {
        _eventosSalvos.add(evento);
      });
    }

    return _eventosSalvos;
  }

  @override
  void initState() {
    _adicionarListenerTurma();

    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  bool _status = true;
  bool _status2 = true;
  String _nomePesquisa = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff0b222c),
          title: TextField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                prefixIcon: Icon(
                  Icons.search,
                ),
                filled: true,
                hoverColor: Colors.white,
                fillColor: Colors.white,
                hintText: "Pesquisar alunos",
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide(color: Colors.black))),
            onChanged: (value) {
              setState(() {
                _nomePesquisa = value;
              });
            },
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _controller.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Container(
                  color: Color(0xff344955),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Carregando informações da turma",
                          style: TextStyle(color: Colors.white),
                        ),
                        CircularProgressIndicator()
                      ],
                    ),
                  ),
                );
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                QuerySnapshot? querySnapshot = snapshot.data;
                List<DocumentSnapshot> alunos = querySnapshot!.docs.toList();
                return Container(
                  color: Color(0xff344955),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: 32, right: 32, top: 16, bottom: 16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Turma:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      color: Colors.white),
                                ),
                                Gap(5),
                                Text(
                                  widget.nomeTurma.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color(0xfff9aa33)),
                                ),
                              ],
                            ),
                            Gap(7),
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
                                  widget.anoTurma.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color(0xfff9aa33)),
                                ),
                              ],
                            ),
                            Gap(7),
                            Row(
                              children: [
                                Text(
                                  "Ano final:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      color: Colors.white),
                                ),
                                Gap(5),
                                Text(
                                  widget.anoFinal.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color(0xfff9aa33)),
                                ),
                              ],
                            ),
                            Gap(7),
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
                                  widget.cidadeTurma.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color(0xfff9aa33)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Gap(10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _expandEvento = !_expandEvento;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Eventos",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  color: Color(0xfff9aa33)),
                            ),
                            Gap(10),
                            _expandEvento == false
                                ? Icon(Icons.expand_more,
                                    color: Color(0xfff9aa33))
                                : Icon(Icons.expand_less,
                                    color: Color(0xfff9aa33))
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        height: _expandEvento == false
                            ? 0
                            : MediaQuery.of(context).size.height * 0.25,
                        duration: Duration(milliseconds: 500),
                        child: Expanded(
                            flex: 2,
                            child: ListView.builder(
                              itemCount: _eventosSalvos.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  color: Color(0xff5f7481),
                                  child: ListTile(
                                    onTap: () {},
                                    title: Text(
                                        _eventosSalvos[index].nomeEvento,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    subtitle: Text(
                                        _eventosSalvos[index].dataInicial,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    trailing: Container(
                                      child: Text(
                                        _eventosSalvos[index].status,
                                        style:
                                            TextStyle(color: Color(0xfff9aa33)),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )),
                      ),
                      Divider(),
                      Gap(10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _expandAlunos = !_expandAlunos;
                          });
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Alunos",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      color: Color(0xfff9aa33))),
                              _expandAlunos == false
                                  ? Icon(Icons.expand_more,
                                      color: Color(0xfff9aa33))
                                  : Icon(Icons.expand_less,
                                      color: Color(0xfff9aa33))
                            ]),
                      ),
                      AnimatedContainer(
                        height: _expandAlunos == false ? 0 : null,
                        duration: Duration(milliseconds: 500),
                        child: Expanded(
                            flex: 3,
                            child: ListView.builder(
                                itemCount: querySnapshot.docs.length,
                                itemBuilder: (context, index) {
                                  var data = snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;

                                  Usuario usuario = Usuario();
                                  usuario.nome = data["nome"];
                                  usuario.celularUsuario = data["celular"];
                                  usuario.cidadeUsuario = data["cidade"];
                                  usuario.cpfUsuario = data["cpf"];
                                  usuario.dataNasc = data["dataNasc"];
                                  usuario.email = data["email"];
                                  usuario.idUsuario = data["idUsuario"];

                                  if (_nomePesquisa.isEmpty) {
                                    return Card(
                                        color: Color(0xff5f7481),
                                        child: Dismissible(
                                          key: UniqueKey(),
                                          onDismissed: ((direction) {
                                            _removerAluno(usuario);
                                          }),
                                          direction:
                                              DismissDirection.endToStart,
                                          background: Container(
                                            color: Colors.red,
                                            padding: EdgeInsets.all(16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                          ),
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          infoAluno(usuario)));
                                            },
                                            title: Text(data["nome"],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18)),
                                            subtitle: Text(data["email"],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 16)),
                                            trailing: Container(
                                              child: Icon(
                                                Icons.arrow_right_rounded,
                                                color: Color(0xfff9aa33),
                                              ),
                                            ),
                                          ),
                                        ));
                                  }
                                  if (data["nome"]
                                      .toString()
                                      .toLowerCase()
                                      .contains(_nomePesquisa.toLowerCase())) {
                                    return Card(
                                        color: Color(0xff5f7481),
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        infoAluno(usuario)));
                                          },
                                          title: Text(data["nome"],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                          subtitle: Text(data["email"],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16)),
                                          trailing: Container(
                                            child: Icon(
                                              Icons.arrow_right_rounded,
                                              color: Color(0xfff9aa33),
                                            ),
                                          ),
                                        ));
                                  }

                                  return Container();
                                })),
                      )
                    ],
                  ),
                );
            }
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Color(0xfff9aa33),
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
            label: Text(
              "Adicionar aluno",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: (() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddAluno(
                          widget.idTurma,
                          widget.nomeTurma,
                          widget.cidadeTurma,
                          widget.anoTurma,
                          widget.anoFinal)));
            })));
  }
}
