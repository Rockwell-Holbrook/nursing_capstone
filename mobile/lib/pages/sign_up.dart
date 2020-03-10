///Signs new users up

import 'package:flutter/material.dart';
import '../data/user.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => new _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  User _user = new User();

  void submit() async {
    _formKey.currentState.save();
    String message = '';
    Future<bool> register = 
        _user.register(_user.username, _user.password, _user.email, _user.organizationID, _user.jobTitle);
    register.then((value) {
      message = 'User sign up successful!';
      if (value == true) {
        print(value.toString());
        BuildContext buildContext = this.context;
        showDialog(
          context: buildContext,
          builder: (BuildContext context) {

            String confirmationCode = '';

            return Dialog(
              child: Column(
                children: <Widget> [
                  Text('A confirmation code has been emailed to you. \n Enter it below to finish creating account:'),
                  new TextFormField(
                    decoration: new InputDecoration(
                      hintText: 'Code', labelText: 'Confirmarion Code'),
                    onChanged: (String confirmation) {
                      setState(() {
                        confirmationCode = confirmation;
                      });
                    }
                  ),
                  new Container(
                    padding: new EdgeInsets.all(20.0),
                    width: MediaQuery.of(context).size.width,
                    child: new RaisedButton(
                      child: new Text(
                        'Create Account',
                        style: new TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Future<bool> confirmed = _user.confirmEmail(confirmationCode);
                        confirmed.then((success) {
                          if(success) {
                            Navigator.pushReplacementNamed(buildContext, 'home');
                          } else {
                            final snackBar = new SnackBar(
                              content: new Text(message),
                              action: new SnackBarAction(
                                label: 'Confirmation Code Wrong - Try Again',
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              duration: new Duration(seconds: 30),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                          }
                        });
                      },
                      color: Colors.blue,
                    ),
                    margin: new EdgeInsets.only(
                      top: 10.0,
                    ),
                  ),
                ]
              )
            );
          }
        );
      } else {
        final snackBar = new SnackBar(
          content: new Text(message),
          action: new SnackBarAction(
            label: 'Local Application Error (not connected to internet?) - Try Again',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          duration: new Duration(seconds: 30),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      }
    }).catchError((e) {
      message = e.toString();
      print(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Sign Up'),
      ),
      body: new Container(
        child: new Form(
          key: _formKey,
          child: new ListView(
            children: <Widget>[
              new ListTile(
                leading: const Icon(Icons.account_box),
                title: new TextFormField(
                  decoration: new InputDecoration(
                    hintText: 'myUsername', labelText: 'Username'),
                  onSaved: (String username) {
                    _user.username = username;
                  },
                ),
              ),
              new ListTile(
                leading: const Icon(Icons.email),
                title: new TextFormField(
                  decoration: new InputDecoration(
                      hintText: 'email@domain.com', labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (String email) {
                    _user.email = email;
                  },
                ),
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
                  },
                ),
              ),
              new ListTile(
                leading: const Icon(Icons.email),
                title: new TextFormField(
                  decoration: new InputDecoration(
                      hintText: 'xxxxxxxx', labelText: 'Organization ID (optional)'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (String organizationID) {
                    _user.organizationID += organizationID;
                  },
                ),
              ),
              new Container(
                padding: new EdgeInsets.all(20.0),
                width: screenSize.width,
                child: new RaisedButton(
                  child: new Text(
                    'Sign Up',
                    style: new TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    submit();
                  },
                  color: Colors.blue,
                ),
                margin: new EdgeInsets.only(
                  top: 10.0,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}