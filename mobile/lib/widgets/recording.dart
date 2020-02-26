
import 'dart:async';
import 'dart:io';
import 'package:file/local.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';

class RecordingMic {

  RecordingMic(String filename) {
    this.filename = filename;
    writeAudio();
  }

  String filename;
  String path;

  
  ///Get the current directory
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  ///Get a single file
  void localFile() async {
    path = await _localPath;
  }

  void writeAudio() async {
    bool hasPermission = await FlutterAudioRecorder.hasPermissions;
    await localFile();
    var recorder = FlutterAudioRecorder("$path/$filename.wav", audioFormat: AudioFormat.WAV, sampleRate: 44100); // or AudioFormat.WAV
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
    });
  }
}