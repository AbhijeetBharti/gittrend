import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text("Bookmarked Repos",style: TextStyle(color: Colors.black)),
      ),
      body:WillPopScope(
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
              ],
            )),
    );
  }
}