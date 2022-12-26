import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_cbq/models/modelEvento.dart';
import 'package:projeto_cbq/models/modelTurma.dart';
import 'package:projeto_cbq/views/eventos/info_evento.dart';

class eventosAlunos extends StatefulWidget {
  const eventosAlunos({super.key});

  @override
  State<eventosAlunos> createState() => _eventosAlunosState();
}

class _eventosAlunosState extends State<eventosAlunos> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseAuth auth = FirebaseAuth.instance;

  String? _idUsuario;
  String? _tipoUsuario;

  _verificarIdUsuario() async {
    User? usuarioAtual = await auth.currentUser;
    setState(() {
      _idUsuario = usuarioAtual!.uid;
    });

    await _recuperarTurma();
  }

  _listenerEventos() async {
    final stream = db.collection("eventos").snapshots().listen((event) {
      _controller.add(event);
    });
  }

  List<String> _turmasSalvas = [];

  Future<List<String>> _recuperarTurma() async {
    QuerySnapshot snapshot = await db
        .collection("usuarios")
        .doc("tipoUsuario")
        .collection("alunos")
        .doc(_idUsuario)
        .collection("turmas")
        .get();

    for (DocumentSnapshot item in snapshot.docs) {
      var dados = item.data() as Map;

      ModelTurma turma = ModelTurma();

      turma.idTumra = item.id;

      setState(() {
        _turmasSalvas.add(turma.idTurma);
      });
    }

    return _turmasSalvas;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _listenerEventos();
    _verificarIdUsuario();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos"),
        backgroundColor: Color(0xff0b222c),
      ),
      body: StreamBuilder(
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
                        "Carregando eventos",
                        style: TextStyle(color: Colors.white),
                      ),
                      CircularProgressIndicator()
                    ],
                  ),
                ),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              QuerySnapshot? querySnapshot = snapshot.data;
              List<DocumentSnapshot> eventos = querySnapshot!.docs.toList();
              return Container(
                color: Color(0xff344955),
                child: ListView.builder(
                    itemCount: eventos.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      DocumentSnapshot item = eventos[index];
                      ModelEvento evento = ModelEvento();
                      evento.nomeEvento = data["nome"];
                      evento.cidadeEvento = data["cidade"];
                      evento.dataInicial = data["dataInicial"];
                      evento.dataFinal = data["dataFinal"];
                      evento.descricao = data["descricao"];
                      evento.status = data["status"];
                      evento.turmaEvento = data["turma"];

                      if (_turmasSalvas.contains(data["turma"])) {
                        return Card(
                          color: Color(0xff5f7481),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => InfoEvento(evento)));
                            },
                            title: Text(data["nome"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            subtitle: Text(data["cidade"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16)),
                            trailing: Container(
                              child: Text(
                                data["status"],
                                style: TextStyle(color: Color(0xfff9aa33)),
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                    }),
              );
          }
        },
      ),
    );
  }
}
