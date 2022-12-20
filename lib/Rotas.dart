import 'package:flutter/material.dart';
import 'package:projeto_cbq/views/Home/page_aluno.dart';

import 'package:projeto_cbq/views/login_cadastro/cadastro.dart';
import 'package:projeto_cbq/views/login_cadastro/login.dart';

import 'views/Home/page_admin.dart';


class Rotas {
  static const String ROTA_CADASTRO = "/cadastro";
  static const String ROTA_PAGEALUNO = "/page-aluno";
  static const String ROTA_PAGEADMIN = "/page-admin";

  static Route<dynamic> gerarRotas(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: ((_) => Login()));
      case ROTA_CADASTRO:
        return MaterialPageRoute(builder: ((_) => Cadastro()));
      case ROTA_PAGEALUNO:
        return MaterialPageRoute(builder: ((_) => PageAluno()));
      case ROTA_PAGEADMIN:
        return MaterialPageRoute(builder: ((_) => PageAdmin()));
      default:
        _erroRota();
    }
    return gerarRotas(settings);
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Tela não encontrada"),
        ),
        body: Center(child: Text("Tela não encontrada")),
      );
    });
  }
}
