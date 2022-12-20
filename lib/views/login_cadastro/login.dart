import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:projeto_cbq/views/custom/input_custom.dart';
import 'package:projeto_cbq/Rotas.dart';
import 'package:projeto_cbq/controllers/logar_usuario.dart';
import 'package:projeto_cbq/controllers/validar_campos.dart';
import 'package:projeto_cbq/controllers/verificar_usuario_logado.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final validarCampos _controllerCampos = validarCampos();
  final verificarUsuarioLogado _controlerUsuarioLogado =
      verificarUsuarioLogado();
  var _controllerEmail = TextEditingController();
  var _controllerSenha = TextEditingController();

  @override
  void initState() {
    _controlerUsuarioLogado.verificaUsuarioLogado(context);
    super.initState();
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
                          _controllerCampos.mensagemErroLogar,
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        InputCustomizado(
                          controller: _controllerEmail,
                          hint: "E-mail",
                          type: TextInputType.emailAddress,
                          mensagem: _controllerCampos.errorBorderEmail
                              ? _controllerCampos.mensagemErro
                              : null,
                          icon: Icon(
                            Icons.email,
                            color: _controllerCampos.errorBorderEmail
                                ? Colors.red
                                : Colors.white,
                          ),
                          style: _controllerCampos.errorBorderEmail
                              ? TextStyle(color: Colors.red)
                              : TextStyle(color: Colors.white),
                        ),
                        Gap(10),
                        InputCustomizado(
                          controller: _controllerSenha,
                          hint: "senha",
                          type: TextInputType.text,
                          mensagem: _controllerCampos.errorBorderSenha
                              ? _controllerCampos.mensagemErro
                              : null,
                          obscure: true,
                          icon: Icon(Icons.lock,
                              color: _controllerCampos.errorBorderSenha
                                  ? Colors.red
                                  : Colors.white),
                          style: _controllerCampos.errorBorderSenha
                              ? TextStyle(color: Colors.red)
                              : TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    Gap(20),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _controllerCampos.email = _controllerEmail.text;
                          _controllerCampos.senha = _controllerSenha.text;
                          _controllerCampos.validarCamposTexto(context);
                        });
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
