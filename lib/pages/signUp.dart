import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:gittrend/pages/home.dart';
import 'package:gittrend/pages/signIn.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUp createState() => _SignUp();
}

abstract class BaseAuth {
  Future<String> signUp(String username, String email, String password);
}

class _SignUp extends State<SignUp> {
  final globalKey = GlobalKey<ScaffoldState>();
  bool passwordVisible;
  String _email = ' ';
  String _password = ' ';

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future signUp(String email, String password) async {
    if (email == null || password == null) {
      _showSnackBar(context, "Something went wrong !", Colors.red);
    } else {
      try {
        showDialogue(context);
        FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
                email: email, password: password))
            .user;
        if (user != null) {
          var route = new MaterialPageRoute(
            builder: (BuildContext context) => new HomeScreen(),
          );
          dialogue.hide();
          Navigator.of(context).push(route);
        } else {
          dialogue.hide();
          _showSnackBar(context, "Something went wrong !", Colors.red);
        }
      } on PlatformException catch (signUpError) {
        if (signUpError.code == "ERROR_INVALID_EMAIL") {
          dialogue.hide();
          _showSnackBar(context, "Something went wrong !", Colors.red);
        } else {
          dialogue.hide();
          _showSnackBar(context, "Something went wrong !", Colors.red);
        }
      }
    }
  }

  ProgressDialog dialogue;

  void showDialogue(context) {
    dialogue = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    dialogue.style(message: "Registering...");
    dialogue.show();
  }

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        body: Builder(
          builder: (context) => SingleChildScrollView(
            child: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(
                          top: 70, left: 30, right: 30, bottom: 5),
                      child: Row(children: <Widget>[
                        Container(
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                              )),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 30),
                          child: Text("Sign Up",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                        )
                      ])),
                  Container(
                      margin:
                          const EdgeInsets.only(top: 50, left: 40, right: 40),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.person),
                          ),
                          labelText: "Username",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 50, left: 40, right: 40),
                    child: TextField(
                      obscureText: !passwordVisible,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.vpn_key),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 70.0, bottom: 10.0),
                    child: ButtonTheme(
                      minWidth: 350,
                      child: RaisedButton(
                        onPressed: () {
                          signUp(_email, _password);
                        },
                        textColor: Colors.white,
                        color: Colors.black,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(50.0)),
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: const Text('SIGN UP',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text("Already a member ?",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none))),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  _showSnackBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    globalKey.currentState.showSnackBar(snackBar);
  }
}
