import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:mobile/widgets/carousel_dots.dart';
import 'package:mobile/widgets/devices_dialog.dart';
import 'package:mobile/widgets/carousel.dart';
import 'package:mobile/widgets/read_bluetooth.dart';
import 'package:mobile/widgets/wavGenerator.dart';
import 'package:oscilloscope/oscilloscope.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  
  int _pageNumber;
  int _carouselPage;
  bool _admin;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  String _address = "";
  String _name = "";

  Timer _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  List<double> audio = [];

  GlobalKey<CarouselDotsState> _keyChild = GlobalKey();

  void initState() {
    super.initState();
    _admin = true;
    _pageNumber = 0;
    _carouselPage = 0;

    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() { _bluetoothState = state; });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if (await FlutterBluetoothSerial.instance.isEnabled) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() { _address = address; });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() { _name = name; });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance.onStateChanged().listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }

  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.perm_camera_mic,color: Color.fromARGB(255, 0, 0, 0)),
      title: new Text('New Recording')
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.refresh,color: Color.fromARGB(255, 0, 0, 0)),
      title: new Text('Review Recordings')
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bluetooth_audio,color: Color.fromARGB(255, 0, 0, 0)),
      title: new Text('Test Bluetooth Connection')
    )
  ];

  List<BottomNavigationBarItem> _getItems() {
    List<BottomNavigationBarItem> authorized = [];

    authorized.add(items[0]);
    if (_admin) {
      authorized.add(items[1]);
    }
    authorized.add(items[2]);

    return authorized;
  }

  void _startReading(BluetoothDevice server) {
    showDialog(
      context: context,
      builder: (_) {
        ReadBluetooth(
          server: server,
          callback: (double data) {
            setState(() {
              if(data == null) data = 0.0;
              audio.add(data);
              print(data);
            });
          }
        );

        return Padding(
          padding: EdgeInsets.fromLTRB(0, 150, 0, 150),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.red,
            child: Oscilloscope(
              showYAxis: true,
              padding: 10.0,
              backgroundColor: Colors.black,
              traceColor: Colors.red,
              yAxisMax: 196149185.0,
              yAxisMin: -257099457.0,
              dataSet: audio,
            )
          )
        );
      }
    ).then((value) {
      _writeWav();
      audio = [];
    });
  }

  void _writeWav() {
    List<int> bytes = [];
    if (audio != null) {
      for(int i = 0; i < audio.length; i++) {
        bytes.add(audio[i].toInt());
      }
    }
    WavGenerator wav =
        new WavGenerator("soundFileSample$_pageNumber", bytes);
    wav.writeAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beats Stethoscope'),
      ),
      body: IndexedStack(
        index: _pageNumber,
        children: <Widget>[
          Column(
            children: <Widget>[
              Carousel(
                callback: (index) {
                  setState(() {
                    _carouselPage = index;
                  });
                  _keyChild.currentState.changeDots(index);
                },
                submit: () {print('submit');},
              ),
              CarouselDots(_keyChild),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 100,
                    color: Colors.red,
                    child: FlatButton(
                      child: Text('Record'),
                      onPressed: () async {
                        final BluetoothDevice selectedDevice = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) { return SelectBondedDevicePage(checkAvailability: false); })
                        );
                        if (selectedDevice != null) {
                          print('Connect -> selected ' + selectedDevice.address);
                          _startReading(selectedDevice);
                        }
                        else {
                          print('Connect -> no device selected');
                        }
                      }
                    )
                  ),
                  Container(
                    height: 50,
                    width: 100,
                    color: Colors.red,
                    child: FlatButton(
                      child: Text('Review'),
                      onPressed: (){
                        WavGenerator wav = new WavGenerator("soundFileSample$_pageNumber", [0]);
                        Future<File> file = wav.localFile;
                        file.then((value) {
                          Future<Uint8List> test = value.readAsBytes();
                          test.then((nextValue) {
                            String newStuff = nextValue.toString();
                          });
                        });
                      },
                    )
                  )
                ],
              ), 
              //BeatsForm(),
            ],
          ),

          (_admin) ? Container(
            color: Colors.blue,
            child: Text(_carouselPage.toString()),
          ) : SelectBondedDevicePage(),
          //DevicesDialog()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _getItems(),
        currentIndex: _pageNumber,
        //type: BottomNavigationBarType.shifting,
        onTap: (index) {
          setState(() {
           _pageNumber = index; 
          });
        },
      ),
    );
  }
}

enum RecordinStatus {
  NORECORDING,
  ACTIVERECORDING,
  POSTRECORDING
}