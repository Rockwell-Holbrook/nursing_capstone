///Plays existing .wav files from local storage or receives an existing audio block 
///to play over the phone's speakers.

import 'dart:io';
import 'package:soundpool/soundpool.dart';
import 'package:path_provider/path_provider.dart';

mixin AudioPlayer {

  String _fileName = "";
  Soundpool _pool = Soundpool(streamType: StreamType.notification);

  ///Allow the parent widget to set the filename of the mixin
  void setFilePath(String fileName) {
    _fileName = fileName;
  }

  ///Get the current directory
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  ///Get a single file
  Future<File> get localFile async {
    final path = await _localPath;
    return File('$path/$_fileName.wav');
  }

  ///Get the audio block requested from local storage and plays it on the phone's current speaker.
  ///Returns an Id of the audio stream if successful, else returns 0
  Future<int> playLocalAudio() async {
    try { 
      final file = await localFile;
      // Read the file, play the contents as bytes
      int contents = (await file.readAsBytes()) as int;
      int streamId = await _pool.play(contents);
      return streamId;
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }  

  ///Receives an audio block that has been retrieved from the network and plays it on the phone's current speaker.
  ///Returns an Id of the audio stream if successful, else returns 0
  Future<int> playNetworkAudio(int contents) async {
    try { 
      int streamId = await _pool.play(contents);
      return streamId;
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }  
}