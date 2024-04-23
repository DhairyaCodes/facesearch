import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../global/colors.dart';
import '../../reusable/dialog_box.dart';

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

  Future<void> signinGoogle() async{
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth!.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: MediaQuery.of(context).size.height,
      width: width - 40,
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          widget._isSignUp
              ? TextFormField(
                  focusNode: _nameFocus,
                  controller: _nameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    prefixIcon: const Icon(Icons.person, color: kgreen),
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
              contentPadding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              prefixIcon: const Icon(
                Icons.email_rounded,
                color: kgreen,
              ),
              label: const Text(
                "Email",
                style: TextStyle(color: kwhite),
              ),
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
              contentPadding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              prefixIcon: const Icon(Icons.key_rounded, color: kgreen),
              label: const Text(
                "Password",
                style: TextStyle(color: kwhite),
              ),
              suffixIcon: GestureDetector(
                onTap: () => setState(() {
                  _passVisible = !_passVisible;
                }),
                child: Icon(
                  _passVisible
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  color: kgrey,
                ),
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
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    prefixIcon: const Icon(Icons.key_rounded, color: kgreen),
                    label: const Text("Confirm Password"),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() {
                        _ConPassVisible = !_ConPassVisible;
                      }),
                      child: Icon(
                        _ConPassVisible
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: kgrey,
                      ),
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
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, color: kwhite),
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
                  style: const TextStyle(fontSize: 17, color: Colors.blue, fontWeight: FontWeight.bold),
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
            onPressed: signinGoogle,
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
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20, color: kwhite),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
