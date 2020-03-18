import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

  ///Get the current directory
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  ///Get a single file
  Future<File> localFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename.wav');
  }

  ///Get a future of all directories within the local directory
  Future<List<String>> get localDirectories async {
    List<String> paths = [];
    final path = await _localPath;
    var directory = Directory('$path');
    Completer<List<String>> completer = new Completer();
    directory.list(recursive: false, followLinks: false)
      .listen((FileSystemEntity entity) {
        paths.add(entity.path);
      },
      onDone: () => completer.complete(paths));
    return completer.future;
  }
  
  ///Get a future of all files within the directory provided
  Future<List<File>> getfilesInDirectory(String dr) async {
    List<File> files = [];
    var directory = Directory('$dr');
    Completer<List<File>> completer = new Completer();
    directory.list(recursive: false, followLinks: false)
      .listen((FileSystemEntity entity) {
        files.add(File(entity.path));
      },
      onDone: () => completer.complete(files));
    return completer.future;
  }

  ///Deletes a directory
  bool deleteDirectory(String dr) {
    try{
      // Directory directory = Directory(dr);
      // directory.deleteSync(recursive: true);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }