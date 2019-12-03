
import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:oscilloscope/oscilloscope.dart';
import 'package:flutter_blue/flutter_blue.dart';

class EKGVisual extends StatefulWidget {
  const EKGVisual({Key key, this.device}) : super(key: key);
  final BluetoothDevice device;

  _EKGVisualState createState () => new _EKGVisualState();
}

class _EKGVisualState extends State<EKGVisual> {
  final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";//"fe59bfa8-7fe3-4a05-9d94-99fadc69faff";//"91c10d9c-aaef-42bd-b6d6-8a648c19213d";//"4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";//"eea2e8a0-89f0-4985-a1e2-d91dc4a52632";//"99d1064e-4517-46aa-8fb4-6be64dd1a1f1";//"beb5483e-36e1-4688-b7f5-ea07361b26a8";
  bool isReady;
  Stream<List<int>> stream;
  List<double> traceDust = List();

  @override
  void initState() {
    super.initState();
    isReady = false;
    connectToDevice();
  }

  connectToDevice() async {
    if (widget.device == null) {
      print('no device detected');
      return;
    }
    discoverServices();
  }

  disconnectFromDevice() {
    if (widget.device == null) {
      print('no device detected');
      return;
    }

    widget.device.disconnect();
  }

  discoverServices() async {
    if (widget.device == null) {
      print('no device detected');
      return;
    }

    print('searchign services');

    List<BluetoothService> services = await widget.device.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            Future<bool> prepped = characteristic.setNotifyValue(!characteristic.isNotifying);
            prepped.then((value) async {
              stream = characteristic.value;
              setState(() {
                isReady = value;
              });
            });

          }
        });
      }
    });
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: !isReady
          ? Center(
              child: Text(
                "Waiting...",
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
            )
          : Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: StreamBuilder<List<int>>(
                  stream: stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<int>> snapshot) {
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    if (snapshot.connectionState ==
                        ConnectionState.active) {
                      var currentValue = _dataParser(snapshot.data);
                      if(currentValue == "") {
                        currentValue = "0.0";
                      }
                      print('new data');
                      print(double.tryParse(currentValue));
                      traceDust.add(double.tryParse(currentValue) ?? 0);
                      return Oscilloscope(
                        showYAxis: true,
                        padding: 10.0,
                        backgroundColor: Colors.black,
                        traceColor: Colors.red,
                        yAxisMax: 5.0,
                        yAxisMin: 0.0,
                        dataSet: traceDust,
                      );
                    } else {
                      print('test');
                      return Text('Check the stream');
                    }
                  },
                ),
              ),
            ]
          )
        )
      )
    );
  }
}