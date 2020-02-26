import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:core';

class ReadBluetooth {

  final BluetoothDevice server;
  final Function callback;

  static final clientID = 0;
  BluetoothConnection connection;

  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;
  
  ReadBluetooth({this.server, this.callback}) {
    BluetoothConnection.toAddress(server.address).then((_connection) {
      connection = _connection;
        isConnecting = false;
        isDisconnecting = false;

        connection.input.listen(_onDataReceived).onDone(() {
          if (isDisconnecting) {
            print('Disconnecting locally!');
          }
          else {
            print('Disconnected remotely!');
          }
        });
      });
  }

  void _onDataReceived(dynamic data) {
    //ByteData.view(data.buffer);

    // List<int> list = new List.from(data);
    // callback(list);

  // if (data.length > 0) {
  //   String dataString = String.fromCharCodes(data);
  //   callback(double.tryParse(dataString));
  // }
  //   for(int i = 0; i < data.length; i++) {
  //     callback(data[i]);
  //   }
  // }
    if(data != null) {
      // if(data.length < 32 && data.length > 1) {
      //   Uint8List sizedList = new Uint8List(32);
      //   for(int i = (32-data.length); i < 32; i++) {
      //     int j = i - (32-data.length);
      //     sizedList[i] = data[j];
      //   }
      //   List<int> list = new List.from(sizedList);
      //   callback(list);
      // } else {
        List<int> list = new List.from(data);
        callback(list);
      // }
    } else {
      print('empty packet');
    }
  }
}

// void _onDataReceived(dynamic data) {
//     int backspacesCounter = 0;
//     data.forEach((byte) {
//       if (byte == 8 || byte == 127) {
//         backspacesCounter++;
//       }
//     });
//     Uint8List buffer = Uint8List(data.length - backspacesCounter);
//     int bufferIndex = buffer.length;

//     // Apply backspace control character
//     backspacesCounter = 0;
//     for (int i = data.length - 1; i >= 0; i--) {
//       if (data[i] == 8 || data[i] == 127) {
//         backspacesCounter++;
//       }
//       else {
//         if (backspacesCounter > 0) {
//           backspacesCounter--;
//         }
//         else {
//           buffer[--bufferIndex] = data[i];
//         }
//       }
//     }

//     // Create message if there is new line character
//     String dataString = String.fromCharCodes(buffer);
//     if (dataString == '') {
//       dataString = '-257099457.0';
//     }
//     callback(int.parse(dataString));
//   }
// }