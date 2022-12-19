import 'package:flutter/material.dart';

class InputCustomizado extends StatelessWidget {
  var controller = TextEditingController();
  final String? mensagem;
  final String? hint;
  final bool? obscure;
  final Icon? icon;
  final TextInputType? type;
  InputCustomizado(
      {@required this.hint,
      this.obscure = false,
      this.icon = const Icon(Icons.person),
      required this.controller,
      this.mensagem,
      this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: TextField(
        keyboardType: this.type,
        controller: this.controller,
        obscureText: this.obscure!,
        decoration: InputDecoration(
            hoverColor: Color(0xff5f7481),
            fillColor: Color(0xff5f7481),
            border: InputBorder.none,
            errorText: this.mensagem,
            icon: this.icon,
            iconColor: Color(0xff5f7481),
            hintText: this.hint,
            hintStyle: TextStyle(color: Colors.grey[600])),
      ),
    );
  }
}
