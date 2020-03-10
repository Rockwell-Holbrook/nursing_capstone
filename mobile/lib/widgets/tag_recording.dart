import 'package:flutter/material.dart';
import '../mixins/audio_player.dart';

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

class _TagRecordingState extends State<TagRecording> 
  with AudioPlayerController{

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
      body:
        Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget> [
              Text('Date Taken: ' + widget.date),
              Text('Name of Recorder: ' + widget.name),
              Text('Recording Status: ' + widget.abnormal),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget> [
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
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget> [
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
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget> [
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
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget> [
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
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget> [
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
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[
                  FlatButton(
                    onPressed: () => pauseAudio(),
                    child: Icon(Icons.pause)
                  ),
                  FlatButton(
                    onPressed: () => playLocalAudio('soundFileSample0.wav'),
                    child: Text('Play test')
                  ),
                  FlatButton(
                    onPressed: () => resumeAudio(),
                    child: Icon(Icons.play_arrow)
                  )
                ]
              ),
              Padding(
                padding: EdgeInsets.all(30),
                child: FlatButton(
                  onPressed: () => {},
                  child: Container(
                    height: 50,
                    width: 124,
                    color: Colors.blue,
                    child: Text('Submit Diagnosis', style: TextStyle(color: Colors.white),)
                  ),
                ),
              )
            ]
          ),
        )
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