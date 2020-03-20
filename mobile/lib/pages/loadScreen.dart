import 'package:flutter/material.dart';
import '../data/user.dart';

class LoadScreen extends StatelessWidget {

  GlobalKey<ScaffoldState> scaffKey = new GlobalKey();

  LoadScreen() {
    checkSession();
  }

  void checkSession() async {
    User user = new User();
    await user.init();
    Future<bool> activeSession = user.checkActiveSession();
    activeSession.then((active) {
      if(active) {
        Navigator.of(scaffKey.currentState.context).pushReplacementNamed('home');
      } else {
        Navigator.of(scaffKey.currentState.context).pushReplacementNamed('login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Loading')
        ],
      ),
    );
  }
}