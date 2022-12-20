import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projeto_cbq/models/modelTurma.dart';
import 'package:projeto_cbq/models/user.dart';

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
              return Container(
                color: Color(0xff344955),
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
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

                    if (_nomePesquisa.isEmpty &&
                        _alunsoSalvos.contains(usuario.idUsuario) == false) {
                      return Card(
                        color: Color(0xff5f7481),
                        child: ListTile(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Color(0xff5f7481),
                                    title: Text(
                                      "Adicionar contato",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    content: Text(
                                      "Tem certeza que deseja adicionar o aluno: ${data["nome"]} na turma ${widget.nomeTurma}?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Cancelar",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            primary: Color(0xffffdc65)),
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            _adicionarAluno(usuario);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Confirmar",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              primary: Color(0xffffdc65)))
                                    ],
                                  );
                                });
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
                        ),
                      );
                    }

                    if (data["nome"]
                            .toString()
                            .toLowerCase()
                            .contains(_nomePesquisa.toLowerCase()) &&
                        _alunsoSalvos.contains(usuario.idUsuario) == false) {
                      return Card(
                        color: Color(0xff5f7481),
                        child: ListTile(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Color(0xff5f7481),
                                    title: Text("Adicionar contato",
                                        style: TextStyle(color: Colors.white)),
                                    content: Text(
                                      "Tem certeza que deseja adicionar o aluno: ${data["nome"]} na turma ${widget.nomeTurma}?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Cancelar",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            primary: Color(0xffffdc65)),
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            _adicionarAluno(usuario);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Confirmar",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              primary: Color(0xffffdc65)))
                                    ],
                                  );
                                });
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
                        ),
                      );
                    }

                    return Container();
                  },
                ),
              );
          }
        },
      ),
    );
  }
}
