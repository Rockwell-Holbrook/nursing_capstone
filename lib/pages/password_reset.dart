///Signs new users up, used as a dialogue

import 'package:flutter/material.dart';
import '../data/user.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => new _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  User _user = new User();

  void requestCode(String emailResponse) {
    String confirmationCode;
    String nextPassword;
    showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return Dialog(
          child: Container(
            height: 350,
            child: Column(
              children: <Widget> [
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('$emailResponse\nEnter the code you received below\nand choose a new password:')
                ),
                new ListTile(
                  leading: const Icon(Icons.email),
                  title: new TextFormField(
                    decoration: new InputDecoration(
                      hintText: '000000', labelText: 'Confirmation Code'),
                    onChanged: (String code) {
                      confirmationCode = code;
                    }
                  )
                ),
                new ListTile(
                  leading: const Icon(Icons.lock),
                  title: new TextFormField(
                    decoration: new InputDecoration(
                    hintText: 'pAssw0rd!123', labelText: 'New Password'),
                    onChanged: (String code) {
                      nextPassword = code;
                    }
                  )
                ),
                new Container(
                  padding: new EdgeInsets.all(20.0),
                  width: MediaQuery.of(context).size.width,
                  child: new RaisedButton(
                    child: new Text(
                      'Reset Password',
                      style: new TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Future<bool> confirmed = _user.confirmPasswordReset(confirmationCode, nextPassword);
                      confirmed.then((success) {
                        if(success) {
                          //Now that the user can be authenticated, send them to login
                          Navigator.pop(buildContext);
                          Navigator.pushReplacementNamed(context, 'login');
                        } else {
                          final snackBar = new SnackBar(
                            content: new Text('Confirmation Code Wrong'),
                            action: new SnackBarAction(
                              label: 'Try Again',
                              onPressed: () {
                                Navigator.pop(buildContext);
                              },
                            ),
                            duration: new Duration(seconds: 30),
                          );
                          Scaffold.of(buildContext).showSnackBar(snackBar);
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
          )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text('Password Reset')),
      body: Container(
        child: Column(
          children: <Widget> [
            Padding(
              padding: EdgeInsets.all(30),
              child: Text('Please enter the username for your account:'),
            ),
            new ListTile(
              leading: const Icon(Icons.account_box),
              title: new TextFormField(
                decoration: new InputDecoration(
                  hintText: 'myUsername', labelText: 'Username'),
                onChanged: (String username) {
                  _user.username = username;
                }
              )
            ),
            new Container(
              padding: new EdgeInsets.all(20.0),
              width: MediaQuery.of(context).size.width,
              child: new RaisedButton(
                color: Colors.blue,
                child: new Text(
                  'Send Reset Code',
                  style: new TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Future<String> reset = _user.sendPasswordReset();
                  reset.then((success) {
                    if(success != '') {
                        requestCode(success);
                      }
                    });
                }
              )
            )
          ]
        )
      )
    );
  }
}