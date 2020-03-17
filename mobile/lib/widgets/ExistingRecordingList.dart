import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'existing_recording_tile.dart';
import '../data/localFileSystem.dart';

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

  List<String> directories = [];
  Map<String, List<File>> filessystem = new HashMap();

  generateFilesFromLocalStorage() async {
    directories = await localDirectories;
    setState(() {});
    for(int i = 0; i < directories.length; i++) {
      List<File> files = await getfilesInDirectory(directories[i]);
      filessystem[directories[i]] = files;
    }
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
            itemCount: directories.length,
            itemBuilder: (context, index) {
              return ExistingRecordingTile(timeStamp: directories[index]);
            }
          )
        )
    );
  }
}