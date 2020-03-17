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
    directory.list(recursive: false, followLinks: false)
      .listen((FileSystemEntity entity) {
        paths.add(entity.path);
      });
    return paths;
  }
  
  ///Get a future of all files within the directory provided
  Future<List<File>> getfilesInDirectory (String dr) async {
    List<File> files = [];
    final path = await _localPath;
    var directory = Directory('$path/$dr');
    directory.list(recursive: false, followLinks: false)
      .listen((FileSystemEntity entity) {
        files.add(File(entity.path));
      });
    return files;
  }

