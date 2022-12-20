import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:projeto_cbq/Turma/addTurma.dart';
import 'package:projeto_cbq/Turma/infoTurma.dart';
import 'package:projeto_cbq/model/modelTurma.dart';

class Turma extends StatefulWidget {
  const Turma({super.key});

  @override
  State<Turma> createState() => _TurmaState();
}

class _TurmaState extends State<Turma> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;

  String? _idTurma;

  _adicionarListenerTurma() async {
    final stream =
        db.collection("turmas").orderBy("nome").snapshots().listen((event) {
      _controller.add(event);
    });
  }

  _abrirTurma(
      String idTurma, String nome, String ano, String cidade, String anoFinal) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => InfoTurma(idTurma, nome, ano, cidade, anoFinal)));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Turmas"),
          centerTitle: true,
          backgroundColor: Color(0xff0b222c),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color(0xfff9aa33),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => AdicionarTurma()));
          },
          icon: Icon(
            Icons.add,
            color: Colors.black,
          ),
          label: Text(
            "Adicionar turma",
            style: TextStyle(color: Colors.black),
          ),
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
                        Text("Carregando turmas", style: TextStyle(color: Colors.white),),
                        CircularProgressIndicator()
                      ],
                    ),
                  ),
                );
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                QuerySnapshot? querySnapshot = snapshot.data;
                List<DocumentSnapshot> turmas = querySnapshot!.docs.toList();
                return Container(
                    color: Color(0xff344955),
                    child: Expanded(
                        child: ListView.builder(
                            itemCount: turmas.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot item = turmas[index];
                              String nome = item["nome"];
                              String anoIncial = item["anoInicio"];
                              String anoFinal = item["anoFinal"];
                              String cidade = item["cidade"];
                              String idTurma = item.id;

                              return GestureDetector(
                                onTap: () {
                                  _abrirTurma(idTurma, nome, anoIncial, cidade,
                                      anoFinal);
                                },
                                child: Card(
                                    color: Color(0xff5f7481),
                                    child: ListTile(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(16, 8, 16, 8),
                                      title: Text(
                                        nome,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      subtitle: Text(
                                        "$cidade, $anoIncial",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16),
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_right_rounded,
                                        color: Color(0xfff9aa33),
                                      ),
                                    )),
                              );
                            })));
            }
          },
        ));
  }
}
