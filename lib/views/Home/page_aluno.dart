import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_cbq/models/user.dart';
import 'package:projeto_cbq/views/alunos/info_aluno.dart';
import 'package:projeto_cbq/views/alunos/minhas_informacoes.dart';
import 'package:projeto_cbq/views/login_cadastro/login.dart';

class PageAluno extends StatefulWidget {
  const PageAluno({super.key});

  @override
  State<PageAluno> createState() => _PageAlunoState();
}

class _PageAlunoState extends State<PageAluno> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  String? _idUsuario;
  String? _nomeUsuario;
  String? _emailUsuario;

  Usuario usuario = Usuario();

  _deslogar() {
    auth.signOut();
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (_) => Login()), (route) => false);
  }

  _verificarUsuarioLogado() async {
    User? usuarioAtual = await auth.currentUser;
    setState(() {
      _idUsuario = usuarioAtual!.uid;
    });
    if (usuarioAtual != null) {
      final snapshot = await db
          .collection("usuarios")
          .doc("tipoUsuario")
          .collection("alunos")
          .doc(_idUsuario)
          .get();

      final dados = snapshot.data();

      usuario.nome = dados!["nome"];
      usuario.email = dados["email"];
      usuario.dataNasc = dados["dataNasc"];
      usuario.idUsuario = _idUsuario.toString();
      usuario.cpfUsuario = dados["cpf"];
      usuario.cidadeUsuario = dados["cidade"];
      usuario.celularUsuario = dados["celular"];

      setState(() {
        _nomeUsuario = dados!["nome"];
        _emailUsuario = dados["email"];
      });
    } else {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => Login()), (route) => false);
    }
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(
          _nomeUsuario.toString(), _emailUsuario.toString(), context, usuario),
      appBar: AppBar(
        title: Text(
          "Page aluno",
        ),
        backgroundColor: Color(0xff0b222c),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xff344955),
      ),
    );
  }
}

Widget drawer(String nome, String email, context, Usuario usuario) {
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
                text: "Minhas informações",
                onClicked: () => selectedItem(context, 0, usuario)),
            menuItem(
                icon: Icons.class_rounded,
                text: "Minhas turmas",
                onClicked: () => selectedItem(context, 1, usuario)),
            menuItem(
                icon: Icons.event,
                text: "Eventos",
                onClicked: () => selectedItem(context, 2, usuario)),
            Divider(
              color: Colors.white,
            ),
            menuItem(
                icon: Icons.settings,
                text: "Configuração",
                onClicked: () => selectedItem(context, 3, usuario)),
            menuItem(
                icon: Icons.exit_to_app,
                text: "Sair",
                onClicked: () => selectedItem(context, 4, usuario)),
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

Future<void> selectedItem(
    BuildContext context, int index, Usuario usuario) async {
  switch (index) {
    case 0:
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => minhasInformacoes(usuario)));
      break;
    case 1:
      break;
    case 2:
      break;
    case 3:
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
