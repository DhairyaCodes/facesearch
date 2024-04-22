  import 'package:flutter/material.dart';
  import 'package:rflutter_alert/rflutter_alert.dart';

import '../global/colors.dart';

  void ErrorDialog(BuildContext context, String errorMessage, {int success = 0}) {
      Alert(
        context: context,
        type: success == 1 ? AlertType.success : AlertType.error,
        title: success == 1 ? "Success" : "Error",
        style: AlertStyle(
          titleStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          titleTextAlign: success == 1 ? TextAlign.center : TextAlign.left
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