import 'package:flutter/material.dart';
class Recordings extends StatefulWidget {
  final Function callback;
  final Function submit;
  Recordings({
    @required this.callback,
    @required this.submit
  });
  @override
  _RecordingsState createState() =>
      new _RecordingsState();
}
class _RecordingsState extends State<Recordings> {
  List<dynamic> items = [
    {
      "id": "1111",
      "date": "01-01-1111",
      "recorder": "JoeAnn Meyers",
      "abnormal": "true"
    },
    {
      "id": "2222",
      "date": "02-02-2222",
      "recorder": "JoeAnn Meyers",
      "abnormal": "false"
    },
    {
      "id": "3333",
      "date": "03-03-3333",
      "recorder": "Billy Joe",
      "abnormal": "true"
    }
  ];
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
                          return new Row(
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
                          );
                        }
                    )
                  )
            ])
      ),
    );
  }
}