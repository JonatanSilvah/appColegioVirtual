import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class streamController {
  final controllerAlunos = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  
  adicionarListenerAlunos() async {
    final stream = FirebaseFirestore.instance
        .collection("usuarios")
        .doc("tipoUsuario")
        .collection("alunos")
        .snapshots();

    stream.listen((event) {
      controllerAlunos.add(event);
    });
  }
}