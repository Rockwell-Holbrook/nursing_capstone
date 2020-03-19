import 'package:flutter/material.dart';
import './tag_recording.dart';
import '../data/networkRepo.dart';

class RecordingTile extends StatefulWidget {
  final Function callback;
  final Function submit;
  RecordingTile({
    @required this.callback,
    @required this.submit
  });
  @override
  _RecordingsState createState() =>
      new _RecordingsState();
}
class _RecordingsState extends State<RecordingTile> {

  List<dynamic> items = [];
  String nextToken;

  void initState() {
    super.initState();
    nextToken = '';
    Future<dynamic> holder = all_patients(nextToken);
    holder.then((value) {
      setState(() {
        items.addAll(value['patients']);
      });
    });
  }

  void _onEntryPressed(String id, String dateModified, String createdBy, List<String> tags, bool abnormal) async {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return TagRecording(id: id, date: dateModified, name: createdBy, tags: tags, abnormal: abnormal);
        })
    );
  }

  Column displayTags(int i) {
    List<String> tagsList = [];
    for(int j = 0; j < items[i]['tags'].length; j++) {
      tagsList.add(items[i]['tags'][j].toString());
    }

    List<Text> tagsDisplay = [];
    for(int j = 0; j < tagsList.length; j++) {
      tagsDisplay.add(Text(tagsList[j]));
    }
    return Column(
      children: <Widget>[] + tagsDisplay
    );
  }

  List<String> convertTags(List<dynamic> input) {
    if(input.length > 0) {
      return List<String>.from(input);
    } else {
      return <String>[];
    }
  }
  //widget.callback
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: (MediaQuery.of(context).size.width * 0.85),
        height: (MediaQuery.of(context).size.height * 0.25), 
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: (MediaQuery.of(context).size.width * 0.85),
              height: (MediaQuery.of(context).size.height * 0.1),
              child:
                Row(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(5)
                      ),
                      Expanded(
                          child: Text("ID")
                      ),
                      Expanded(
                          child: Text("DATE")
                      ),
                      Expanded(
                          child: Text("RECORDER")
                      ),
                      Expanded(
                          child: Text("ABNORMAL")
                      )
                    ]
                )
            ),
            SizedBox(
              height: (MediaQuery.of(context).size.height * 0.9),
              child:
              ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    //Do Stuff Here
                    return new FlatButton(
                        onPressed: () => _onEntryPressed(items[index]['id'], items[index]['date_modified'], items[index]['created_by'], convertTags(items[index]['tags']), items[index]['abnormal']),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Text( items[index]['id'] )
                            ),
                            Expanded(
                                child: Text( items[index]['date_modified'] )
                            ),
                            Expanded(
                                child: Text( items[index]['created_by'] )
                            ),
                            Expanded(
                                child: Text( items[index]['abnormal'].toString() )
                            ),
                            Expanded(
                              //Handle null later
                                child: displayTags(index)
                            )
                          ],
                        )
                    );
                  }
              )
            )
          ]
        )
      ),
    );
  }
}