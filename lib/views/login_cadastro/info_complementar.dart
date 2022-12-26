import 'package:flutter/material.dart';
import 'package:http/http.dart' as htpp;
import 'dart:convert';

class infoComplementar extends StatefulWidget {
  const infoComplementar({super.key});

  @override
  State<infoComplementar> createState() => _infoComplementarState();
}

class _infoComplementarState extends State<infoComplementar> {
  TextEditingController _controllerCep = TextEditingController();
  String logradouro = "";
  String bairro = "";
  String localidade = "";
  String uf = "";
  String _resultado = "Resultado da pesquisa";

  recuperarCep() async {
    String cep = _controllerCep.text;
    if (cep.length < 8) {
      setState(() {
        _resultado = "CEP precisa ter no minimo 8 numeros";
      });
    } else {
      String url = "https://viacep.com.br/ws/${cep}/json/";

      htpp.Response response;

      response = await htpp.get(Uri.parse(url));

      Map<String, dynamic> retorno = json.decode(response.body);
      logradouro = retorno["logradouro"];
      bairro = retorno["bairro"];
      localidade = retorno["localidade"];
      uf = retorno["uf"];

      setState(() {
        if (logradouro == null &&
            bairro == null &&
            localidade == null &&
            uf == null) {
          _resultado = "CEP Invalido ou não localizado";
        } else {
          _resultado =
              "Logradouro: $logradouro, bairro: $bairro, cidade: $localidade, estado: $uf";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
