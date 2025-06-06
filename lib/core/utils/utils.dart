import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: Duration(seconds: 1),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
