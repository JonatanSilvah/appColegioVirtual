import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
import 'package:projeto_cbq/model/Usuario.dart';

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
        backgroundColor: Color(0xff344955),
        title: Text("Informações do aluno"),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 32, left: 16, right: 16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Card(
                      child: ListTile(
                    title: Text("Nome: ${widget.usuario.nome.toString()}"),
                  )),
                  Gap(5),
                  Divider(
                    color: Colors.black,
                  ),
                  Gap(5),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          "Email:",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 18),
                        ),
                        Gap(5),
                        Text(
                          widget.usuario.email.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Gap(5),
                  Divider(
                    color: Colors.black,
                  ),
                  Gap(5),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Data de Nascimento:",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 18),
                        ),
                        Gap(5),
                        Text(
                          widget.usuario.dataNasc.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Gap(5),
                  Divider(
                    color: Colors.black,
                  ),
                  Gap(5),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          "Celular:",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 18),
                        ),
                        Gap(5),
                        Text(
                          widget.usuario.celularUsuario.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Gap(5),
                  Divider(
                    color: Colors.black,
                  ),
                  Gap(5),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          "CPF:",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 18),
                        ),
                        Gap(5),
                        Text(
                          widget.usuario.cpfUsuario.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Gap(5),
                  Divider(
                    color: Colors.black,
                  ),
                  Gap(5),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          "Cidade:",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 18),
                        ),
                        Gap(5),
                        Text(
                          widget.usuario.cidadeUsuario.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
