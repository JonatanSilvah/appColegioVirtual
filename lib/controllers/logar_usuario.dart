import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart';

import '../models/user.dart';
import 'dart:async';

class logarUsuario {
  String mensagemErroLogar = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  logarUser(Usuario usuario, context) async {
    String? _tipoUsuario;
    String? _idUsuario;

    auth
        .signInWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((value) async {
      _idUsuario = value.user!.uid;

      final snapshot = await db
          .collection("usuarios")
          .doc("tipoUsuario")
          .collection("alunos")
          .doc(_idUsuario)
          .get();
      final snapshotGestor =
          await db.collection("usuarios").doc(_idUsuario).get();

      final dados = snapshot.data();

      final dadosGestor = snapshotGestor.data();

      if (dados != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, "/page-aluno", (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, "/page-admin", (route) => false);
      }
    }).catchError((Error) {
      mensagemErroLogar = "Não foi possível logar, verifique email e senha!";
    });
  }
}
