import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_cbq/models/user.dart';
import 'package:projeto_cbq/views/alunos/info_aluno.dart';


class homeAluno extends StatefulWidget {
  const homeAluno({super.key});

  @override
  State<homeAluno> createState() => _homeAlunoState();
}

class _homeAlunoState extends State<homeAluno> {
  @override
  Widget build(BuildContext context) {
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


    return Scaffold(
      backgroundColor: Colors.white,
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
              return Container(
                color: Color(0xff344955),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "Carregando Alunos",
                        style: TextStyle(color: Colors.white),
                      ),
                      CircularProgressIndicator()
                    ],
                  ),
                ),
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              QuerySnapshot? querySnapshot = snapshot.data;
              List<DocumentSnapshot> alunos = querySnapshot!.docs.toList();
              return Container(
                color: Color(0xff344955),
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
                            color: Color(0xff5f7481),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => infoAluno(usuario)));
                              },
                              title: Text(
                                data["nome"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              subtitle: Text(
                                data["email"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16),
                              ),
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
                          return Card(
                            color: Color(0xff5f7481),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => infoAluno(usuario)));
                              },
                              title: Text(
                                data["nome"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              subtitle: Text(
                                data["email"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16),
                              ),
                              trailing: Container(
                                child: Icon(
                                  Icons.arrow_right_rounded,
                                  color: Color(0xfff9aa33),
                                ),
                              ),
                            ),
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