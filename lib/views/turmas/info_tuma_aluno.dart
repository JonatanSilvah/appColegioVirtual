import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:projeto_cbq/models/modelEvento.dart';

class infoTurmaAluno extends StatefulWidget {
  String? idTurma;
  String? nomeTurma;
  String? anoTurma;
  String? cidadeTurma;
  String? anoFinal;
  infoTurmaAluno(this.idTurma, this.nomeTurma, this.anoTurma, this.cidadeTurma,
      this.anoFinal);

  @override
  State<infoTurmaAluno> createState() => _infoTurmaAlunoState();
}

class _infoTurmaAlunoState extends State<infoTurmaAluno> {
  FirebaseFirestore db = FirebaseFirestore.instance;

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
    _recuperarEventos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0b222c),
        title: Text(widget.nomeTurma.toString()),
      ),
      body: Container(
        color: Color(0xff344955),
        child: Container(
            padding: EdgeInsets.only(left: 32, right: 32, top: 16, bottom: 16),
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
                Gap(5),
                Divider(
                  color: Colors.grey,
                ),
                Gap(5),
                Text(
                  "Eventos cadastrados",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Color(0xfff9aa33)),
                ),
                Gap(10),
                Expanded(
                    flex: 2,
                    child: ListView.builder(
                      itemCount: _eventosSalvos.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Color(0xff5f7481),
                          child: ListTile(
                            onTap: () {},
                            title: Text(_eventosSalvos[index].nomeEvento,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            subtitle: Text(_eventosSalvos[index].dataInicial,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            trailing: Container(
                              child: Text(
                                _eventosSalvos[index].status,
                                style: TextStyle(color: Color(0xfff9aa33)),
                              ),
                            ),
                          ),
                        );
                      },
                    ))
              ],
            )),
      ),
    );
  }
}
