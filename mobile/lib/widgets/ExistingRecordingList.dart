import 'package:flutter/material.dart';
import 'existing_recording_tile.dart';

class ExistingRecordingList extends StatefulWidget {
  // final Function callback;
  // final Function submit;
  // ExistingRecordingList({
  //   @required this.callback,
  //   @required this.submit
  // });
  @override
  _ExistingRecordingsState createState() =>
      new _ExistingRecordingsState();
}
class _ExistingRecordingsState extends State<ExistingRecordingList> {

  List<dynamic> files = [];

  generateFilesFromLocalStorage() {
    files = [
      '01-15-2020',
      '01-16-2020',
      '01-17-2020',
      '01-18-2020',
      '01-19-2020',
      '01-20-2020',
    ];
  }

  void initState() {
    super.initState();
    generateFilesFromLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SizedBox(
          height: (MediaQuery.of(context).size.height * 0.50),
          child: ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              return ExistingRecordingTile(timeStamp: files[index]);
            }
          )
        )
    );
  }
}