import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projeto_cbq/Telas/Login.dart';

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
          color: Colors.white,
          padding: EdgeInsets.all(60),
          child: Center(
            child: Image.asset(
              "images/logoCBQ.png",
              fit: BoxFit.cover,
            ),
          )),
    );
  }
}
