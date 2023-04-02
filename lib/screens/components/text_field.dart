import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  String hintText;
  String labelText;
  TextInputType textInputType;
  TextEditingController controller;
  IconButton? iconButton;
  IconData prefixIcon;
  int? maxLength;
  TextFieldWidget(
      {required this.controller,
      required this.hintText,
      required this.labelText,
      required this.textInputType,
      required this.prefixIcon,
      this.maxLength,
      this.iconButton});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.cyan),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.cyan),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.cyan),
          ),
          hintText: hintText,
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.cyan
          ),
          prefixIcon: Icon(prefixIcon),
          suffixIcon: iconButton),
      keyboardType: textInputType,
      controller: controller,
      maxLength: maxLength,
    );
  }
}
