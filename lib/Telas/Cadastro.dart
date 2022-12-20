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

import '../models/user.dart';
import 'inputCustom.dart';

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
          backgroundColor: Color(0xff0b222c),
        ),
        body: Container(
          color: Color(0xff344955),
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InputCustomizado(
                hint: "Nome",
                controller: _controllerNome,
                type: TextInputType.name,
                mensagem: _errorBorderNome ? _mensagemErro : null,
                icon: Icon(
                  Icons.person,
                  color: _errorBorderNome ? Colors.red : Colors.white,
                ),
                style: _errorBorderNome
                    ? TextStyle(color: Colors.red)
                    : TextStyle(color: Colors.white),
              ),
              Gap(10),
              Row(
                children: [
                  Text(
                    "Data de nascimento: ",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color:
                            _errorBorderDataNasc ? Colors.red : Colors.white),
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
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: _errorBorderDataNasc
                            ? Colors.red
                            : Color(0xfff9aa33),
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  Gap(10),
                ],
              ),
              InputCustomizado(
                hint: "CPF (somente números)",
                controller: _controllerCPF,
                type: TextInputType.number,
                mensagem: _errorBorderCPF ? _mensagemErro : null,
                icon: null,
                style: _errorBorderCPF
                    ? TextStyle(color: Colors.red)
                    : TextStyle(color: Colors.white),
              ),
              Gap(10),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  fillColor: Color(0xfff9aa33),
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black)),
                ),
                icon: Icon(
                  Icons.location_city,
                  color: Colors.black,
                ),
                value: _escolhaDropDown,
                hint: const Text(
                  "Escolha a cidade",
                  style: TextStyle(color: Colors.black),
                ),
                items: dropOpcoes,
                onChanged: ((value) {
                  setState(() {
                    _escolhaDropDown = value;
                  });
                }),
              ),
              Gap(10),
              InputCustomizado(
                hint: "E-mail",
                controller: _controllerEmail,
                type: TextInputType.number,
                mensagem: _errorBorderEmail ? _mensagemErro : null,
                icon: null,
                style: _errorBorderEmail
                    ? TextStyle(color: Colors.red)
                    : TextStyle(color: Colors.white),
              ),
              Gap(10),
              InputCustomizado(
                hint: "Celular",
                controller: _controllerCelular,
                type: TextInputType.number,
                mensagem: _errorBorderCelular ? _mensagemErro : null,
                icon: null,
                style: _errorBorderCelular
                    ? TextStyle(color: Colors.red)
                    : TextStyle(color: Colors.white),
              ),
              Gap(10),
              InputCustomizado(
                hint: "Senha",
                controller: _controllerSenha,
                type: TextInputType.number,
                mensagem: _errorBorderSenha ? _mensagemErro : null,
                icon: null,
                style: _errorBorderSenha
                    ? TextStyle(color: Colors.red)
                    : TextStyle(color: Colors.white),
              ),
              Gap(10),
              InputCustomizado(
                hint: "Senha",
                controller: _controllerConfSenha,
                type: TextInputType.number,
                mensagem: _errorBorderSenha ? _mensagemErro : null,
                icon: null,
                style: _errorBorderSenha
                    ? TextStyle(color: Colors.red)
                    : TextStyle(color: Colors.white),
              ),
              Gap(12),
              InkWell(
                onTap: () {
                  _validarCampos();
                },
                child: Container(
                  height: 50,
                  child: Center(
                      child: Text(
                    "Cadastrar",
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
          )),
        ));
  }
}
