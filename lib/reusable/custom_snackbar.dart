import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    elevation: 10,
    duration: Duration(seconds: 3),
    content: Text(message),
    dismissDirection: DismissDirection.horizontal,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
