import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:projeto_cbq/views/custom/input_custom.dart';
import 'package:projeto_cbq/views/login_cadastro/login.dart';

class verifyEmailPage extends StatefulWidget {
  const verifyEmailPage({super.key});

  @override
  State<verifyEmailPage> createState() => _verifyEmailPageState();
}

class _verifyEmailPageState extends State<verifyEmailPage> {
  bool emailVerificado = false;
  bool reenviarEmail = false;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailVerificado = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!emailVerificado) {
      enviarVerificadorEmail();
      timer = Timer.periodic(
          Duration(seconds: 3), (timer) => checkEmailVerificado());
    }
    enviarVerificadorEmail();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerificado() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      emailVerificado = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (emailVerificado) {
      timer?.cancel();

      final snackbar = SnackBar(
        backgroundColor: Colors.green,
        content: Text("Email verificado com sucesso."),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future enviarVerificadorEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => reenviarEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => reenviarEmail = true);
    } catch (e) {}
  }

  Widget bottum() {
    return InkWell(
      onTap: () {
        FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => Login()), (route) => false);
      },
      child: Container(
        height: 50,
        child: Center(
            child: Text(
          "Login",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        )),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient:
                LinearGradient(colors: [Color(0xffe3bb64), Color(0xfff9aa33)])),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Verificar email"), backgroundColor: Color(0xff0b222c)),
      body: Container(
        padding: EdgeInsets.all(16),
        color: Color(0xff344955),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Verifique a caixa de entrada ou a caixa de spam do seu email.\nApós verificar seu email, Botão de login será habilitado.",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Gap(15),
            InkWell(
              onTap: reenviarEmail ? enviarVerificadorEmail : null,
              child: Container(
                height: 50,
                child: Center(
                    child: Text(
                  "Reenviar email",
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
            Gap(12),
            InkWell(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => Login()),
                    (route) => false);
              },
              child: Container(
                height: 50,
                child: Center(
                    child: Text(
                  "Cencelar",
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
            Gap(12),
            emailVerificado ? bottum() : Container()
          ],
        )),
      ),
    );
  }
}
