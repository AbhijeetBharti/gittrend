import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:gittrend/pages/home.dart';
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
      resizeToAvoidBottomPadding: false,
      key: globalKey,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Sign Up",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 50, right: 50),
            child: Column(
              children: <Widget>[
                Spacer(
                  flex: 1,
                ),
                Container(
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.person),
                      ),
                      labelText: "Email",
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
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
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
                SizedBox(
                  height: 70,
                ),
                Container(
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
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text("Already a user ?",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none))),
                ),
                Spacer(
                  flex: 7,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showSnackBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    globalKey.currentState.showSnackBar(snackBar);
  }
}
