import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
import 'package:projeto_cbq/model/user.dart';

class InfoAluno extends StatefulWidget {
  Usuario usuario;
  InfoAluno(this.usuario);

  @override
  State<InfoAluno> createState() => _InfoAlunoState();
}

class _InfoAlunoState extends State<InfoAluno> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0b222c),
        title: Text("Informações do aluno"),
      ),
      body: Container(
        color: Color(0xff344955),
        padding: EdgeInsets.only(top: 32, left: 16, right: 16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Nome:",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      Gap(5),
                      Text(
                        widget.usuario.nome.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xfff9aa33)),
                      ),
                    ],
                  ),
                  Gap(7),
                  Divider(
                    color: Colors.white,
                  ),
                  Gap(7),
                  Row(
                    children: [
                      Text(
                        "Email:",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      Gap(5),
                      Text(
                        widget.usuario.email.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xfff9aa33)),
                      ),
                    ],
                  ),
                  Gap(7),
                  Divider(
                    color: Colors.white,
                  ),
                  Gap(7),
                  Row(
                    children: [
                      Text(
                        "Data de nascimento:",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      Gap(5),
                      Text(
                        widget.usuario.dataNasc.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xfff9aa33)),
                      ),
                    ],
                  ),
                  Gap(7),
                  Divider(
                    color: Colors.white,
                  ),
                  Gap(7),
                  Row(
                    children: [
                      Text(
                        "Celular:",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      Gap(5),
                      Text(
                        widget.usuario.celularUsuario.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xfff9aa33)),
                      ),
                    ],
                  ),
                  Gap(7),
                  Divider(
                    color: Colors.white,
                  ),
                  Gap(7),
                  Row(
                    children: [
                      Text(
                        "CPF:",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      Gap(5),
                      Text(
                        widget.usuario.cpfUsuario.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xfff9aa33)),
                      ),
                    ],
                  ),
                  Gap(7),
                  Divider(
                    color: Colors.white,
                  ),
                  Gap(7),
                  Row(
                    children: [
                      Text(
                        "Cidade:",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      Gap(5),
                      Text(
                        widget.usuario.cidadeUsuario.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xfff9aa33)),
                      ),
                    ],
                  ),
                  Gap(5),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
