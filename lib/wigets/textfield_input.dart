import 'package:flutter/material.dart';

class TextfieldInput extends StatelessWidget {
  final textEditingController;
  final hintText;
  final keyboardType;
  final ispass;
  const TextfieldInput(
      {super.key,
      required this.textEditingController,
      required this.hintText,
      required this.ispass,
      required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        fillColor: Colors.grey[800],
        filled: true,
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
      ),
      keyboardType: keyboardType,
      obscureText: ispass,
    );
  }
}
