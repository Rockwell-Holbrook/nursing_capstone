import 'dart:core';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class WavGenerator {

  static const int RIFF_CHUNK_SIZE_INDEX = 4;
  static const int SUB_CHUNK_SIZE = 16;
  static const int AUDIO_FORMAT = 1;
  static const int BYTE_SIZE = 8;

  WavGenerator(String filename, List<int> bits) {
    this.filename = filename;
    this.bits = bits;
    this.numSeconds = numSeconds;
    this.sampleCount = sampleCount;
    _initializeWave();
  }


  //All headers and info needed to make the .wav
  String filename;
  List<int> bits; 
  int numSeconds;
  int sampleCount;
  final int _frequency = 44100;
  final int _bitRate = 32;
  final _numChannels = 1; 
  int _dataChunkSizeIndex = 0;
  List<int> _outputBytes = <int>[];
  final Utf8Encoder _utf8encoder = Utf8Encoder(); 

  ///Get the current directory
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  ///Get a single file
  Future<File> get localFile async {
    final path = await _localPath;
    return File('$path/$filename.wav');
  }

  ///Get a future of all files in the local directory
  Future<List<File>> get localFiles async {
    List<File> files = [];
    final path = await _localPath;
    var directory = Directory('$path');
    directory.list(recursive: true, followLinks: false)
      .listen((FileSystemEntity entity) {
        files.add(File(entity.path));
      });
    return files;
  }

  ///Get the audio block requested and return the file
  Future<int> playAudio() async {
    try { 
      final file = await localFile;
      // Read the file
      int contents = (await file.readAsBytes()) as int;

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  void _initializeWave() {
    _outputBytes.addAll(_utf8encoder.convert('RIFF'));
    _outputBytes.addAll(ByteUtils.numberAsByteList(0, 4, bigEndian: false));
    _outputBytes.addAll(_utf8encoder.convert('WAVE'));

    _createFormatChunk();
    _writeDataChunkHeader();
  }

  void _createFormatChunk() {
    var byteRate = _frequency * _numChannels * _bitRate ~/ BYTE_SIZE,
        blockAlign = _numChannels * _bitRate ~/ 8,
        bitsPerSample = _bitRate;
    _outputBytes.addAll(_utf8encoder.convert('fmt '));
    _outputBytes.addAll(
        ByteUtils.numberAsByteList(SUB_CHUNK_SIZE, 4, bigEndian: false));
    _outputBytes
        .addAll(ByteUtils.numberAsByteList(AUDIO_FORMAT, 2, bigEndian: false));//try this as a byte
    _outputBytes
        .addAll(ByteUtils.numberAsByteList(_numChannels, 2, bigEndian: false));
    _outputBytes
        .addAll(ByteUtils.numberAsByteList(_frequency, 4, bigEndian: false));//try this as a byte
    _outputBytes
        .addAll(ByteUtils.numberAsByteList(byteRate, 4, bigEndian: false));//try this as a byte
    _outputBytes
        .addAll(ByteUtils.numberAsByteList(blockAlign, 2, bigEndian: false));
    _outputBytes
        .addAll(ByteUtils.numberAsByteList(bitsPerSample, 2, bigEndian: false));
  }

  void _writeDataChunkHeader() {
    _outputBytes.addAll(_utf8encoder.convert('data'));
    _dataChunkSizeIndex = _outputBytes.length;
    _outputBytes.addAll(ByteUtils.numberAsByteList(0, 4, bigEndian: false));
  }

  ///Write the sound bytes to file, returning a future that we can wait on later
  Future<File> writeAudio() async {
    for (int i = 0; i < bits.length; i++) {
      _outputBytes.addAll(ByteUtils.numberAsByteList(bits[i], 4));
    }

    _finalize();
    print('breakpoint');
    final file = await localFile;
    return file.writeAsBytes(_outputBytes);
  }

    void _updateRiffChunkSize() {
    _outputBytes.replaceRange(
        RIFF_CHUNK_SIZE_INDEX,
        RIFF_CHUNK_SIZE_INDEX + 4,
        ByteUtils.numberAsByteList(
            _outputBytes.length - (RIFF_CHUNK_SIZE_INDEX + 4), 4,
            bigEndian: false));
  }

  void _updateDataChunkSize() {
    _outputBytes.replaceRange(
        _dataChunkSizeIndex,
        _dataChunkSizeIndex + 4,
        ByteUtils.numberAsByteList(
            _outputBytes.length - (_dataChunkSizeIndex + 4), 4,
            bigEndian: false));
  }

  void _finalize() {
    _updateRiffChunkSize();
    _updateDataChunkSize();
  }
}

class ByteUtils {
  static List<int> numberAsByteList(int input, numBytes, {bigEndian = true}) {
    var output = <int>[], curByte = input;
    for (var i = 0; i < numBytes; ++i) {
      output.insert(bigEndian ? 0 : output.length, curByte & 255);
      curByte >>= 8;
    }
    return output;
  }

  static int findByteSequenceInList(List<int> sequence, List<int> list) {
    for (var outer = 0; outer < list.length; ++outer) {
      var inner = 0;
      for (;
          inner < sequence.length &&
              inner + outer < list.length &&
              sequence[inner] == list[outer + inner];
          ++inner) {}
      if (inner == sequence.length) {
        return outer;
      }
    }
    return -1;
  }
}