// import 'dart:core';
// import 'dart:async';
// import 'dart:io';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';

// class WavGenerator {

//   WavGenerator(String filename, List<int> bits, int numSeconds, int sampleCount) {
//     this.filename = filename;
//     this.bits = bits;
//     this.numSeconds = numSeconds;
//     this.sampleCount = sampleCount;
//   }


//   //All headers and info needed to make the .wav
//   String filename;
//   List<int> bits; 
//   int numSeconds;
//   int sampleCount;
//   final int sampleRate = 44100;
//   final int bitDepth = 16;
//   final numChannels = 1;  

//   //The list used to hold all info and be converted into a .wav
//   List<dynamic> data;

//   ///Get the current directory
//   Future<String> get _localPath async {
//     final directory = await getApplicationDocumentsDirectory();
//     return directory.path;
//   }

//   ///Get a single file
//   Future<File> get _localFile async {
//     final path = await _localPath;
//     return File('$path/$filename.wav');
//   }

//   ///Get a future of all files in the local directory
//   Future<List<File>> get localFiles async {
//     List<File> files = [];
//     final path = await _localPath;
//     var directory = Directory('$path');
//     directory.list(recursive: true, followLinks: false)
//       .listen((FileSystemEntity entity) {
//         files.add(File(entity.path));
//       });
//     return files;
//   }

//   ///Get the audio block requested and return the file
//   Future<int> playAudio() async {
//     try {
//       final file = await _localFile;
//       // Read the file
//       int contents = (await file.readAsBytes()) as int;

//       return contents;
//     } catch (e) {
//       // If encountering an error, return 0
//       return 0;
//     }
//   }

//   ///Write the sound bytes to file, returning a future that we can wait on later
//   Future<File> writeAudio(int counter) async {
//     final file = await _localFile;
    
//     data.add(("RIFF").codeUnits.map((int strInt) => strInt.toRadixString(2)));
//     data.add((bitDepth / 8) * sampleCount + 36);
//     data.add(("WAVE").codeUnits.map((int strInt) => strInt.toRadixString(2)));
//     data.add(("fmt ").codeUnits.map((int strInt) => strInt.toRadixString(2)));
//     data.add(16.toRadixString(2));
//     data.add(1.toRadixString(2));//3 is floating point format, 1 is not
//     data.add(numChannels.toRadixString(2));
//     data.add(sampleRate.toRadixString(2));
//    // data.add((sampleRate * numChannels * (bitDepth / 8)).toRadixString(2));
//     data.add(numChannels * (bitDepth / 8));
//     data.add(bitDepth.toRadixString(2));
//     data.add(bits);
//     data.add((bitDepth / 8) * sampleCount);

//     return file.writeAsBytes(bits);
//   }
// }