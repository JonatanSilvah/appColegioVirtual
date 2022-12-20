import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:projeto_cbq/views/custom/input_custom.dart';
import 'package:projeto_cbq/models/modelTurma.dart';

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

  _validarCampos(BuildContext context) async {
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

      await _salvarTurma(context, turma);
    }
  }

  _salvarTurma(BuildContext context, ModelTurma turma) async {
    await db.collection("turmas").add(turma.toMap());

    Navigator.pop(context);
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
        title: Text("Adicionar turma"),
        backgroundColor: Color(0xff0b222c),
      ),
      body: Container(
        height: double.infinity,
        color: Color(0xff344955),
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
            child: Column(
          children: [
            InputCustomizado(
              hint: "Nome da turma",
              controller: _controllerNome,
              mensagem: _errorBorderNome ? _mensagemErro : null,
              icon: null,
              style: _errorBorderNome
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
                errorText: _errorBorderCidade ? _mensagemErro : null,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black)),
              ),
              icon: Icon(
                Icons.location_city,
                color: _errorBorderCidade ? Colors.red : Colors.black,
              ),
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
            InputCustomizado(
              hint: "Ano de ínicio",
              controller: _controllerInicio,
              type: TextInputType.number,
              mensagem: _errorBorderAnoInicio ? _mensagemErro : null,
              icon: null,
              style: _errorBorderAnoInicio
                  ? TextStyle(color: Colors.red)
                  : TextStyle(color: Colors.white),
            ),
            Gap(10),
            InputCustomizado(
              hint: "Ano de ínicio",
              controller: _controllerFinal,
              type: TextInputType.number,
              mensagem: _errorBorderAnoFinal ? _mensagemErro : null,
              icon: null,
              style: _errorBorderAnoFinal
                  ? TextStyle(color: Colors.red)
                  : TextStyle(color: Colors.white),
            ),
            Gap(12),
            ElevatedButton(
              onPressed: () {
                _validarCampos(context);
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
           
          ],
        )),
      ),
    );
  }
}
