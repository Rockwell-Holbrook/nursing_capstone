import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/loadScreen.dart';
import 'pages/login.dart';
import 'pages/sign_up.dart';
import 'pages/password_reset.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder> {
        "login": (BuildContext context) => new LoginForm(),
        "sign_up": (BuildContext context) => new SignUp(),
        "reset": (BuildContext context) => new ResetPassword(),
        "home": (BuildContext context) => new Home(),
      },
      home: LoadScreen(),
    );
  }
}