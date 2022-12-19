import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:projeto_cbq/Home/Eventos.dart';
import 'package:projeto_cbq/Telas/InputCustomizado.dart';
import 'package:projeto_cbq/model/ModelEvento.dart';
import 'package:projeto_cbq/model/ModelTurma.dart';

class CriarEvento extends StatefulWidget {
  const CriarEvento({super.key});

  @override
  State<CriarEvento> createState() => _CriarEventoState();
}

class _CriarEventoState extends State<CriarEvento> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<DropdownMenuItem<String>> dropOpcoes = [];
  List<DropdownMenuItem<String>> dropOpcoesTurma = [];

  var _controllerNome = TextEditingController();
  var _controllerDescricao = TextEditingController();

  String? _escolhaDropDown;
  String? _escolhaDropDownTurma;
  bool _errorBorderNome = false;
  bool _errorBorderDataInicial = false;
  bool _errorBorderDataFinal = false;
  bool _errorBorderCidade = false;
  bool _errorBorderTurma = false;
  bool _errorBorderDescricao = false;
  String _mensagemErro = "";
  String _mensagemErroData = "";
  String _mensagemSucesso = "";

  DateTime dateInicial =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime dateFinal =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  _carregarOpcoesTurma() async {
    QuerySnapshot querySnapshot = await db.collection("turmas").get();

    for (DocumentSnapshot item in querySnapshot.docs) {
      var dados = item.data() as Map;

      setState(() {
        dropOpcoesTurma.add(DropdownMenuItem(
          child: Text(dados["nome"]),
          value: item.id,
        ));
      });
    }
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

  _validarCampos(BuildContext context) {
    var outputFormat = DateFormat('dd/MM/yyyy');
    var outputDateInicial = outputFormat.format(dateInicial);
    var outputDateFinal = outputFormat.format(dateFinal);

    String nome = _controllerNome.text;
    String descricao = _controllerDescricao.text;
    String dataInicial = outputDateInicial;
    String dataFinal = outputDateFinal;

    if (nome.isEmpty) {
      setState(() {
        _mensagemErro = "Por favor preencha o nome do evento";
        _errorBorderNome = true;
      });
    } else if (_escolhaDropDown == null) {
      setState(() {
        _mensagemErro = "Por favor preencha a cidade";
        _errorBorderNome = false;
        _errorBorderCidade = true;
      });
    } else if (_escolhaDropDownTurma == null) {
      setState(() {
        _mensagemErro = "Por favor preencha a turma";
        _errorBorderNome = false;
        _errorBorderCidade = false;
        _errorBorderTurma = true;
      });
    } else if (outputDateInicial.compareTo(outputDateFinal) == 1) {
      setState(() {
        _mensagemErroData = "A data final é menor que a data ínicial";
        _errorBorderNome = false;
        _errorBorderCidade = false;
        _errorBorderTurma = false;
        _errorBorderDataInicial = true;
        _errorBorderDataFinal = true;
      });
    } else if (descricao.isEmpty) {
      setState(() {
        _mensagemErroData = "";
        _mensagemErro = "Descrição não pode ficar vazia";
        _errorBorderNome = false;
        _errorBorderCidade = false;
        _errorBorderTurma = false;
        _errorBorderDataInicial = false;
        _errorBorderDataFinal = false;
        _errorBorderDescricao = true;
      });
    } else {
      setState(() {
        _mensagemErroData = "";
        _mensagemErro = "Descrição não pode ficar vazia";
        _errorBorderNome = false;
        _errorBorderCidade = false;
        _errorBorderTurma = false;
        _errorBorderDataInicial = false;
        _errorBorderDataFinal = false;
        _errorBorderDescricao = false;
      });

      ModelEvento evento = ModelEvento();

      evento.nomeEvento = nome;
      evento.cidadeEvento = _escolhaDropDown!;
      evento.turmaEvento = _escolhaDropDownTurma!;
      evento.dataInicial = dataInicial;
      evento.dataFinal = dataFinal;
      evento.descricao = descricao;
      _cadatrarEvento(context, evento);
    }
  }

  _cadatrarEvento(BuildContext context, ModelEvento evento) async {
    await db.collection("eventos").add(evento.toMap());
    await db
        .collection("turmas")
        .doc(evento.turmaEvento)
        .collection("eventos")
        .add(evento.toMap());

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _carregarItem();
    _carregarOpcoesTurma();
  }

  @override
  Widget build(BuildContext context) {
    var outputFormat = DateFormat('dd/MM/yyyy');
    var outputDateInicial = outputFormat.format(dateInicial);
    var outputDateFinal = outputFormat.format(dateFinal);
    return Scaffold(
      appBar: AppBar(
          title: Text("Criar evento"), backgroundColor: Color(0xff0b222c)),
      body: Container(
        color: Color(0xff344955),
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
            child: Column(
          children: [
            InputCustomizado(
              hint: "Nome do evento",
              type: TextInputType.name,
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
                ),
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
            DropdownButtonFormField(
              decoration: InputDecoration(
                fillColor: Color(0xfff9aa33),
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorText: _errorBorderTurma ? _mensagemErro : null,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: Icon(
                Icons.location_city,
                color: _errorBorderTurma ? Colors.red : Colors.black,
              ),
              value: _escolhaDropDownTurma,
              hint: Text("Escolha a turma",
                  style: TextStyle(
                      color: _errorBorderTurma ? Colors.red : Colors.black)),
              items: dropOpcoesTurma,
              onChanged: ((value) {
                setState(() {
                  _escolhaDropDownTurma = value;
                  print(_escolhaDropDownTurma);
                });
              }),
            ),
            Gap(10),
            Text(
              "Data de ínicio do evento: ",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Color(0xfff9aa33)),
            ),
            Gap(10),
            ElevatedButton(
              onPressed: () async {
                DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: dateInicial,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2030),
                );

                if (newDate == null) return;

                setState(() {
                  dateInicial = newDate;
                });
              },
              child: Text(
                "$outputDateInicial",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                  primary:
                      _errorBorderDataInicial ? Colors.red : Color(0xfff9aa33),
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
            ),
            Gap(10),
            Text(
              "Data de final do evento: ",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Color(0xfff9aa33)),
            ),
            Gap(10),
            ElevatedButton(
              onPressed: () async {
                DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: dateFinal,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2030),
                );

                if (newDate == null) return;

                setState(() {
                  dateFinal = newDate;
                });
              },
              child: Text(
                "$outputDateFinal",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                  primary:
                      _errorBorderDataFinal ? Colors.red : Color(0xfff9aa33),
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
            ),
            Text(
              _mensagemErroData,
              style: TextStyle(color: Colors.red),
            ),
            Gap(10),
            Text(
              "Descrição do evento:",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Color(0xfff9aa33)),
            ),
            TextField(
                controller: _controllerDescricao,
                maxLines: 5,
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  labelStyle: TextStyle(
                      color: _errorBorderDescricao
                          ? Colors.red
                          : Color(0xfff9aa33)),
                  filled: true,
                  fillColor: Color(0xffffdc65),
                  errorText: _errorBorderDescricao ? _mensagemErro : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xfff9aa33))),
                )),
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
                      borderRadius: BorderRadius.circular(8))),
            ),
          ],
        )),
      ),
    );
  }
}
