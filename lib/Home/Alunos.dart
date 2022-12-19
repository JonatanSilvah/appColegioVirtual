import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Alunos/InfoAluno.dart';
import '../model/Usuario.dart';

class Alunos extends StatefulWidget {
  const Alunos({super.key});

  @override
  State<Alunos> createState() => _AlunosState();
}

class _AlunosState extends State<Alunos> {
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
      backgroundColor: Colors.white,
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
              return Container(
                child: Column(
                  children: [
                    Expanded(
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

                        if (_nomePesquisa.isEmpty) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => InfoAluno(usuario)));
                              },
                              title: Text(
                                data["nome"],
                                style: TextStyle(color: Colors.black),
                              ),
                              subtitle: Text(data["email"],
                                  style: TextStyle(color: Colors.black)),
                              trailing: Container(
                                child: Icon(
                                  Icons.arrow_right_rounded,
                                  color: Color(0xfff9aa33),
                                ),
                              ),
                            ),
                          );
                        }

                        if (data["nome"]
                            .toString()
                            .toLowerCase()
                            .contains(_nomePesquisa.toLowerCase())) {
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => InfoAluno(usuario)));
                            },
                            title: Text(data["nome"]),
                            subtitle: Text(data["email"]),
                          );
                        }

                        return Container();
                      },
                    ))
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
