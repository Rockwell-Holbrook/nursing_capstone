import 'dart:async';

import 'package:flutter/material.dart';
import '../mixins/audio_player.dart';
import '../data/networkRepo.dart';

class TagRecording extends StatefulWidget {

  final String id;
  final String date;
  final String name;
  final List<String> tags;
  bool abnormal;


  TagRecording({
    @required this.id,
    @required this.date,
    @required this.name,
    @required this.tags,
    @required this.abnormal
  });

  updateRecording() {
    bool tempBool;
    if(tags.length > 0) {
      tempBool = true;
    } else {
      tempBool = false;
    }
    var body = {"patient": { "tags": tags, "abnormal": tempBool}};
    update(id, body);
  }

  @override
  _TagRecordingState createState() => new _TagRecordingState();
}

class _TagRecordingState extends State<TagRecording> 
  with AudioPlayerController{

  List<String> url;

  List<String> options = [
    'tags1',
    'tags2',
    'tags3',
    'tags4',
    'tags5',
    'tags6',
    'tags7',
    'tags8',
    'tags9',
    'tags10'
  ];

  void initState() {
    super.initState();
    url = ['asdfsdfaasdf'];
    Future<List<String>> urlHolder = getURLs();
    urlHolder.then((value) {
      setState(() {
        url = value;
      });
    });
  }

  Future<List<String>> getURLs() async {
    List<String> urlHolder = await patient_recordings(widget.id);
    return urlHolder;
  }

  void updateTags(String nextTag) {
    if(widget.tags.contains(nextTag)) {
      setState(() {
        widget.tags.remove(nextTag);
      });
    } else {
      setState(() {
        widget.tags.add(nextTag);
      });
    }
  }

  bool checkChecked(int i) {
    if(widget.tags.contains(options[i])) {
      return true;
    } else {
      return false;
    }
  }

  Column buildCheckBoxes() {
    List<Widget> boxes = [];

    for(int i = 0; i < 10; i ++) {
      boxes.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [
            CheckBoxQuery(
              checked: checkChecked(i),
              query: Text(options[i]),
              onPressed: (value) {
                updateTags(options[i-1]);
              }
            ),
            CheckBoxQuery(
              checked: checkChecked(i+1),
              query: Text(options[i+1]),
              onPressed: (value) {
                updateTags(options[i]);
              }
            ),
          ]
        )
      );
      i++;
    }

    return Column(
      children: <Widget>[
        Text('Date Taken: ' + widget.date),
        Text('Name of Recorder: ' + widget.name),
        Text('Recording Status: ' + widget.abnormal.toString()),
      ] + boxes + [
        Padding(
          padding: EdgeInsets.all(30),
          child: FlatButton(
            onPressed: () {
              widget.updateRecording();
            },
            child: Container(
              height: 50,
              width: 124,
              color: Colors.blue,
              child: Center(
                child: Text('Submit Diagnosis', style: TextStyle(color: Colors.white),)
              )
            ),
          ),
        )
      ]
    );
  }

  List<Widget> buildPlayButtons() {
    List<Widget> buttons = [];

    for(int i = 0; i < url.length; i ++) {
      buttons.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            FlatButton(
              onPressed: () => pauseAudio(),
              child: Icon(Icons.pause)
            ),
            FlatButton(
              onPressed: () {
                playNetworkAudio(url[i]);
              },
              child: Text('Play test')
            ),
            FlatButton(
              onPressed: () => resumeAudio(),
              child: Icon(Icons.play_arrow)
            )
          ]
        )
      );
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Records for case:\n' + widget.id),
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            buildCheckBoxes(),
          ] + buildPlayButtons()
        )
      )
    );
  }
}

class CheckBoxQuery extends StatefulWidget{

  final Text query;
  final Function onPressed;
  final bool checked;


  CheckBoxQuery({
    final this.query,
    final this.onPressed,
    final this.checked
  });

  @override
  _CheckBoxQueryState createState() => new _CheckBoxQueryState(checked: checked);
}

class _CheckBoxQueryState extends State<CheckBoxQuery> {

  _CheckBoxQueryState({
    @required this.checked
  });

  bool checked;

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
                  value: checked,
                  onChanged: (value) {
                    setState(() {
                      checked = value;
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