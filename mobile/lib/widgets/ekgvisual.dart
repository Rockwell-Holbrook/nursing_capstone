
import 'dart:async';
import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:oscilloscope/oscilloscope.dart';
import 'package:flutter_blue/flutter_blue.dart';

class EKGVisual extends StatefulWidget {
  const EKGVisual({Key key, this.device}) : super(key: key);
  final BluetoothDevice device;

  _EKGVisualState createState () => new _EKGVisualState();
}

class _EKGVisualState extends State<EKGVisual> {
  final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
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

    // new Timer(const Duration(seconds: 15), () {
    //   if (!isReady) {
    //     disconnectFromDevice();
    //   }
    // });

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
      print(widget.device.toString());
      print(services.toString());
      print(service.uuid.toString());
      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            stream = characteristic.value;

            setState(() {
              isReady = true;
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
    Oscilloscope oscilloscope = Oscilloscope(
      showYAxis: true,
      padding: 0.0,
      backgroundColor: Colors.black,
      traceColor: Colors.white,
      yAxisMax: 3000.0,
      yAxisMin: 0.0,
      dataSet: traceDust,
    );

    return Container(
      child: !isReady
          ? Center(
              child: Text(
                "Waiting...",
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
            )
          : Container(
              child: StreamBuilder<List<int>>(
                stream: stream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<int>> snapshot) {
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');

                  if (snapshot.connectionState ==
                      ConnectionState.active) {
                    var currentValue = _dataParser(snapshot.data);
                    traceDust.add(double.tryParse(currentValue) ?? 0);

                    return Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: oscilloscope,
                        )
                      ],
                    ));
                  } else {
                    return Text('Check the stream');
                  }
                },
              ),
            ),
    );
  }
}