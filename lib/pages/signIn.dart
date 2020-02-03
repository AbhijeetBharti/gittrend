import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:gittrend/pages/home.dart';
import 'package:gittrend/pages/signUp.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  //String _email;

  final globalKey = GlobalKey<ScaffoldState>();

  bool passwordVisible;
  String _email;
  String _password;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future signIn(String email, String password) async {
    if (email == null || password == null) {
      _showSnackBar(context, "Something went wrong !", Colors.red);
    } else {
      try {
        showDialogue(context, 'Authenticating...');
        FirebaseUser user = (await firebaseAuth.signInWithEmailAndPassword(
                email: email, password: password))
            .user;
        if (user != null) {
          var route = new MaterialPageRoute(
            builder: (BuildContext context) => new HomeScreen(),
          );
          dialogue.hide();
          Navigator.of(context).pushReplacement(route);
        } else {
          dialogue.hide();
          _showSnackBar(context, "Something went wrong !", Colors.red);
        }
      } on PlatformException catch (loginError) {
        if (loginError.code == "ERROR_USER_NOT_FOUND") {
          dialogue.hide();
          _showSnackBar(context, "User Not Found !", Colors.red);
        } else {
          dialogue.hide();
          _showSnackBar(context, "Something went wrong !", Colors.red);
        }
      }
    }
  }

  ProgressDialog dialogue;

  void showDialogue(context, text) {
    dialogue = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    dialogue.style(message: text);
    dialogue.show();
  }

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      dialogue.hide();
      _showSnackBar(
          context,
          "A reset link has been sent to you. Check out your email !",
          Colors.black);
    } on PlatformException catch (e) {
      if (e.code == "ERROR_USER_NOT_FOUND") {
        dialogue.hide();
        _showSnackBar(context, 'Email not registered.', Colors.red);
      } else {
        dialogue.hide();
        _showSnackBar(context, 'Something went wrong. Report on Google Play.',
            Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: globalKey,
      resizeToAvoidBottomPadding: false,
      body: WillPopScope(
        onWillPop: () {
          return SystemNavigator.pop();
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SafeArea(
            child: Column(children: <Widget>[
//              Spacer(
//                flex: 1,
//              ),
              Container(
                child: Image.asset('assets/gitlogo.png'),
                width: screenWidth * 0.75,
              ),
              Container(
                padding: EdgeInsets.only(left: 40, right: 40),
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
                margin: const EdgeInsets.only(left: 40, right: 40),
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
                      signIn(_email, _password);
                    },
                    textColor: Colors.white,
                    color: Colors.black,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text('SIGN IN', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: InkWell(
                    onTap: () {
                      _showDialog();
                    },
                    child: Text("Forgot Password ?",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            decoration: TextDecoration.none))),
              ),
              Spacer(
                flex: 5,
              ),
              Divider(
                thickness: 1,
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: InkWell(
                    onTap: () {
                      var route = new MaterialPageRoute(
                        builder: (BuildContext context) => new SignUp(),
                      );
                      Navigator.of(context).push(route);
                    },
                    child: Text("NEW USER ?  SIGN UP",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none))),
              ),
            ]),
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

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: 320,
            width: 300,
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  margin: const EdgeInsets.only(
                      top: 30, bottom: 10, right: 10, left: 10),
                  child: Icon(Icons.vpn_key),
                ),
                Text("Enter your registered email \nto get reset link",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Whitney',
                        fontSize: 20)),
                Container(
                    margin: const EdgeInsets.all(20),
                    child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: new InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(
                              color: Colors.grey, fontFamily: 'Whitney'),
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        })),
                Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: ButtonTheme(
                    minWidth: 200,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        showDialogue(context, 'Sending...');
                        resetPassword(_email);
                      },
                      textColor: Colors.white,
                      color: Colors.black,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Send',
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
