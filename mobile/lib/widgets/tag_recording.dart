import 'package:flutter/material.dart';

class TagRecording extends StatefulWidget {

  String id = "0";
  String date = "0";
  String name = "nurse";
  String abnormal = "true"; 

  TagRecording({
    this.id,
    this.date,
    this.name,
    this.abnormal
  });

  @override
  _TagRecordingState createState() => new _TagRecordingState();
}

class _TagRecordingState extends State<TagRecording> {

  List<bool> tags = [];

  void initState() {
    super.initState();
    tags = [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Records for case: ' + widget.id),
      ),
      body: Column(
        children: <Widget> [
          Text('Date Taken: ' + widget.date),
          Text('Name of Recorder: ' + widget.name),
          Text('Recording Status: ' + widget.abnormal),
          CheckBoxQuery(
              query: Text('ded'),
              onPressed: (value) {
                setState(() {
                  tags[0] = value;
                });
              }
            ),
            CheckBoxQuery(
              query: Text('gonna be ded'),
              onPressed: (value) {
                setState(() {
                  tags[1] = value;
                });
              }
            ),
            CheckBoxQuery(
              query: Text('not ded'),
              onPressed: (value) {
                setState(() {
                  tags[2] = value;
                });
              }
            ),
            CheckBoxQuery(
              query: Text('healthy'),
              onPressed: (value) {
                setState(() {
                  tags[3] = value;
                });
              }
            ),
        ]
      ),
    );
  }
}

class CheckBoxQuery extends StatefulWidget{

  final Text query;
  final Function onPressed;


  CheckBoxQuery({
    final this.query,
    final this.onPressed,
  });

  @override
  _CheckBoxQueryState createState() => new _CheckBoxQueryState();
}

class _CheckBoxQueryState extends State<CheckBoxQuery> {

  bool _checked;

  void initState() {
    super.initState();
    _checked = false;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      enabled: true,
      autovalidate: true,
      builder: (FormFieldState<bool> state) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget> [
                widget.query,
                Checkbox(
                  value: _checked,
                  onChanged: (value) {
                    setState(() {
                      _checked = value;
                      widget.onPressed(value);
                    });
                  }
                )
              ]
            )
          ]
        );
      }
    );
  }
}