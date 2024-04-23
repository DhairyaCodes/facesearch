  import 'package:flutter/material.dart';
  import 'package:rflutter_alert/rflutter_alert.dart';

import '../global/colors.dart';

  void ErrorDialog(BuildContext context, String errorMessage, {int success = 0}) {
      Alert(
        context: context,
        type: success == 1 ? AlertType.success : AlertType.error,
        title: success == 1 ? "Success!" : "Error!",
        style: const AlertStyle(
          titleStyle:  TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          titleTextAlign: TextAlign.center 
        ),
        closeIcon: const SizedBox(),
        buttons: [
          DialogButton(
            onPressed: () => Navigator.of(context).pop(),
            color: kgreen,
            child: const Text(
              "OK",
              style: TextStyle(color: kwhite),
            ),
          ),
        ],
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            errorMessage,
            style: const TextStyle(fontSize: 14), textAlign: TextAlign.center,
          ),
        ),
      ).show();
    }