import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projeto_cbq/controllers/validar_login.dart';
import 'package:projeto_cbq/views/custom/input_custom.dart';

class recuperarSenha extends StatefulWidget {
  const recuperarSenha({super.key});

  @override
  State<recuperarSenha> createState() => _recuperarSenhaState();
}

class _recuperarSenhaState extends State<recuperarSenha> {
  var _controllerEmail = TextEditingController();
  String _mensagemError = "";
  bool _errorBorderEmail = false;
  teste() async {
    String email = _controllerEmail.text;

    if (email.isEmpty) {
      setState(() {
        _errorBorderEmail = true;
        _mensagemError = "Email não pode ficar vazio";
        print(_mensagemError);
      });
    } else if (!GetUtils.isEmail(email)) {
      setState(() {
        _errorBorderEmail = true;
        _mensagemError = "Preencha com um email válido";
      });
    } else {
      setState(() {
        _mensagemError = "";
        _errorBorderEmail = false;
        _controllerEmail.text = "";
      });
      await _resetSenha(email);
    }
  }

  Future _resetSenha(email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    final snackbar = SnackBar(
      backgroundColor: Colors.green,
      content:
          Text("Email enviado, por favor verificar a caixa de entrada ou spam"),
      duration: Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recuperar senha"),
        backgroundColor: Color(0xff0b222c),
      ),
      body: Container(
        color: Color(0xff344955),
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              Text("Digite o email cadastrado\nPara recuperar sua senha",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xfff9aa33))),
              Gap(10),
              InputCustomizado(
                controller: _controllerEmail,
                hint: "E-mail",
                type: TextInputType.emailAddress,
                mensagem: _errorBorderEmail ? _mensagemError : null,
                icon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                style: _errorBorderEmail
                    ? TextStyle(color: Colors.red)
                    : TextStyle(color: Colors.white),
              ),
              Gap(12),
              InkWell(
                onTap: () {
                  setState(() {
                    teste();
                  });
                },
                child: Container(
                  height: 50,
                  child: Center(
                      child: Text(
                    "Recuperar",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          colors: [Color(0xffe3bb64), Color(0xfff9aa33)])),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
