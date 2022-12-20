import 'package:flutter/material.dart';
import 'package:projeto_cbq/Telas/splashScream.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Rotas.dart';
import 'views/login.dart';

final ThemeData temaPadrao =
    ThemeData(primaryColor: Color(0xff344955), accentColor: Color(0xfff9aa33));

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    theme: temaPadrao,
    title: "Colégio brasileiro de quiropraxia e terapias manuais",
    initialRoute: "/",
    onGenerateRoute: Rotas.gerarRotas,
    debugShowCheckedModeBanner: false,
    home: SplashScream(),
  ));
}
