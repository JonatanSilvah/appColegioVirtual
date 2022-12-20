import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

import 'package:projeto_cbq/models/modelTurma.dart';
import 'package:projeto_cbq/models/user.dart';
import 'package:projeto_cbq/views/turmas/info_turma.dart';


class infoAluno extends StatefulWidget {
  Usuario usuario;
  infoAluno(this.usuario);

  @override
  State<infoAluno> createState() => _infoAlunoState();
}

class _infoAlunoState extends State<infoAluno> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<Usuario> usuarios = [];

  List<ModelTurma> _turmasSalvas = [];

  Future<List<ModelTurma>> _recuperarTurma() async {
    QuerySnapshot snapshot = await db
        .collection("usuarios")
        .doc("tipoUsuario")
        .collection("alunos")
        .doc(widget.usuario.idUsuario)
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

    return _turmasSalvas;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarTurma();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0b222c),
        title: Text("Informações do aluno"),
      ),
      body: Container(
        color: Color(0xff344955),
        padding: EdgeInsets.only(top: 32, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
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
                    widget.usuario.nome.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xfff9aa33)),
                  ),
                ],
              ),
            ),
            Gap(7),
            Divider(
              color: Colors.white,
            ),
            Gap(7),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    "Email:",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  Gap(5),
                  Text(
                    widget.usuario.email.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xfff9aa33)),
                  ),
                ],
              ),
            ),
            Gap(7),
            Divider(
              color: Colors.white,
            ),
            Gap(7),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    "Data de nascimento:",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  Gap(5),
                  Text(
                    widget.usuario.dataNasc.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xfff9aa33)),
                  ),
                ],
              ),
            ),
            Gap(7),
            Divider(
              color: Colors.white,
            ),
            Gap(7),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    "Celular:",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  Gap(5),
                  Text(
                    widget.usuario.celularUsuario.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xfff9aa33)),
                  ),
                ],
              ),
            ),
            Gap(7),
            Divider(
              color: Colors.white,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    "CPF:",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  Gap(5),
                  Text(
                    widget.usuario.cpfUsuario.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xfff9aa33)),
                  ),
                ],
              ),
            ),
            Gap(7),
            Divider(
              color: Colors.white,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
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
                    widget.usuario.cidadeUsuario.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xfff9aa33)),
                  ),
                ],
              ),
            ),
            Gap(7),
            Divider(
              color: Colors.white,
            ),
            Text(
              "Turmas cadastradas",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Color(0xfff9aa33)),
            ),
            Expanded(
                flex: 1,
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

                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => InfoTurma(
                                      turma.idTurma,
                                      turma.nome,
                                      turma.anoTurma,
                                      turma.cidade,
                                      turma.cidade)));
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              turma.nome,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xfff9aa33)),
                            ),
                            Gap(5),
                            Icon(Icons.arrow_right_rounded,
                                color: Color(0xfff9aa33))
                          ],
                        ),
                      );
                    })),
          ],
        ),
      ),
    );
  }
}
