import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_cbq/models/modelEvento.dart';
import 'package:projeto_cbq/views/eventos/add_evento.dart';
import 'package:projeto_cbq/views/eventos/info_evento.dart';
import 'package:projeto_cbq/views/eventos/info_evento_gestor.dart';

class Eventos extends StatefulWidget {
  const Eventos({super.key});

  @override
  State<Eventos> createState() => _EventosState();
}

class _EventosState extends State<Eventos> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _controller = StreamController<QuerySnapshot>.broadcast();

  _listenerEventos() async {
    final stream = db.collection("eventos").snapshots().listen((event) {
      _controller.add(event);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _listenerEventos();
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
                        String idEvento = item.id;
                        evento.turmaEvento = data["turma"];

                        return Card(
                          color: Color(0xff5f7481),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          infoEventoGestor(evento, idEvento)));
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
                      }),
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
              "Adicionar evento",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: (() {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => CriarEvento()));
            })));
  }
}
