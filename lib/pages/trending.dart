import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gittrend/pages/nestedTabBarTrending.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gittrend/pages/signIn.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Trending on GitHub",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            padding: const EdgeInsets.only(right: 10.0),
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.black,
            ),
            iconSize: 35,
            onPressed: () async {
              await FirebaseAuth.instance.signOut().then((onValue) {
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => SignInPage(),
                );
                Navigator.of(context).pushReplacement(route);
              });
            },
          ),
        ],
      ),
      body: WillPopScope(
          onWillPop: () {
            return SystemNavigator.pop();
          },
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.black, width: 0.5),
                  ),
                ),
              ),
              NestedTabBarTrending(),
            ],
          )),
    );
  }
}
