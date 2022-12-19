import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:projeto_cbq/Eventos/CriarEnveto.dart';
import 'package:projeto_cbq/Eventos/InfoEvento.dart';

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
        appBar:
            AppBar(title: Text("Eventos"), backgroundColor: Color(0xff344955)),
        body: StreamBuilder(
          stream: _controller.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Column(
                    children: [
                      Text("Carregando eventos"),
                      CircularProgressIndicator()
                    ],
                  ),
                );
              case ConnectionState.active:
              case ConnectionState.done:
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => InfoEvento()));
                          },
                          title: Text(data["nome"]),
                          subtitle: Text(data["cidade"]),
                          trailing: Container(
                            child: Text(
                              data["status"],
                              style: TextStyle(color: Color(0xfff9aa33)),
                            ),
                          ),
                        ),
                      );
                    });
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
