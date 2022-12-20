import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projeto_cbq/views/login.dart';

class SplashScream extends StatefulWidget {
  const SplashScream({super.key});

  @override
  State<SplashScream> createState() => _SplashScreamState();
}

class _SplashScreamState extends State<SplashScream> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: 250,
          width: 250,
          color: Color(0xfff9aa33),
          padding: EdgeInsets.all(60),
          child: Column(
            children: [
              Center(
                child: Text(
                  "LOGO",
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          )),
    );
  }
}
