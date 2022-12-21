import 'package:flutter/material.dart';
import 'package:projeto_cbq/views/splashScream/splash_scream.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Rotas.dart';

final ThemeData temaPadrao =
    ThemeData(primaryColor: Color(0xff344955), accentColor: Color(0xfff9aa33));

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    theme: temaPadrao,
    
    initialRoute: "/",
    onGenerateRoute: Rotas.gerarRotas,
    debugShowCheckedModeBanner: false,
    home: SplashScream(),
  ));
}
