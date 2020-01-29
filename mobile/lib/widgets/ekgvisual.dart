
import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:oscilloscope/oscilloscope.dart';
import 'package:flutter_blue/flutter_blue.dart';

class EKGVisual extends StatefulWidget {
  const EKGVisual({Key key, this.device}) : super(key: key);
  final BluetoothDevice device;

  EKGVisualState createState () => new EKGVisualState();
}

class EKGVisualState extends State<EKGVisual> {
  final String SERVICE_UUID = "f44f8b7b-951c-4009-9169-a9d9751115a6";
  final String CHARACTERISTIC_UUID = "23d0b3fe-793e-488a-aaae-aec2999efd55";
  bool isReady;
  Stream<List<int>> stream;
  List<double> traceDust = List();

  @override
  void initState() {
    super.initState();
    isReady = false;
    connectToDevice();
  }

  @override
  void dispose() {
    super.dispose();
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
                      print(double.tryParse(currentValue));
                      traceDust.add(double.tryParse(currentValue) ?? 0);
                      return Oscilloscope(
                        showYAxis: true,
                        padding: 10.0,
                        backgroundColor: Colors.black,
                        traceColor: Colors.red,
                        yAxisMax: 200000000.0,
                        yAxisMin: -500000000.0,
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