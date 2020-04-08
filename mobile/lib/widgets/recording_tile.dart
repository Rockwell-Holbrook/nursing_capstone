import 'package:flutter/material.dart';
import './tag_recording.dart';
import '../data/networkRepo.dart';

class RecordingTile extends StatefulWidget {
  final Function submit;
  RecordingTile({
    Key key,
    @required this.submit
  }): super(key: key);
  @override
  RecordingsTileState createState() => new RecordingsTileState();
}
class RecordingsTileState extends State<RecordingTile> {

  List<dynamic> items;
  String nextToken;

  void initState() {
    super.initState();
    items = [];
    nextToken = '';
    Future<dynamic> holder = all_patients(nextToken);
    holder.then((value) {
      setState(() {
        items.addAll(value['patients']);
      });
    });
  }

  void _onEntryPressed(String id, String dateModified, String createdBy, List<String> tags, String abnormal) async {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          GlobalKey<TagRecordingState> key = new GlobalKey();
          return TagRecording(id: id, date: dateModified, name: createdBy, tags: tags, abnormal: abnormal);
        })
    ).then((value) {
      if(value != null) {
        setState(() {
          items[0]['tags'] = value;
        });
      }
    });
  }

  Row displayTags(int i) {
    List<String> tagsList = [];
    for(int j = 0; j < items[i]['tags'].length; j++) {
      tagsList.add(items[i]['tags'][j].toString());
    }

    List<Text> tagsDisplay = [];
    for(int j = 0; j < tagsList.length; j++) {
      tagsDisplay.add(Text(tagsList[j]));
      tagsDisplay.add(Text('     '));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height * 0.65),
      child: ListView(
        children: <Widget>[
        Padding(
          padding: EdgeInsets.all(5),
          child: Text('Review and Diagnos:', style: TextStyle(fontSize: 18),),
        ),
        Container(
          height: (MediaQuery.of(context).size.height * 0.8),
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return new FlatButton(
                    onPressed: () => _onEntryPressed(items[index]['id'], items[index]['date_modified'], items[index]['created_by'], convertTags(items[index]['tags']), items[index]['abnormal']),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withAlpha(100),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0)
                          ),
                        ),
                        padding: EdgeInsets.all(5),
                        height: 200,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text('ID'),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text( items[index]['id'] )
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget> [
                                Expanded(
                                    child: Text('DATE'),
                                  ),
                                Expanded(
                                  flex: 3,
                                    child: Text( items[index]['date_modified'] )
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text('USER'),
                                  ),
                                Expanded(
                                  flex: 3,
                                  child: Text( items[index]['created_by'] )
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget> [
                                Expanded(
                                  child: Text('RISK'),
                                ),
                                Expanded(
                                  flex: 3,
                                    child: Text( items[index]['abnormal'].toString() )
                                ),
                              ]
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget> [
                                Expanded(
                                  child: Text('FLAGS'),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: displayTags(index)
                                )
                              ]
                            )
                          ],
                        )
                      )
                    )
                );
              }
            )
          )
        ]
      )
    );
  }
}