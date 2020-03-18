import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/data/networkRepo.dart';
import 'dart:io';
import 'package:mobile/widgets/carousel_dots.dart';
import 'package:mobile/widgets/select_device.dart';
import 'package:mobile/widgets/carousel.dart';
import 'package:mobile/widgets/recording.dart';
import 'package:mobile/widgets/read_bluetooth.dart';
import 'package:mobile/widgets/wavGenerator.dart';
import 'package:oscilloscope/oscilloscope.dart';
import 'package:mobile/widgets/recording_tile.dart';
import 'package:mobile/widgets/filter.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:mobile/widgets/ExistingRecordingList.dart';
import '../data/user.dart';

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

  List<int> audio = [];

  GlobalKey<CarouselDotsState> _keyChild = GlobalKey();
  GlobalKey<ExistingRecordingsState> _recordinList = GlobalKey();

  bool _currentlyRecording;
  String _patientId;

  void initState() {
    super.initState();
    _admin = true;
    _pageNumber = 0;
    _carouselPage = 0;

    _currentlyRecording = false;
    _patientId = '';

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
      icon: Icon(Icons.flag,color: Color.fromARGB(255, 0, 0, 0)),
      title: new Text('Admin Review')
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.update, color: Color.fromARGB(255, 0, 0, 0)),
      title: new Text('Review/Submit')
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
    if(server.name == 'wire') {
      print('wire)');
      RecordingMic mic = new RecordingMic('$_carouselPage', _patientId);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              height: 200,
              width: 250,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                ]
              )
            )
          );
        }
      );
      return;
    }
    GlobalKey stateKey = new GlobalKey();
    List<double> items = [];
    showDialog(
      context: context,
      builder: (_) {
        ReadBluetooth(
          server: server,
          callback: (List<int> data) {
            if(data != null) {
              audio.addAll(data);
              // setState(() {
              //   //items.add((data-255.0)/128.0 + 0.0);
              //   //stateKey.currentState.setState(() { });
              // });
            }
          }
        );

        return Padding(
          padding: EdgeInsets.fromLTRB(0, 150, 0, 150),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.red,
            // child: StatefulBuilder(
            //   key: stateKey,
            //   builder: (BuildContext context, StateSetter setState) {
            //     return Oscilloscope(
            //       showYAxis: true,
            //       padding: 10.0,
            //       backgroundColor: Colors.black,
            //       traceColor: Colors.red,
            //       yAxisMax: 1.0,
            //       yAxisMin: -1.0,
            //       dataSet: items,
            //     );
            //   }
            // )
          )
        );
      }
    ).then((value) {
      _writeWav();
      audio = [];
    });
  }

  void _writeWav() {
    // List<int> bytes = [];
    // for(int i = 0; i < audio.length; i++) {
    //   bytes.add(audio[i].toInt());
    // }
    if (audio != null) {
      WavGenerator wav = new WavGenerator("$_patientId/soundFileSample$_carouselPage", audio);
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beats Stethoscope'),
      ),
      drawer: (_pageNumber == 1) ?  Filter(
          callback: (){},
          submit:(){}
      ) : Container(),
      body: IndexedStack(
        index: _pageNumber,
        children: <Widget>[
          (_currentlyRecording)
          ? Column(
            children: <Widget>[
              Carousel(
                callback: (index) {
                  setState(() {
                    _carouselPage = index;
                  });
                  _keyChild.currentState.changeDots(index);
                },
                submit: () {
                  print('submit');
                  setState(() {
                    _patientId = '';
                    _currentlyRecording = false;
                  });
                  _recordinList.currentState.generateFilesFromLocalStorage();
                },
              ),
              CarouselDots(_keyChild),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 100,
                    color: Colors.blue,
                    child: FlatButton(
                      child: Text('Record'),
                      onPressed: () async {
                        final BluetoothDevice selectedDevice = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) { return SelectBondedDevicePage(checkAvailability: false); })
                        );
                        if (selectedDevice != null) {
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
                    color: Colors.blue,
                    child: FlatButton(
                      child: Text('Review'),
                      onPressed: (){
                        // WavGenerator wav = new WavGenerator("soundFileSample$_carouselPage", [0]);
                        // Future<File> file = wav.localFile;
                        // file.then((value) {
                        //   Future<Uint8List> test = value.readAsBytes();
                        //   test.then((nextValue) {
                        //     String newStuff = nextValue.toString();
                        //   });
                        // });
                      },
                    )
                  )
                ],
              ), 
              //BeatsForm(),
            ],
          )
          : Container(
            child: FlatButton(
              child: Center(
                child: Container(
                  height: 50,
                  width: 150,
                  color: Colors.blue,
                  child: Center(
                    child: Text('Create New Patient', style: TextStyle(color: Colors.white),)
                  )
                )
              ),
              onPressed: () async {
                // User user = new User();
                // await user.init();
                String holderId = await new_patient('test@test.com');//user.username
                setState(() {
                  _patientId = holderId;
                  _currentlyRecording = true;
                });
              },
            ),
          ),
          //index two
          (_admin) ? RecordingTile(
              callback: (){},
              submit:(){}
          ) : Container(),
          ExistingRecordingList(
            key: _recordinList,
          )
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