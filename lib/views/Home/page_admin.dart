import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_cbq/views/alunos/page_aluno.dart';
import 'package:projeto_cbq/views/config/config.dart';
import 'package:projeto_cbq/views/eventos/home_eventos.dart';
import 'package:projeto_cbq/views/login_cadastro/login.dart';
import 'package:projeto_cbq/views/turmas/home_turma.dart';
import 'dart:async';


class PageAdmin extends StatefulWidget {
  const PageAdmin({super.key});

  @override
  State<PageAdmin> createState() => _PageAdminState();
}

class _PageAdminState extends State<PageAdmin> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  String? _idUsuario;
  String? _nomeUsuario;
  String? _emailUsuario;

  _verificarUsuarioLogado() async {
    User? usuarioAtual = await auth.currentUser;

    if (usuarioAtual != null) {
      setState(() {
        _idUsuario = usuarioAtual.uid;
      });
      final snapshot = await db.collection("usuarios").doc(_idUsuario).get();

      final dados = snapshot.data();

      setState(() {
        _nomeUsuario = dados!["nome"];
        _emailUsuario = dados["email"];
      });
    } else if (usuarioAtual == null) {}
  }

  @override
  void initState() {
    _verificarUsuarioLogado();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer:
            drawer(_nomeUsuario.toString(), _emailUsuario.toString(), context),
        appBar: AppBar(
          title: Text("App Colegio"),
          backgroundColor: Color(0xff0b222c),
          centerTitle: true,
        ),
        body: Container(
          color: Color(0xff344955),
        ));
  }
}

Widget drawer(String nome, String email, context) {
  return Drawer(
      backgroundColor: Color(0xff344955),
      child: Material(
        color: Color(0xff344955),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Color(0xfff9aa33)),
                accountName: Text(
                  nome,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                accountEmail: Text(email,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 16))),
            menuItem(
                icon: Icons.person_search,
                text: "Alunos",
                onClicked: () => selectedItem(context, 0)),
            menuItem(
                icon: Icons.class_rounded,
                text: "Turmas",
                onClicked: () => selectedItem(context, 1)),
            menuItem(
                icon: Icons.event,
                text: "Eventos",
                onClicked: () => selectedItem(context, 2)),
            Divider(
              color: Colors.white,
            ),
            menuItem(
                icon: Icons.settings,
                text: "Configuração",
                onClicked: () => selectedItem(context, 3)),
            menuItem(
                icon: Icons.exit_to_app,
                text: "Sair",
                onClicked: () => selectedItem(context, 4)),
          ],
        ),
      ));
}

Widget menuItem(
    {required String text, required IconData icon, VoidCallback? onClicked}) {
  final color = Colors.white;

  return Container(
    child: ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      onTap: onClicked,
    ),
  );
}

Future<void> selectedItem(BuildContext context, int index) async {
  switch (index) {
    case 0:
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => homeAluno()));
      break;
    case 1:
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => Turma()));
      break;
    case 2:
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => Eventos()));
      break;
    case 3:
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => Configuracao()));
      break;
    case 4:
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => Login()), (route) => false);
      await deslogar();
      break;
  }
}

Future<void> deslogar() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  await auth.signOut();
}
