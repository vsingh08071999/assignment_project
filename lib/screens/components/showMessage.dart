import 'package:flutter/material.dart';

class Message {
  getErrorMessage(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          message.toString(),
          // "Contact added successfully",
          style: TextStyle(color: Colors.white),
        )));
  }

  getSuccessfulMessage(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        )));
  }
}
