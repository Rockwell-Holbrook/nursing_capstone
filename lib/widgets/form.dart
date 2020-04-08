import 'package:flutter/material.dart';

class BeatsForm extends StatefulWidget {
@override
  FormState createState() =>
    new FormState();
}

class FormState extends State<BeatsForm> {
  bool checkboxVal;

  void initState() {
    super.initState();
    checkboxVal = false;
  }

  toggleState() {
    checkboxVal = !checkboxVal;
  }

   @override
  Widget build(BuildContext context) {
    return new Form(
      child: Column(
        children: <Widget>[

          TextField(
            decoration: new InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 3.0),
              ),
              labelText: "Notes"
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Abnormality Detected',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Checkbox(
                value: checkboxVal, 
                onChanged: (bool value) {
                  setState(() {
                   checkboxVal = value; 
                  });
                }
              ),
            ]
          )

        ]
      )
    );
    
  }
}