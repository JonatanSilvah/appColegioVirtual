import 'dart:ffi';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:projeto_cbq/Telas/cadastro.dart';
import 'package:projeto_cbq/Telas/inputCustom.dart';
import 'package:projeto_cbq/Rotas.dart';

import '../model/user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  var _controllerEmail = TextEditingController();
  var _controllerSenha = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  AnimationController? _controller;

  Animation<double>? _animacaoSize;

  String? _tipoUsuario;
  String? _idUsuario;
  String? _mensagemErro = "";
  String? _mensagemErroLogar = "";
  bool _errorBorderEmail = false;
  bool _errorBorderSenha = false;

  _validarCampos() {
    String email = _controllerEmail.text.trim();
    String senha = _controllerSenha.text.trim();

    if (email.isEmpty) {
      setState(() {
        _mensagemErro = "Preencha o email";
        _errorBorderEmail = true;
        _errorBorderSenha = false;
      });
    } else if (!GetUtils.isEmail(email)) {
      setState(() {
        _mensagemErro = "Preencha o email com um e-mail válido";
        _errorBorderEmail = true;
        _errorBorderSenha = false;
      });
    } else if (senha.isEmpty) {
      setState(() {
        _mensagemErro = "Preenche a senha";
        _errorBorderSenha = true;
        _errorBorderEmail = false;
      });
    } else {
      setState(() {
        _mensagemErro = "";
        _errorBorderEmail = false;
        _errorBorderSenha = false;
      });
      Usuario usuario = Usuario();

      usuario.senha = senha;
      usuario.email = email;
      _logarUsuario(usuario);
    }
  }

  _logarUsuario(Usuario usuario) async {
    auth
        .signInWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((value) async {
      setState(() {
        _idUsuario = value.user!.uid;
      });

      final snapshot = await db.collection("usuarios").doc(_idUsuario).get();

      final dados = snapshot.data();

      setState(() {
        _tipoUsuario = dados!["tipo"];
      });
      if (_tipoUsuario == "aluno") {
        Navigator.pushNamedAndRemoveUntil(
            context, "/page-aluno", (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, "/page-admin", (route) => false);
      }
    }).catchError((Error) {
      setState(() {
        _mensagemErroLogar = "Não foi possível logar, verifique email e senha!";
      });
    });
  }

  _verificarUsuarioLogado() async {
    User? usuarioAtual = await auth.currentUser;

    if (usuarioAtual != null) {
      setState(() {
        _idUsuario = usuarioAtual.uid;
      });
      final snapshot = await db.collection("usuarios").doc(_idUsuario).get();

      final dados = snapshot.data();

      setState(() {
        _tipoUsuario = dados!["tipoUsuario"];
      });

      if (_tipoUsuario == "aluno") {
        Navigator.pushNamedAndRemoveUntil(
            context, "/page-aluno", (route) => false);
      } else if (_tipoUsuario == "gestor") {
        Navigator.pushNamedAndRemoveUntil(
            context, "/page-admin", (route) => false);
      }
    }
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    super.initState();

    _controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    _animacaoSize = Tween<double>(begin: 0, end: 1000).animate(
        CurvedAnimation(parent: _controller!, curve: Curves.decelerate));

    _controller!.forward();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Color(0xff344955),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: 350,
                  width: 250,
                  /*  decoration: BoxDecoration(
                     image: DecorationImage(
                      image: AssetImage(
                        "images/logoCBQ.png",
                      ),
                      fit: BoxFit.contain),
                    ),*/
                  color: Color(0xfff9aa33),
                  child: Center(
                    child: Text(
                      "LOGO",
                      style: TextStyle(color: Colors.black),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          _mensagemErroLogar!,
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        InputCustomizado(
                          controller: _controllerEmail,
                          hint: "E-mail",
                          type: TextInputType.emailAddress,
                          mensagem: _errorBorderEmail ? _mensagemErro : null,
                          icon: Icon(
                            Icons.email,
                            color:
                                _errorBorderEmail ? Colors.red : Colors.white,
                          ),
                          style: _errorBorderEmail
                              ? TextStyle(color: Colors.red)
                              : TextStyle(color: Colors.white),
                        ),
                        Gap(10),
                        InputCustomizado(
                          controller: _controllerSenha,
                          hint: "senha",
                          type: TextInputType.text,
                          mensagem: _errorBorderSenha ? _mensagemErro : null,
                          obscure: true,
                          icon: Icon(Icons.lock,
                              color: _errorBorderSenha
                                  ? Colors.red
                                  : Colors.white),
                          style: _errorBorderSenha
                              ? TextStyle(color: Colors.red)
                              : TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    Gap(20),
                    InkWell(
                      onTap: () {
                        _validarCampos();
                      },
                      child: Container(
                        height: 50,
                        child: Center(
                            child: Text(
                          "Entrar",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(colors: [
                              Color(0xffe3bb64),
                              Color(0xfff9aa33)
                            ])),
                      ),
                    ),
                    Gap(12),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/cadastro");
                      },
                      child: Container(
                        height: 50,
                        child: Center(
                            child: Text(
                          "Cadastrar",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(colors: [
                              Color(0xffe3bb64),
                              Color(0xfff9aa33)
                            ])),
                      ),
                    ),
                    Gap(12),
                    Text(
                      "Esqueci minha senha",
                      style: TextStyle(
                          color: Color(0xfff9aa33),
                          fontWeight: FontWeight.bold),
                    ),
                    Gap(25)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
