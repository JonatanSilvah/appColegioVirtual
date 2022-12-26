import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:projeto_cbq/models/modelTurma.dart';
import 'package:projeto_cbq/views/turmas/info_tuma_aluno.dart';

class turmasAluno extends StatefulWidget {
  @override
  State<turmasAluno> createState() => _turmasAlunoState();
}

class _turmasAlunoState extends State<turmasAluno> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  String? _idUsuario;

  _verificarUsuarioLogado() async {
    User? usuarioAtual = await auth.currentUser;
    setState(() {
      _idUsuario = usuarioAtual!.uid;
    });
    await _recuperarTurma();
  }

  List<ModelTurma> _turmasSalvas = [];

  Future<List<ModelTurma>> _recuperarTurma() async {
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

      turma.nome = dados["nome"];
      turma.cidade = dados["cidade"];
      turma.anoTurma = dados["anoInicio"];
      turma.anoFinal = dados["anoFinal"];
      turma.idTumra = item.id;

      setState(() {
        _turmasSalvas.add(turma);
      });
    }

    print(_idUsuario);

    return _turmasSalvas;
  }

  @override
  void initState() {
    _verificarUsuarioLogado();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Informações da turma"),
          backgroundColor: Color(0xff0b222c),
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          color: Color(0xff344955),
          child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _turmasSalvas.length,
              itemBuilder: (context, index) {
                ModelTurma turma = ModelTurma();
                turma.nome = _turmasSalvas[index].nome;
                turma.cidade = _turmasSalvas[index].cidade;
                turma.anoTurma = _turmasSalvas[index].anoTurma;
                turma.anoFinal = _turmasSalvas[index].anoFinal;
                turma.idTumra = _turmasSalvas[index].idTurma;

                return Card(
                  color: Color(0xff5f7481),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => infoTurmaAluno(
                              turma.idTurma,
                              turma.nome,
                              turma.anoTurma,
                              turma.cidade,
                              turma.anoFinal)));
                    },
                    title: Text(
                      _turmasSalvas[index].nome,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xfff9aa33)),
                    ),
                    subtitle: Text(turma.anoTurma,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Color(0xfff9aa33))),
                    trailing: Icon(Icons.arrow_right_rounded,
                        color: Color(0xfff9aa33)),
                  ),
                );
              }),
        ));
  }
}
