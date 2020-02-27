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
  @override
  Widget build(BuildContext context) {
    return Drawer (
      child: ListView(
        children: <Widget>[
          ListTile(
              title: Text("Date"),
              trailing: Icon(Icons.check_box)
          ),
          ListTile(
              title: Text("Abnormal"),
              trailing: Icon(Icons.check_box)
          ),
          ListTile(
              title: Text("Practitioner"),
              trailing: Icon(Icons.check_box)
          )
        ],
      ),
    );
  }
}