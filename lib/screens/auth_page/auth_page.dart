import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/services.dart';
import '../../global/colors.dart';
import '../../reusable/dialog_box.dart';
import 'slide_animation.dart';
// import '../providers/provider.dart' as UserProviders;

class AuthPage extends StatefulWidget {
  static const routeName = "/AuthPage";

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  var _exit = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Alert(
          context: context,
          type: AlertType.warning,
          title: "Caution!",
          style: const AlertStyle(
            titleStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          closeIcon: const SizedBox(),
          buttons: [
            DialogButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _exit = true;
                });
                SystemNavigator.pop();
              },
              color: kwhite,
              child: const Text(
                "YES",
                style: TextStyle(color: kgrey),
              ),
            ),
            DialogButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: kblack,
              child: const Text(
                "NO",
                style: TextStyle(color: kwhite),
              ),
            ),
          ],
          content: const Text(
            "Are you sure you want to exit the app?",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ).show();

        return _exit;
      },
      child: GestureDetector(
        onTap: () {
          // Unfocus the keyboard when the user taps outside the TextFormField.
          final currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild!.unfocus();
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: SizedBox(
              width: width,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(0, 32, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 160,
                      width: 160,
                      child: Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    SizedBox(height: 32,),
                    Text(
                      "Welcome to Face Search by Systemic Altruism",
                      style: TextStyle(fontSize: 24),textAlign:TextAlign.center,
                    ),
                    SizedBox(
                        height: height - 124, child: SlideAnimationWidget()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
