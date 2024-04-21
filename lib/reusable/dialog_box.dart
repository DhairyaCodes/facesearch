  import 'package:flutter/material.dart';
  import 'package:rflutter_alert/rflutter_alert.dart';

import '../global/colors.dart';

  void ErrorDialog(BuildContext context, String errorMessage) {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error",
        style: const AlertStyle(
          titleStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        closeIcon: const SizedBox(),
        buttons: [
          DialogButton(
            onPressed: () => Navigator.of(context).pop(),
            color: kblack,
            child: const Text(
              "OK",
              style: TextStyle(color: kwhite),
            ),
          ),
        ],
        content: Text(
          errorMessage,
          style: const TextStyle(fontSize: 14),
        ),
      ).show();
    }