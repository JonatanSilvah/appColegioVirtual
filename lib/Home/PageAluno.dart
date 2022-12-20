import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_cbq/views/login.dart';

class PageAluno extends StatefulWidget {
  const PageAluno({super.key});

  @override
  State<PageAluno> createState() => _PageAlunoState();
}

class _PageAlunoState extends State<PageAluno> {
  FirebaseAuth auth = FirebaseAuth.instance;

  _deslogar() {
    auth.signOut();
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (_) => Login()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Page aluno")),
      body: Container(
        child: ElevatedButton(
            onPressed: () {
              _deslogar();
            },
            child: Text("deslogar")),
      ),
    );
  }
}
