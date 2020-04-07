import 'package:flutter/material.dart';
class Filter extends StatefulWidget {
  final Function callback;
  final Function submit;
  Filter({
    @required this.callback,
    @required this.submit
  });
  @override
  _FilterState createState() =>
      new _FilterState();
}

class _FilterState extends State<Filter> {
  bool _dateState = false;
  bool _abnormalState = false;
  bool _practitionerState = false;

  void _dateStateChanged(bool value) => setState(() => _dateState = value);
  void _abnormalStateChanged(bool value) => setState(() => _abnormalState = value);
  void _practitionerStateChanged(bool value) => setState(() => _practitionerState = value);

  @override
  Widget build(BuildContext context) {
    return Drawer (
      child: ListView(
        children: <Widget>[
          ListTile(
              title: Text("Date"),
              trailing: new Checkbox(value: _dateState, onChanged: _dateStateChanged)
          ),
          ListTile(
              title: Text("Abnormal"),
              trailing: new Checkbox(value: _abnormalState, onChanged: _abnormalStateChanged)
          ),
          ListTile(
              title: Text("Practitioner"),
              trailing: new Checkbox(value: _practitionerState, onChanged: _practitionerStateChanged)
          ),
          FlatButton(
            onPressed: () => widget.callback,
            child: Container(
              height: 50,
              child: Text('Filter'),
            )
          )
        ],
      ),
    );
  }
}