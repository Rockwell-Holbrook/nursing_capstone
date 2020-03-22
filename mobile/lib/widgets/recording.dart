import 'dart:async';
import 'dart:io';
import 'package:file/local.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';

class RecordingMic {

  RecordingMic(String filename, String patientId, BuildContext buildContext) {
    this.filename = filename;
    this.patientId = patientId;
    this.buildContext = buildContext;
    writeAudio();
  }

  String filename;
  String path;
  String patientId;
  BuildContext buildContext;
  
  ///Get the current directory
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  ///Get a single file
  void localFile() async {
    path = await _localPath;
  }

  ///Create the new directory, if it does not already exist
  Future<bool> createDirectory() async {
    if(await Directory('$path/$patientId').exists()) {
      return true;
    } else {
      Completer<bool> completer = new Completer();
      new Directory('$path/$patientId').create(recursive: true)
      // The created directory is returned as a Future.
      .then((Directory directory) {
        print(directory.path);
        completer.complete(true);
      });
      return completer.future;
    }
  }

  void writeAudio() async {
    bool hasPermission = await FlutterAudioRecorder.hasPermissions;
    await localFile();
    Future<bool> directoryExists = createDirectory();
    directoryExists.then((value) async {
      if(value) {
        var recorder = FlutterAudioRecorder("$path/$patientId/$filename.wav", audioFormat: AudioFormat.WAV, sampleRate: 44100); // or AudioFormat.WAV
        await recorder.initialized;
        var ready = recorder.current(channel: 0);
        ready.then((value) async {
          print(value);
          await recorder.start();
          var recording = await recorder.current(channel: 0);

          await new Future.delayed(const Duration(seconds : 10));
          
          var result = await recorder.stop();
          LocalFileSystem localFileSystem = new LocalFileSystem(); 
          File file = localFileSystem.file(result.path);
          Navigator.of(buildContext).pop();
        });
      } else {
        print('error accessing directory');
      }
    });
  }
}