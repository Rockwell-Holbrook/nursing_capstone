///logs the user in

import 'package:flutter/material.dart';
import '../data/user.dart';

class LoginForm extends StatefulWidget{
  @override
  _LoginFormState createState() => new _LoginFormState();
}

class _LoginFormState extends State<LoginForm>{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  User _user = new User();

  void initState() {
    super.initState();
  }

  void submit(BuildContext buildcontext) async {
    _formKey.currentState.save();
    String message = '';
    String logIn = await _user.authenticate(_user.username, _user.password);
      if (logIn != '') {
        message = 'User login successful!';
        Navigator.of(context).pushNamed('home');
      } else {
        logIn = 'Ok';
        message = "Error Logging in";
        final snackBar = new SnackBar(
          content: new Text(message),
          action: new SnackBarAction(
            label: logIn,
            onPressed: () {
              Scaffold.of(buildcontext).hideCurrentSnackBar();
            },
          ),
          duration: new Duration(seconds: 30),
        );
        Scaffold.of(buildcontext).showSnackBar(snackBar);
      }
    }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Log In'),
      ),
      body: new Container(
        child: new Form(
          key: _formKey,
          child: new ListView(
            children: <Widget>[
              new ListTile(
                leading: const Icon(Icons.person),
                title: new TextFormField(
                  decoration: new InputDecoration(
                      hintText: 'myUsername', labelText: 'Username'),
                  keyboardType: TextInputType.text,
                  onSaved: (String username) {
                    _user.username = username;
                  }
                )
              ),
              new ListTile(
                leading: const Icon(Icons.lock),
                title: new TextFormField(
                  decoration: new InputDecoration(
                    hintText: 'pAssw0rd!123', labelText: 'Password',
                  ),
                  obscureText: true,
                  onSaved: (String password) {
                    _user.password = password;
                  }
                )
              ),
              new Container(
                padding: new EdgeInsets.all(20.0),
                width: screenSize.width,
                child: Builder(
                  builder: (ctx) => new RaisedButton(
                    child: new Text(
                      'Log In',
                      style: new TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      submit(ctx);
                    },
                    color: Colors.blue,
                  )
                )
              ),
              new Container(
                width: screenSize.width,
                child: new FlatButton(
                  child: new Text(
                    'Create Account',
                    style: new TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('sign_up');
                  }
                )
              ),
              new Container(
                width: screenSize.width,
                child: new FlatButton(
                  child: new Text(
                    'Reset Password',
                    style: new TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('reset');
                  }
                )
              )
            ]
          )
        )
      )
    );
  }
}