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

  void initState() {
    super.initState();
    Future<List<dynamic>> holder = getPatients();
    holder.then((value) {
      setState(() {
        items.addAll(value);
      });
    });
  }

  void _onEntryPressed(String id, String date, String recorder, String abnormal) async {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return TagRecording(id: id, date: date, name: recorder, abnormal: date);
        })
    );
  }

  //widget.callback
  @override
  Widget build(BuildContext context) {
    var _pageController;
    var currentPage;
    return Container(
      child: SizedBox(
        width: (MediaQuery.of(context).size.width * 0.85),
        height: (MediaQuery.of(context).size.height * 0.25), 
        child:
            Column(
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
                    height: (MediaQuery.of(context).size.height * 0.50),
                    child:
                    ListView.builder(
                        itemBuilder: (context, index) {
                          //Do Stuff Here
                          return new FlatButton(
                              onPressed: () => _onEntryPressed(items[index]['id'], items[index]['date'], items[index]['recorder'], items[index]['abnormal']),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Text( items[index]['id'] )
                                  ),
                                  Expanded(
                                      child: Text( items[index]['date'] )
                                  ),
                                  Expanded(
                                      child: Text( items[index]['recorder'] )
                                  ),
                                  Expanded(
                                      child: Text( items[index]['abnormal'] )
                                  )
                                ],
                              )
                          );
                        }
                    )
                  )
            ])
      ),
    );
  }
}