///Plays existing .wav files from local storage or receives an existing audio block 
///to play over the phone's speakers.

import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

mixin AudioPlayerController {

  String _fileName = "";
  AudioPlayer audioPlayer = AudioPlayer();

  ///Allow the parent widget to set the filename of the mixin
  void _setFilePath(String fileName) {
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
  Future<int> playLocalAudio(String fileName) async {
    try {
      _setFilePath(fileName);
      final file = await localFile;
      int result = await audioPlayer.play(file.toString(), isLocal: true);
      return result;
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  ///Receives an audio block that has been retrieved from the network and plays it on the phone's current speaker.
  ///Returns an Id of the audio stream if successful, else returns 0
  Future<int> playNetworkAudio(String url) async {
    try {
      int result = await audioPlayer.play(url, volume: 100);
      return result;
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  ///Pause the audio
  Future<int> pauseAudio() async {
    int result = await audioPlayer.pause();
    return result;
  }

  ///Resume Audio
  Future<int> resumeAudio() async {
    int result = await audioPlayer.resume();
    return result;
  }

  ///Stop the audio by interrupting it
  Future<int> stopAudio() async {
    int result = await audioPlayer.stop();
    return result;
  }
}