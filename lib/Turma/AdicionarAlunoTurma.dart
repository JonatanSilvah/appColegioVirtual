import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_cbq/Home/Turma.dart';
import 'package:projeto_cbq/model/ModelTurma.dart';
import 'package:projeto_cbq/model/Usuario.dart';

class AddAluno extends StatefulWidget {
  String? idTurma;
  String? nomeTurma;
  String? anoTurma;
  String? cidadeTurma;
  String? anoFinal;
  AddAluno(this.idTurma, this.nomeTurma, this.cidadeTurma, this.anoTurma,
      this.anoFinal);

  @override
  State<AddAluno> createState() => _AddAlunoState();
}

class _AddAlunoState extends State<AddAluno> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  String _nomePesquisa = "";

  _adicionarListenerAlunos() async {
    final stream = FirebaseFirestore.instance
        .collection("usuarios")
        .doc("tipoUsuario")
        .collection("alunos")
        .snapshots();

    stream.listen((event) {
      _controller.add(event);
    });

    _recuperarAlunos();
  }

  Future _adicionarAluno(Usuario usuario) async {
    db
        .collection("turmas")
        .doc(widget.idTurma)
        .collection("alunos")
        .doc(usuario.idUsuario)
        .set(usuario.toMap());

    ModelTurma turma = ModelTurma();
    turma.nome = widget.nomeTurma.toString();
    turma.anoTurma = widget.anoTurma.toString();
    turma.cidade = widget.cidadeTurma.toString();
    turma.anoFinal = widget.anoFinal.toString();
    db
        .collection("usuarios")
        .doc("tipoUsuario")
        .collection("alunos")
        .doc(usuario.idUsuario)
        .collection("turmas")
        .doc(widget.idTurma)
        .set(turma.toMap());

    await _adicionarListenerAlunos();
    await _recuperarAlunos();
  }

  List<String> _alunsoSalvos = [];

  Future<List<String>> _recuperarAlunos() async {
    QuerySnapshot snapshot = await db
        .collection("turmas")
        .doc(widget.idTurma)
        .collection("alunos")
        .get();

    for (DocumentSnapshot item in snapshot.docs) {
      var dados = item.data() as Map;

      if (dados["tipoUsuario"] == "aluno") {
        setState(() {
          _alunsoSalvos.add(dados["idUsuario"]);
        });
      }
    }

    return _alunsoSalvos;
  }

  @override
  void initState() {
    _adicionarListenerAlunos();
    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff344955),
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
              hintText: "pesquisar",
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
              return Center(
                child: Column(
                  children: [
                    Text("Carregando Alunos"),
                    CircularProgressIndicator()
                  ],
                ),
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              QuerySnapshot? querySnapshot = snapshot.data;
              List<DocumentSnapshot> alunos = querySnapshot!.docs.toList();
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;

                  Usuario usuario = Usuario();
                  usuario.nome = data["nome"];
                  usuario.celularUsuario = data["celular"];
                  usuario.cidadeUsuario = data["cidade"];
                  usuario.cpfUsuario = data["cpf"];
                  usuario.dataNasc = data["dataNasc"];
                  usuario.email = data["email"];
                  usuario.idUsuario = data["idUsuario"];

                  if (_nomePesquisa.isEmpty &&
                      _alunsoSalvos.contains(usuario.idUsuario) == false) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Color(0xfff9aa33),
                                  title: Text("Adicionar contato"),
                                  content: Text(
                                    "Tem certeza que deseja adicionar o aluno: ${data["nome"]} na turma ${widget.nomeTurma}?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancelar"),
                                      style: ElevatedButton.styleFrom(
                                          primary: Color(0xff344955)),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          _adicionarAluno(usuario);
                                          Navigator.pop(context);
                                        },
                                        child: Text("Confirmar"),
                                        style: ElevatedButton.styleFrom(
                                            primary: Color(0xff344955)))
                                  ],
                                );
                              });
                        },
                        title: Text(data["nome"]),
                        subtitle: Text(data["email"]),
                      ),
                    );
                  }

                  if (data["nome"]
                          .toString()
                          .toLowerCase()
                          .contains(_nomePesquisa.toLowerCase()) &&
                      _alunsoSalvos.contains(usuario.idUsuario) == false) {
                    return ListTile(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Color(0xffe3bb64),
                                title: Text("Adicionar contato"),
                                content: Text(
                                  "Tem certeza que deseja adicionar o aluno: ${data["nome"]} na turma ${widget.nomeTurma}?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancelar"),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.black),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        _adicionarAluno(usuario);
                                        Navigator.pop(context);
                                      },
                                      child: Text("Confirmar"),
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.black))
                                ],
                              );
                            });
                      },
                      title: Text(data["nome"]),
                      subtitle: Text(data["email"]),
                    );
                  }

                  return Container();
                },
              );
          }
        },
      ),
    );
  }
}
