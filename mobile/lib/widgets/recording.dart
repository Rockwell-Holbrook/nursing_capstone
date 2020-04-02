import 'dart:async';
import 'dart:io';
import 'package:file/local.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';

class RecordingMic {

  RecordingMic(String filename, String patientId, BuildContext buildContext, Function callback) {
    this.filename = filename;
    this.patientId = patientId;
    this.buildContext = buildContext;
    this.callback = callback;
  }

  String filename;
  String path;
  String patientId;
  BuildContext buildContext;
  Function callback;

  FlutterAudioRecorder recorder;

  Future<bool> init() async {
    Completer<bool> completer = new Completer();
    bool hasPermission = await FlutterAudioRecorder.hasPermissions;
    await localFile();
    Future<bool> directoryExists = createDirectory();
    directoryExists.then((value) async {
      if(value) {
        recorder = FlutterAudioRecorder("$path/$patientId/$filename.wav", audioFormat: AudioFormat.WAV, sampleRate: 44100); // or AudioFormat.WAV
        await recorder.initialized;
        var ready = recorder.current(channel: 0);
        ready.then((value) {
          completer.complete(true);
        });
      }
    });
    return completer.future;
  }
  
  ///Get the current directory
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    //final directory = await getExternalStorageDirectory();
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
  
  void viewAudio()  async {
    Recording _current;
    RecordingStatus _currentStatus = RecordingStatus.Unset;
    var ready = recorder.current(channel: 0);
    ready.then((value) async {
      print(value);
      await recorder.start();
      try {
        const tick = const Duration(milliseconds: 1);
        new Timer.periodic(tick, (Timer t) async {
          if (_currentStatus == RecordingStatus.Stopped) {
            t.cancel();
          }

          var current = await recorder.current(channel: 0);
          //playwav file to speakers here
          callback(current.metering.averagePower);
          //callback(-1 * current.metering.averagePower);
          _current = current;
          _currentStatus = _current.status;
        });
      } catch (e) {
        print(e);
      }
    });
  }

  Future<bool> writeAudio() async {
    Recording _current;
    RecordingStatus _currentStatus = RecordingStatus.Unset;

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
          //const tick = const Duration(milliseconds: 50);
          await recorder.start();
          
          try {
            const tick = const Duration(milliseconds: 50);
            new Timer.periodic(tick, (Timer t) async {
              if (_currentStatus == RecordingStatus.Stopped) {
                t.cancel();
              }
              var current = await recorder.current(channel: 0);
              double power = current.metering.averagePower;
              if(power > -50 && power < 50) {
                callback(power);
                callback(power * -1);
              }
              _current = current;
              _currentStatus = _current.status;
            });
          } catch (e) {
            print(e);
          }

          await new Future.delayed(const Duration(seconds : 10));
          
          var result = await recorder.stop();
          LocalFileSystem localFileSystem = new LocalFileSystem(); 
          await new Future.delayed(const Duration(seconds : 3));
          File file = localFileSystem.file(result.path);
          Navigator.of(buildContext).pop();
          return true;
        });
      } else {
        print('error accessing directory');
      }
    });
  }

  void cancel() async {
    await recorder.stop();
    
    Navigator.of(buildContext).pop();
  }

}