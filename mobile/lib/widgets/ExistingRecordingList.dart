import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'existing_recording_tile.dart';
import '../data/localFileSystem.dart';
import '../data/networkRepo.dart';

class ExistingRecordingList extends StatefulWidget {

  ExistingRecordingList({
    Key key
  }): super(key: key);

  @override
  ExistingRecordingsState createState() => new ExistingRecordingsState();
}
class ExistingRecordingsState extends State<ExistingRecordingList> {

  List<String> directories;
  Map<String, List<File>> filessystem = new HashMap();

  void initState() {
    super.initState();
    directories = [];
    generateFilesFromLocalStorage();
  }


  generateFilesFromLocalStorage() async {
    List<String> drsHolder = [];
    Future<List<String>> drs = localDirectories;
    drs.then((values) {
      drsHolder.addAll(values);
        for(int i = 0; i < drsHolder.length; i++) {
          if(drsHolder[i].contains('sample')) {
            deleteDirectory(drsHolder[i]);
          } else {
            Future<List<File>> files = getfilesInDirectory(drsHolder[i]);
            files.then((value) {
              if(value.length == 5) {
                filessystem[drsHolder[i]] = value;
                setState(() {
                  directories.add(drsHolder[i].substring(drsHolder[i].lastIndexOf('/') + 1));
                });
              }
            });
          }
        }
    });
  }

  submitFiles() async {
    filessystem.forEach((key, value) {
      if(value.length == 5) {
        int i = 0;
        for(var file in value) {
          String name = file.path.substring(file.path.lastIndexOf('/') + 1);
          Future<dynamic> holder = upload_file(name.substring(0, name.indexOf('.')), "test@test.com", key.substring(key.lastIndexOf('/') + 1), file);
          holder.then((value) {
            i++;
            if(i == 5) {
              deleteDirectory(key);
              generateFilesFromLocalStorage();
              setState(() {
                
              });
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SizedBox(
          height: (MediaQuery.of(context).size.height * 0.90),
          child: Column(
            children: <Widget> [
              Container(
                height: 75,
                width: 150,
                margin: EdgeInsets.all(10),
                color: Colors.blue,
                child: FlatButton(
                  child: Text('Have Wifi?\nSubmit All', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    submitFiles();
                  },
                )
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: directories.length,
                  itemBuilder: (context, index) {
                    return ExistingRecordingTile(timeStamp: directories[index]);
                  }
                )
              )
            ]
          )
        )
    );
  }
}