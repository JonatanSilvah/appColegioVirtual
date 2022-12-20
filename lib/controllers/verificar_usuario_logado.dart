import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart';
import 'package:projeto_cbq/Rotas.dart';

class verificarUsuarioLogado {
  
  verificaUsuarioLogado(context) async {
    String? _tipoUsuario;
  String? _idUsuario;

     FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
    User? usuarioAtual = await auth.currentUser;

    if (usuarioAtual != null) {
       _idUsuario = usuarioAtual.uid;
      final snapshot = await db.collection("usuarios").doc(_idUsuario).get();

      final dados = snapshot.data();
       _tipoUsuario = dados!["tipoUsuario"];
      

      if (_tipoUsuario == "aluno") {
        Navigator.pushNamedAndRemoveUntil(
            context, "/page-aluno", (route) => false);
      } else if (_tipoUsuario == "gestor") {
        Navigator.pushNamedAndRemoveUntil(
            context, "/page-admin", (route) => false);
      }
    }
  }

}