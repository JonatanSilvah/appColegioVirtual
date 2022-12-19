import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:projeto_cbq/Home/PageAluno.dart';
import 'package:projeto_cbq/Rotas.dart';

import '../model/Usuario.dart';
import 'InputCustomizado.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerConfSenha = TextEditingController();
  TextEditingController _controllerCPF = TextEditingController();
  TextEditingController _controllerCelular = TextEditingController();

  List<DropdownMenuItem<String>> dropOpcoes = [];

  String? _escolhaDropDown;

  bool _errorBorderNome = false;
  bool _errorBorderEmail = false;
  bool _errorBorderSenha = false;
  bool _errorBorderDataNasc = false;
  bool _errorBorderCPF = false;
  bool _errorBorderCelular = false;

  String _mensagemErro = "";

  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  _validarCampos() {
    var outputFormat = DateFormat('dd/MM/yyyy');
    var outputDate = outputFormat.format(date);
    String nome = _controllerNome.text.trim();
    String email = _controllerEmail.text.trim();
    String senha = _controllerSenha.text.trim();
    String confSenha = _controllerConfSenha.text.trim();
    DateTime dateNow =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    String dataNow = "${dateNow.day}/${dateNow.month}/${dateNow.year}";
    String dataNasc = outputDate;
    String cpf = _controllerCPF.text.trim();
    String celular = _controllerCelular.text.trim();
    String? cidade = _escolhaDropDown;

    if (nome.isEmpty) {
      setState(() {
        _mensagemErro = "Por favor preencha o nome";
        _errorBorderNome = true;
      });
    } else if (dataNasc == dataNow) {
      setState(() {
        _errorBorderDataNasc = true;
        _errorBorderNome = false;
        _errorBorderEmail = false;
        _errorBorderSenha = false;
        _errorBorderCPF = false;
        _errorBorderCelular = false;
      });
    } else if (CPFValidator.isValid(cpf) == false) {
      setState(() {
        _errorBorderCPF = true;
        _mensagemErro = "CPF inválido";
        _errorBorderDataNasc = false;
        _errorBorderNome = false;
        _errorBorderEmail = false;
        _errorBorderSenha = false;
        _errorBorderCelular = false;
      });
    } else if (email.isEmpty) {
      setState(() {
        _mensagemErro = "Preencha o email";
        _errorBorderEmail = true;
        _errorBorderNome = false;
        _errorBorderCPF = false;
        _errorBorderDataNasc = false;
        _errorBorderSenha = false;
        _errorBorderCelular = false;
      });
    } else if (!GetUtils.isEmail(email)) {
      setState(() {
        _mensagemErro = "Preencha o email com um e-mail válido";
        _errorBorderEmail = true;
        _errorBorderNome = false;
        _errorBorderCPF = false;
        _errorBorderDataNasc = false;
        _errorBorderSenha = false;
        _errorBorderCelular = false;
      });
    } else if (celular.isEmpty) {
      setState(() {
        _mensagemErro = "Preencha o telefone celular";
        _errorBorderCelular = true;
        _errorBorderSenha = false;
        _errorBorderEmail = false;
        _errorBorderNome = false;
        _errorBorderCPF = false;
        _errorBorderDataNasc = false;
      });
    } else if (senha.isEmpty && senha.length < 6) {
      setState(() {
        _mensagemErro = "Preenche a senha e utilize mais de 6 caracteres";
        _errorBorderSenha = true;
        _errorBorderNome = false;
        _errorBorderEmail = false;
        _errorBorderCPF = false;
        _errorBorderDataNasc = false;
        _errorBorderCelular = false;
      });
    } else if (senha != confSenha) {
      setState(() {
        _mensagemErro = "As senhas não estão iguais";
        _errorBorderSenha = true;
        _errorBorderNome = false;
        _errorBorderEmail = false;
        _errorBorderCPF = false;
        _errorBorderDataNasc = false;
        _errorBorderCelular = false;
      });
    } else {
      setState(() {
        _mensagemErro = "";
        _errorBorderNome = false;
        _errorBorderEmail = false;
        _errorBorderSenha = false;
        _errorBorderDataNasc = false;
        _errorBorderCPF = false;
        _errorBorderCelular = false;
      });
      Usuario usuario = Usuario();
      usuario.nome = nome;
      usuario.senha = senha;
      usuario.email = email;
      usuario.dataNasc = dataNasc;
      usuario.cpfUsuario = cpf;
      usuario.celularUsuario = celular;
      usuario.cidadeUsuario = cidade!;

      _cadastrarUsuario(usuario);
    }
  }

  Future _cadastrarUsuario(Usuario usuario) async {
    await auth
        .createUserWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((value) {
      usuario.idUsuario = value.user!.uid;

      db
          .collection("usuarios")
          .doc("tipoUsuario")
          .collection("alunos")
          .doc(usuario.idUsuario)
          .set(usuario.toMap());

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => PageAluno()), (route) => false);
    }).catchError((error) {});
  }

  _carregarItem() {
    dropOpcoes.add(DropdownMenuItem(
      child: Text("Pouso Alegre"),
      value: "Pouso Alegre",
    ));
    dropOpcoes.add(DropdownMenuItem(
      child: Text("Belo Horizonte"),
      value: "Belo Horizonte",
    ));
  }

  @override
  void initState() {
    super.initState();
    _carregarItem();
  }

  @override
  Widget build(BuildContext context) {
    var outputFormat = DateFormat('dd/MM/yyyy');
    var outputDate = outputFormat.format(date);
    return Scaffold(
        appBar: AppBar(
          title: Text("Cadastro"),
          backgroundColor: Color(0xffe3bb64),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                  controller: _controllerNome,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    hintText: "Nome completo",
                    labelText: "Nome completo",
                    labelStyle: TextStyle(
                        color:
                            _errorBorderNome ? Colors.red : Color(0xff70a83b)),
                    filled: true,
                    fillColor: Colors.white,
                    errorText: _errorBorderNome ? _mensagemErro : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xff74ac3c))),
                  )),
              Gap(10),
              Row(
                children: [
                  Text(
                    "Data de nascimento: ",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color:
                            _errorBorderDataNasc ? Colors.red : Colors.black),
                  ),
                  Gap(10),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (newDate == null) return;

                      setState(() {
                        date = newDate;
                      });
                    },
                    child: Text(
                      "$outputDate",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: _errorBorderDataNasc
                            ? Colors.red
                            : Color(0xff70a83b),
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  Gap(10),
                ],
              ),
              TextField(
                  controller: _controllerCPF,
                  maxLength: 11,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    hintText: "CPF (somente números) ",
                    labelText: "CPF",
                    labelStyle: TextStyle(
                        color:
                            _errorBorderCPF ? Colors.red : Color(0xff70a83b)),
                    filled: true,
                    fillColor: Colors.white,
                    errorText: _errorBorderCPF ? _mensagemErro : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xff74ac3c))),
                  )),
              Gap(10),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xff74ac3c))),
                ),
                icon: Icon(Icons.location_city),
                value: _escolhaDropDown,
                hint: const Text("Escolha a cidade"),
                items: dropOpcoes,
                onChanged: ((value) {
                  setState(() {
                    _escolhaDropDown = value;
                  });
                }),
              ),
              Gap(10),
              TextField(
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    hintText: "E-mail",
                    labelText: "E-mail",
                    labelStyle: TextStyle(
                        color:
                            _errorBorderEmail ? Colors.red : Color(0xff70a83b)),
                    filled: true,
                    fillColor: Colors.white,
                    errorText: _errorBorderEmail ? _mensagemErro : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xff70a83b))),
                  )),
              Gap(10),
              TextField(
                  maxLength: 11,
                  controller: _controllerCelular,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    hintText: "Celular",
                    labelText: "Celular",
                    labelStyle: TextStyle(
                        color: _errorBorderCelular
                            ? Colors.red
                            : Color(0xff70a83b)),
                    filled: true,
                    fillColor: Colors.white,
                    errorText: _errorBorderCelular ? _mensagemErro : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xff70a83b))),
                  )),
              Gap(10),
              TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    hintText: "Senha",
                    labelText: "Senha",
                    labelStyle: TextStyle(
                        color:
                            _errorBorderSenha ? Colors.red : Color(0xff70a83b)),
                    filled: true,
                    fillColor: Colors.white,
                    errorText: _errorBorderSenha ? _mensagemErro : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xff70a83b))),
                  )),
              Gap(10),
              TextField(
                  controller: _controllerConfSenha,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    hintText: "Confirmar senha",
                    labelText: "confirmar senha",
                    labelStyle: TextStyle(
                        color:
                            _errorBorderSenha ? Colors.red : Color(0xff70a83b)),
                    filled: true,
                    fillColor: Colors.white,
                    errorText: _errorBorderSenha ? _mensagemErro : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xff70a83b))),
                  )),
              Gap(12),
              ElevatedButton(
                onPressed: () {
                  _validarCampos();
                },
                child: Text(
                  "Cadastrar",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Color(0xff70a83b),
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32))),
              ),
            ],
          )),
        ));
  }
}
