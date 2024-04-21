import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/services.dart';
import '../../global/colors.dart';
import '../../reusable/dialog_box.dart';
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
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: Colors.accents,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SlideAnimationWidget(),
            ),
          ),
        ),
      ),
    );
  }
}

class SlideAnimationWidget extends StatefulWidget {
  @override
  _SlideAnimationWidgetState createState() => _SlideAnimationWidgetState();
}

class _SlideAnimationWidgetState extends State<SlideAnimationWidget> {
  bool _isContainerVisible = true;

  void _toggle() {
    setState(() {
      _isContainerVisible = !_isContainerVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                top: MediaQuery.of(context).size.height * 0.25,
                left: _isContainerVisible
                    ? 0
                    : -MediaQuery.of(context).size.width,
                child: AuthWidget(false, _toggle),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                top: MediaQuery.of(context).size.height * 0.15,
                left:
                    _isContainerVisible ? MediaQuery.of(context).size.width : 0,
                child: AuthWidget(true, _toggle),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AuthWidget extends StatefulWidget {
  final bool _isSignUp;
  final VoidCallback toggle;

  AuthWidget(this._isSignUp, this.toggle);

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _conPasswordController = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();
  final _conFocus = FocusNode();
  var _errorMessage = "";
  var _passVisible = false;
  var _ConPassVisible = false;
  // var email = "";
  // var password = "";

  @override
  void dispose() {
    _nameController;
    _emailController;
    _passwordController;
    _conPasswordController;
    _nameFocus;
    _passFocus;
    _conFocus;
    _emailFocus;
    super.dispose();
  }

  // void saveForm() {
  //   widget._isSignUp
  //       ? FirebaseAuth.instance
  //           .createUserWithEmailAndPassword(email: email, password: password)
  //       : FirebaseAuth.instance
  //           .signInWithEmailAndPassword(email: email, password: password);
  // }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: MediaQuery.of(context).size.height,
      width: width - 40,
      alignment: Alignment.center,
      child: Column(
        children: [
          widget._isSignUp
              ? TextFormField(
                  focusNode: _nameFocus,
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: kgrey)),
                    prefixIcon: const Icon(Icons.person, color: kblack),
                    label: const Text("Name"),
                  ),
                  // onTapOutside: (event) => Focus.of(context).unfocus(),
                  validator: (value) {
                    return value.toString().isEmpty ? "Required Field" : null;
                  },
                  onFieldSubmitted: (_) => _emailController.text.isEmpty
                      ? FocusScope.of(context).requestFocus(_emailFocus)
                      : null,
                  keyboardType: TextInputType.name,
                )
              : const SizedBox(),
          widget._isSignUp
              ? const SizedBox(
                  height: 30,
                )
              : const SizedBox(),
          TextFormField(
            focusNode: _emailFocus,
            controller: _emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: kgrey)),
              prefixIcon: const Icon(
                Icons.email_rounded,
                color: kblack,
              ),
              label: const Text("Email"),
            ),
            // onTapOutside: (event) => Focus.of(context).unfocus(),
            // validator: (value) {
            //   return value.toString().isEmpty ? "Required Field" : null;
            // },
            onFieldSubmitted: (value) => _passwordController.text.trim().isEmpty
                ? FocusScope.of(context).requestFocus(_passFocus)
                : null,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            focusNode: _passFocus,
            controller: _passwordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: kgrey)),
              prefixIcon: const Icon(Icons.key_rounded, color: kblack),
              label: const Text("Password"),
              suffixIcon: GestureDetector(
                onTap: () => setState(() {
                  _passVisible = !_passVisible;
                }),
                child: Icon(_passVisible
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded),
              ),
            ),
            // onTapOutside: (event) => Focus.of(context).unfocus(),
            validator: (value) {
              return value.toString().isEmpty ? "Required Field" : null;
            },
            onFieldSubmitted: (value) {
              setState(() {
                _passVisible = false;
              });
              widget._isSignUp
                  ? _conPasswordController.text.trim().isEmpty
                      ? FocusScope.of(context).requestFocus(_conFocus)
                      : null
                  : FocusScope.of(context).unfocus();
            },
            onTapOutside: (event) => setState(() {
              _passVisible = false;
            }),
            obscureText: !_passVisible,
            keyboardType: TextInputType.visiblePassword,
          ),
          widget._isSignUp
              ? const SizedBox(
                  height: 30,
                )
              : const SizedBox(),
          widget._isSignUp
              ? TextFormField(
                  controller: _conPasswordController,
                  focusNode: _conFocus,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: kgrey)),
                    prefixIcon: const Icon(Icons.key_rounded, color: kblack),
                    label: const Text("Confirm Password"),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() {
                        _ConPassVisible = !_ConPassVisible;
                      }),
                      child: Icon(_ConPassVisible
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded),
                    ),
                  ),
                  // onTapOutside: (event) => Focus.of(context).unfocus(),
                  validator: (value) {
                    return value.toString().isEmpty ? "Required Field" : null;
                  },
                  onFieldSubmitted: (_) {
                    setState(() {
                      _ConPassVisible = false;
                    });
                    FocusScope.of(context).unfocus();
                  },
                  onTapOutside: (event) => setState(() {
                    _ConPassVisible = false;
                  }),
                  obscureText: !_ConPassVisible,
                  keyboardType: TextInputType.visiblePassword,
                )
              : const SizedBox(),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: widget._isSignUp ? signUp : login,
            style: ButtonStyle(
                fixedSize: MaterialStatePropertyAll(
                  Size(width - 40, 50),
                ),
                backgroundColor: const MaterialStatePropertyAll(kblack),
                elevation: const MaterialStatePropertyAll(10),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)))),
            child: Text(
              widget._isSignUp ? "Sign Up" : "Login",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: kwhite),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                widget._isSignUp ? "Already have an Account?" : "New User?",
                style: const TextStyle(fontSize: 16),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _emailController.text = '';
                    _passwordController.text = '';
                    _conPasswordController.text = '';
                    _nameController.text = '';
                    FocusScope.of(context).unfocus();
                  });
                  widget.toggle();
                },
                child: Text(
                  widget._isSignUp ? "Login" : "Sign Up",
                  style: const TextStyle(fontSize: 20, color: Colors.blue),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: Divider(thickness: 2, color: kblack),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  "OR",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const Expanded(
                child: Divider(thickness: 2, color: kblack),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () => googleSignIn,
            style: ButtonStyle(
                fixedSize: MaterialStatePropertyAll(
                  Size(width - 40, 50),
                ),
                backgroundColor: const MaterialStatePropertyAll(kblack),
                elevation: const MaterialStatePropertyAll(10),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                    radius: 14,
                    backgroundColor: kblack.withOpacity(0),
                    child: Image.asset("assets/google.png")),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Continue with Google",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: kwhite),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> googleSignIn() async {
    // await FirebaseAuth.instance.signInWithProvider(GoogleAuthProvider());
  }

  Future<void> login() async {
    try {
      if (_emailController.text.trim().isEmpty) {
        ErrorDialog(context, "Please enter an email address.");
        FocusScope.of(context).requestFocus(_emailFocus);
      } else if (_passwordController.text.trim().isEmpty) {
        ErrorDialog(context, "Please enter password.");
        FocusScope.of(context).requestFocus(_passFocus);
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        switch (error.code) {
          case "user-not-found":
            _errorMessage = "No user found. Try signing up.";
            break;
          case "wrong-password":
            _errorMessage = "Incorrect password.";
            break;
          case "invalid-email":
            _errorMessage = "The email address is invalid.";
            break;
          case "user-disabled":
            _errorMessage = "This accound has been disabled.";
            break;
          default:
            _errorMessage = "An error occured. Please try again later";
        }
      });
      ErrorDialog(context, _errorMessage);
    } catch (error) {
      print(error);
    }
  }

  Future<void> signUp() async {
    try {
      if (_nameController.text.trim().isEmpty) {
        ErrorDialog(context, "Please enter your Name");
        FocusScope.of(context).requestFocus(_nameFocus);
      } else if (_emailController.text.trim().isEmpty) {
        ErrorDialog(context, "Please enter an email address");
        FocusScope.of(context).requestFocus(_emailFocus);
      } else if (_passwordController.text.trim().isEmpty) {
        ErrorDialog(context, "Please enter a password");
        FocusScope.of(context).requestFocus(_passFocus);
      } else if (_conPasswordController.text.trim() !=
          _passwordController.text.trim()) {
        ErrorDialog(context, "Passwords do not match");
        FocusScope.of(context).requestFocus(_conFocus);
      } else {
        final authResult =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // UserProviders.UserProvider().addUser(
        //     UserProviders.User(
        //       name: _nameController.text.trim(),
        //       email: _emailController.text.trim(),
        //     ),
        //     authResult.user!.uid);
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        switch (error.code) {
          case 'weak-password':
            _errorMessage = "Password used is too weak.";
            FocusScope.of(context).requestFocus(_passFocus);
            break;
          case 'email-already-in-use':
            _errorMessage = "Account already exists. Try logging in.";
            break;
          case 'invalid-email':
            _errorMessage = "Please enter a proper e-mail address.";
            FocusScope.of(context).requestFocus(_emailFocus);
            break;
          default:
            _errorMessage = 'An error occured. Please try again later.';
        }
      });
      ErrorDialog(context, _errorMessage);
    }
  }
}
