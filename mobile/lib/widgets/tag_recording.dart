import 'package:flutter/material.dart';
import '../mixins/audio_player.dart';
import '../data/networkRepo.dart';

class TagRecording extends StatefulWidget {

  final String id;
  final String date;
  final String name;
  final List<String> tags;
  String abnormal;


  TagRecording({
    @required this.id,
    @required this.date,
    @required this.name,
    @required this.tags,
    @required this.abnormal
  });

  updateRecording() {
    var body = {"patient": { "tags": tags, "abnormal": abnormal}};
    update(id, body);
  }

  @override
  _TagRecordingState createState() => new _TagRecordingState();
}

class _TagRecordingState extends State<TagRecording> 
  with AudioPlayerController{

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
                    checked: (widget.tags[0] == "true") ? true : false,
                    query: Text('ded'),
                    onPressed: (value) {
                      setState(() {
                        widget.tags[0] = (value) ? "true" : "false";
                      });
                    }
                  ),
                  CheckBoxQuery(
                    checked: (widget.tags[1] == "true") ? true : false,
                    query: Text('gonna be ded'),
                    onPressed: (value) {
                      setState(() {
                        widget.tags[1] = (value) ? "true" : "false";
                      });
                    }
                  ),
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget> [
                  CheckBoxQuery(
                    checked: (widget.tags[2] == "true") ? true : false,
                    query: Text('ded'),
                    onPressed: (value) {
                      setState(() {
                        widget.tags[2] = (value) ? "true" : "false";
                      });
                    }
                  ),
                  CheckBoxQuery(
                    checked: (widget.tags[3] == "true") ? true : false,
                    query: Text('gonna be ded'),
                    onPressed: (value) {
                      setState(() {
                        widget.tags[3] = (value) ? "true" : "false";
                      });
                    }
                  ),
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget> [
                  CheckBoxQuery(
                    checked: (widget.tags[4] == "true") ? true : false,
                    query: Text('ded'),
                    onPressed: (value) {
                      setState(() {
                        widget.tags[4] = (value) ? "true" : "false";
                      });
                    }
                  ),
                  CheckBoxQuery(
                    checked: (widget.tags[5] == "true") ? true : false,
                    query: Text('gonna be ded'),
                    onPressed: (value) {
                      setState(() {
                        widget.tags[5] = (value) ? "true" : "false";
                      });
                    }
                  ),
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget> [
                  CheckBoxQuery(
                    checked: (widget.tags[6] == "true") ? true : false,
                    query: Text('ded'),
                    onPressed: (value) {
                      setState(() {
                        widget.tags[6] = (value) ? "true" : "false";
                      });
                    }
                  ),
                  CheckBoxQuery(
                    checked: (widget.tags[7] == "true") ? true : false,
                    query: Text('gonna be ded'),
                    onPressed: (value) {
                      setState(() {
                        widget.tags[7] = (value) ? "true" : "false";
                      });
                    }
                  ),
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget> [
                  CheckBoxQuery(
                    checked: (widget.tags[8] == "true") ? true : false,
                    query: Text('ded'),
                    onPressed: (value) {
                      setState(() {
                        widget.tags[8] = (value) ? "true" : "false";
                      });
                    }
                  ),
                  CheckBoxQuery(
                    checked: (widget.tags[9] == "true") ? true : false,
                    query: Text('gonna be ded'),
                    onPressed: (value) {
                      setState(() {
                        widget.tags[9] = (value) ? "true" : "false";
                      });
                    }
                  ),
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget> [
                  CheckBoxQuery(
                    checked: (widget.abnormal == "true") ? true : false,
                    query: Text('Abnormal'),
                    onPressed: (value) {
                      setState(() {
                        widget.abnormal = (value) ? "true" : "false";
                    });
                  }
                 )
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
                  onPressed: widget.updateRecording(),
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

  void initState() {
    super.initState();
    checked = false;
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