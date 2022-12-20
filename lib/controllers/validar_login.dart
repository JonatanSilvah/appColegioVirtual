import 'package:flutter/material.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:projeto_cbq/controllers/logar_usuario.dart';

import '../models/user.dart';

class validarCampos {
  String? _email;
  String? _senha;
  bool errorBorderEmail = false;
  bool errorBorderSenha = false;
  String? mensagemErro;
  String mensagemErroLogar = "";

  String get senha => _senha!;
  set senha(String value) {
    _senha = value;
  }

  String get email => _email!;
  set email(String value) {
    _email = value;
  }

  final logarUsuario _controllerLogar = logarUsuario();
  validarCamposTexto(context) {
    String emailLogin = this.email;
    String senhaLogin = this.senha;

    if (email.isEmpty) {
      this.mensagemErro = "Preencha o email";
      this.errorBorderEmail = true;
      errorBorderSenha = false;
      print(this.errorBorderEmail);
    } else if (!GetUtils.isEmail(email)) {
      mensagemErro = "Preencha o email com um e-mail válido";
      this.errorBorderEmail = true;
      errorBorderSenha = false;
    } else if (senha.isEmpty) {
      mensagemErro = "Preenche a senha";
      errorBorderSenha = true;
      errorBorderEmail = false;
    } else {
      mensagemErro = "";
      errorBorderEmail = false;
      errorBorderSenha = false;
      Usuario usuario = Usuario();

      usuario.senha = senha;
      usuario.email = email;
      _controllerLogar.logarUser(usuario, context);
      mensagemErroLogar = _controllerLogar.mensagemErroLogar;
      
    }
  }
}
