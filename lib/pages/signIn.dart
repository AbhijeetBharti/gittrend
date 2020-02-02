import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:gittrend/pages/home.dart';
import 'package:gittrend/pages/signUp.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignInPage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  //String _email;

  final globalKey = GlobalKey<ScaffoldState>();

  bool passwordVisible;
  String _email;
  String _password;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future signIn(String email, String password) async {
    if (email == null || password == null) {
      _showSnackBar(context, "Something went wrong !", Colors.red);
    } else {
      try {
        showDialogue(context);
        FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
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

  void showDialogue(context) {
    dialogue = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    dialogue.style(message: "Authenticating...");
    dialogue.show();
  }

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      key: globalKey,
      resizeToAvoidBottomPadding: false,
      body: WillPopScope(
        onWillPop: () {
          return SystemNavigator.pop();
        },
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                  bottom: 10.0, top: 10, left: 20, right: 20),
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.all(0),
              child: Image.asset('assets/gitlogo.png'),
              height: 300,
              width: 300,
            ),
            Container(
                margin: const EdgeInsets.only(top: 50, left: 40, right: 40),
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
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
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
                    signIn(_email, _password);
                  },
                  textColor: Colors.white,
                  color: Colors.black,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0)),
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child:
                        const Text('SIGN IN', style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 45, bottom: 100),
            ),
            Divider(
              thickness: 1,
            ),
            Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.bottomCenter,
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
