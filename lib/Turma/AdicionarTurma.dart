import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:projeto_cbq/model/ModelTurma.dart';

class AdicionarTurma extends StatefulWidget {
  const AdicionarTurma({super.key});

  @override
  State<AdicionarTurma> createState() => _AdicionarTurmaState();
}

class _AdicionarTurmaState extends State<AdicionarTurma> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  var _controllerNome = TextEditingController();
  var _controllerInicio = TextEditingController();
  var _controllerFinal = TextEditingController();

  List<DropdownMenuItem<String>> dropOpcoes = [];

  String? _escolhaDropDown;
  bool _errorBorderNome = false;
  bool _errorBorderAnoInicio = false;
  bool _errorBorderAnoFinal = false;
  bool _errorBorderCidade = false;
  String _mensagemErro = "";
  String _mensagemSucesso = "";

  _validarCampos() {
    String nomeTurma = _controllerNome.text;
    String anoInicio = _controllerInicio.text;
    String anoFinal = _controllerFinal.text;

    if (nomeTurma.isEmpty) {
      setState(() {
        _mensagemErro = "Por favor preencha o nome";
        _errorBorderNome = true;
      });
    } else if (_escolhaDropDown == null) {
      setState(() {
        _mensagemErro = "Por favor preencha a cidade";

        _errorBorderNome = false;
        _errorBorderCidade = true;
      });
    } else if (anoInicio.isEmpty) {
      setState(() {
        _mensagemErro = "Por favor preencha o ano de ínicio das aulas";
        _errorBorderAnoInicio = true;
        _errorBorderCidade = false;
        _errorBorderNome = false;
      });
    } else if (anoFinal.isEmpty) {
      setState(() {
        _mensagemErro = "Por favor preencha o ano de termino das aulas";
        _errorBorderAnoFinal = true;
        _errorBorderAnoInicio = false;
        _errorBorderNome = false;
        _errorBorderCidade = false;
      });
    } else {
      ModelTurma turma = ModelTurma();
      turma.nome = nomeTurma;
      turma.anoTurma = anoInicio;
      turma.anoFinal = anoFinal;
      turma.cidade = _escolhaDropDown!;

      _salvarTurma(turma);
    }
  }

  _salvarTurma(ModelTurma turma) async {
    await db.collection("turmas").add(turma.toMap());

    setState(() {
      _controllerNome.text = "";
      _controllerInicio.text = "";
      _controllerFinal.text = "";

      _mensagemSucesso = "Turma criada com sucesso!!!";
    });
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
    return Scaffold(
      appBar: AppBar(
          title: Text("Adicionar turma"), backgroundColor: Color(0xff344955)),
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
            child: Column(
          children: [
            TextField(
                controller: _controllerNome,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  hintText: "Nome da turma",
                  labelText: "Nome turma",
                  labelStyle: TextStyle(
                      color: _errorBorderNome ? Colors.red : Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  errorText: _errorBorderNome ? _mensagemErro : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black)),
                )),
            Gap(10),
            DropdownButtonFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorText: _errorBorderCidade ? _mensagemErro : null,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black)),
              ),
              icon: Icon(Icons.location_city),
              value: _escolhaDropDown,
              hint: Text("Escolha a cidade",
                  style: TextStyle(
                      color: _errorBorderCidade ? Colors.red : Colors.black)),
              items: dropOpcoes,
              onChanged: ((value) {
                setState(() {
                  _escolhaDropDown = value;
                });
              }),
            ),
            Gap(10),
            TextField(
                controller: _controllerInicio,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  hintText: "Ano de ínicio",
                  labelText: "Ano de ínicio",
                  labelStyle: TextStyle(
                      color: _errorBorderAnoInicio ? Colors.red : Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  errorText: _errorBorderAnoInicio ? _mensagemErro : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black)),
                )),
            Gap(10),
            TextField(
                controller: _controllerFinal,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  hintText: "Ano de termino",
                  labelText: "Ano de termino",
                  labelStyle: TextStyle(
                      color: _errorBorderAnoFinal ? Colors.red : Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  errorText: _errorBorderAnoFinal ? _mensagemErro : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black)),
                )),
            Gap(12),
            ElevatedButton(
              onPressed: () {
                _validarCampos();
              },
              child: Text(
                "Cadastrar",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Color(0xfff9aa33),
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            Gap(12),
            Text(
              _mensagemSucesso,
              style: TextStyle(color: Color(0xff70a83b)),
            )
          ],
        )),
      ),
    );
  }
}
