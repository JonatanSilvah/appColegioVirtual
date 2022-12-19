import 'package:flutter/material.dart';

class InputCustomizado extends StatelessWidget {
  var controller = TextEditingController();
  final String? mensagem;
  final String? hint;
  final bool? obscure;
  final Icon? icon;
  final TextInputType? type;
  final TextStyle? style;
  InputCustomizado(
      {@required this.hint,
      this.obscure = false,
      this.icon = const Icon(Icons.person),
      required this.controller,
      this.mensagem,
      this.type, this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xff5f7481),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      padding: EdgeInsets.all(8),
      child: TextField(
        style: TextStyle(color: Colors.white),
        keyboardType: this.type,
        controller: this.controller,
        obscureText: this.obscure!,
        decoration: InputDecoration(
            filled: true,
            hoverColor: Color(0xff5f7481),
            fillColor: Color(0xff55f7481),
            border: InputBorder.none,
            labelStyle: TextStyle(color: Colors.white),
            errorText: this.mensagem,
            icon: this.icon,
            iconColor: Colors.white,
            hintText: this.hint,
            hintStyle: this.style),
      ),
    );
  }
}
