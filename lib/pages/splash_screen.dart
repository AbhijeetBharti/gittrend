import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gittrend/pages/home.dart';
import 'package:gittrend/pages/signIn.dart';
import 'package:gittrend/pages/sizeConfi.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    isUserSignedIn();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold();
  }

  isUserSignedIn() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      var route = new MaterialPageRoute(
        builder: (BuildContext context) => new HomeScreen(),
      );
      Navigator.of(context).pushReplacement(route);
    } else {
      var route = new MaterialPageRoute(
        builder: (BuildContext context) => new SignInPage(),
      );
      Navigator.of(context).pushReplacement(route);
    }
  }
}
