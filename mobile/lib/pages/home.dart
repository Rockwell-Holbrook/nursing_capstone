import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/data/networkRepo.dart';
import 'package:mobile/mixins/audio_player.dart';
import 'package:mobile/widgets/carousel_dots.dart';
import 'package:mobile/widgets/carousel.dart';
import 'package:mobile/widgets/recording.dart';
//import 'package:/widgets/wavGenerator.dart';
// import 'package:omobilescilloscope/oscilloscope.dart';
import 'package:mobile/data/user.dart';
import 'package:mobile/widgets/recording_tile.dart';
import 'package:mobile/widgets/filter.dart';
import 'package:mobile/widgets/ExistingRecordingList.dart';
import 'package:mobile/widgets/tag_recording.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> 
  with AudioPlayerController{
  
  int _pageNumber;
  int _carouselPage;
  bool _admin;
  // BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  String _address = "";
  String _name = "";

  Timer _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  List<int> audio = [];

  GlobalKey<NavigatorState> key = new GlobalKey();
  GlobalKey<CarouselDotsState> _keyChild = GlobalKey();
  GlobalKey<ExistingRecordingsState> _recordinList = GlobalKey();
  GlobalKey<RecordingsTileState> _tileState = GlobalKey();

  bool _currentlyRecording;
  String _patientId;
  bool _checked;

  Oscilloscope oscilloscope;

  void initState() {
    super.initState();
    setAdmin();
    _pageNumber = 0;
    _carouselPage = 0;

    _currentlyRecording = false;
    _patientId = '';

    _checked = false;

    oscilloscope = new Oscilloscope(
      yAxisMax: 440,
      yAxisMin: -440,
      dataSet: []
    );
  }

  void setAdmin() async {
    User user = new User();
    await user.init();
    await user.setUserType();
    setState(() {
      _admin = user.admin;
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

  void _startReading() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {

        GlobalKey stateKey = new GlobalKey(); 

        List<double> volumes = [];
        void callback(double nextValue) {
          stateKey.currentState.setState(() { 
            volumes.add(nextValue * 2.828); //2*sqrt(2) rms->peak
              oscilloscope = new Oscilloscope(
                yAxisMax: 440,
                yAxisMin: -440,
                dataSet: volumes
              );
          });
        }
        RecordingMic mic = new RecordingMic('$_carouselPage', _patientId + 'sample', context, callback);
        Future<bool> ready = mic.init();
        ready.then((value) {
          mic.viewAudio();
        });

        return  StatefulBuilder(
          key: stateKey,
          builder: (context, setState) { 
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Container(
                height: 300,
                width: 250,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 250,
                      width: 250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: oscilloscope,
                          )
                        ]
                      )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          child: Text('cancel'),
                          onPressed:() async {
                            await mic.cancel();
                            Navigator.of(context).pop();
                          }
                        ),
                        FlatButton(
                          child: Text('startRecording'),
                          onPressed:() async {
                            RecordingMic recordingMic = new RecordingMic('$_carouselPage', _patientId, context, callback);
                            Future<bool> ready = recordingMic.init();
                            ready.then((value) async {
                              await recordingMic.writeAudio();
                              await mic.cancel();
                            });
                          }
                        )
                      ]
                    )
                    //CircularProgressIndicator(),
                  ]
                )
              )
            );
          }
        );
      }
    );
  }

  // void _writeWav() {
  //   if (audio != null) {
  //     WavGenerator wav = new WavGenerator("$_patientId/soundFileSample$_carouselPage", audio);
  //   }
  // }

@override
  Widget build(BuildContext context) {

    List<String> routes = [
      '/',
      '/1',
      '/2'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Beats Stethoscope'),
      ),
      drawer: (_pageNumber == 1) ? Filter(
          callback:(){
            _tileState.currentState.setState(() { });
          },
          submit:(){}
      ) : Container(),
      body: Navigator(
        key: key,
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch(settings.name) {
                case '/':
                  return (_currentlyRecording)
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
                            height: 45,
                            width: 100,
                            color: Colors.blue,
                            child: FlatButton(
                              child: Text('Record'),
                              onPressed: () async {
                                _startReading();
                              }
                            )
                          ),
                          Container(
                            height: 45,
                            width: 100,
                            color: Colors.blue,
                            child: FlatButton(
                              child: Text('Review'),
                              onPressed: () {
                                playLocalAudio('$_carouselPage',  _patientId);
                              },
                            )
                          )
                        ],
                      ),
                      Text('Abnormal'),
                      Checkbox(
                        value: _checked,
                        onChanged: (checked) {
                          setState(() {
                            _checked = checked;
                          });
                          ///////Include network call to save that this is abnormal
                        })
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
                  );
                  break;
                case '/1':
                  return (_admin) 
                  ? RecordingTile(
                    key: _tileState,
                    submit:(){}
                  ) 
                  : Container();
                  break;
                case '/2':
                  return ExistingRecordingList(
                    key: _recordinList,
                  );
                  break;
                default:
                  return Container();
                  break;
              }
            }
          );
        }
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _getItems(),
        currentIndex: _pageNumber,
        //type: BottomNavigationBarType.shifting,
        onTap: (index) {
          if(_pageNumber != index) {
            setState(() {
            _pageNumber = index; 
            });
            key.currentState.pushReplacementNamed(routes[index]);
          }
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

// Copyright (c) 2018, Steve Rogers. All rights reserved. Use of this source code
// is governed by an Apache License 2.0 that can be found in the LICENSE file.
/// A widget that defines a customisable Oscilloscope type display that can be used to graph out data
///
/// The [dataSet] arguments MUST be a List<double> -  this is the data that is used by the display to generate a trace
///
/// All other arguments are optional as they have preset values
///
/// [showYAxis] this will display a line along the yAxisat 0 if the value is set to true (default is false)
/// [yAxisColor] determines the color of the displayed yAxis (default value is Colors.white)
///
/// [yAxisMin] and [yAxisMax] although optional should be set to reflect the data that is supplied in [dataSet]. These values
/// should be set to the min and max values in the supplied [dataSet].
///
/// For example if the max value in the data set is 2.5 and the min is -3.25  then you should set [yAxisMin] = -3.25 and [yAxisMax] = 2.5
/// This allows the oscilloscope display to scale the generated graph correctly.
///
/// You can modify the background color of the oscilloscope with the [backgroundColor] argument and the color of the trace with [traceColor]
///
/// The [padding] argument allows space to be set around the display (this defaults to 10.0 if not specified)
///
/// NB: This is not a Time Domain trace, the update frequency of the supplied [dataSet] determines the trace speed.
class Oscilloscope extends StatefulWidget {
  final List<double> dataSet;
  final double yAxisMin;
  final double yAxisMax;
  final double padding;
  final Color backgroundColor;
  final Color traceColor;
  final Color yAxisColor;
  final bool showYAxis;

  Oscilloscope(
      {this.traceColor = Colors.white,
      this.backgroundColor = Colors.black,
      this.yAxisColor = Colors.white,
      this.padding = 10.0,
      this.yAxisMax = 1.0,
      this.yAxisMin = 0.0,
      this.showYAxis = false,
      @required this.dataSet});

  @override
  _OscilloscopeState createState() => _OscilloscopeState();
}

class _OscilloscopeState extends State<Oscilloscope> {
  double yRange;
  double yScale;

  @override
  void initState() {
    super.initState();
    yRange = widget.yAxisMax - widget.yAxisMin;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(widget.padding),
      width: double.infinity,
      height: double.infinity,
      color: widget.backgroundColor,
      child: ClipRect(
        child: CustomPaint(
          painter: _TracePainter(
              showYAxis: widget.showYAxis,
              yAxisColor: widget.yAxisColor,
              dataSet: widget.dataSet,
              traceColor: widget.traceColor,
              yMin: widget.yAxisMin,
              yRange: yRange),
        ),
      ),
    );
  }
}

/// A Custom Painter used to generate the trace line from the supplied dataset
class _TracePainter extends CustomPainter {
  final List dataSet;
  final double xScale;
  final double yMin;
  final Color traceColor;
  final Color yAxisColor;
  final bool showYAxis;
  final double yRange;

  _TracePainter(
      {this.showYAxis,
      this.yAxisColor,
      this.yRange,
      this.yMin,
      this.dataSet,
      this.xScale = 2.0,
      this.traceColor = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final tracePaint = Paint()
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.0
      ..color = traceColor
      ..style = PaintingStyle.stroke;

    final axisPaint = Paint()
      ..strokeWidth = 1.0
      ..color = yAxisColor;

    double yScale = (size.height / yRange);

    // only start plot if dataset has data
    int length = dataSet.length;
    if (length > 0) {
      // transform data set to just what we need if bigger than the width(otherwise this would be a memory hog)
      if (length > size.width/2) {
        dataSet.removeAt(0);
        length = dataSet.length;
      }

      // Create Path and set Origin to first data point
      Path trace = Path();
      trace.moveTo(0.0, size.height - (dataSet[0].toDouble() - yMin) * yScale);

      // generate trace path
      for (int p = 0; p < length; p++) {
        double plotPoint =
            size.height - ((dataSet[p].toDouble() - yMin) * yScale);
        trace.lineTo(p.toDouble() * xScale, plotPoint);
      }

      // display the trace
      canvas.drawPath(trace, tracePaint);

      // if yAxis required draw it here
      if (showYAxis) {
        Offset yStart = Offset(0.0, size.height - (0.0 - yMin) * yScale);
        Offset yEnd = Offset(size.width, size.height - (0.0 - yMin) * yScale);
        canvas.drawLine(yStart, yEnd, axisPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_TracePainter old) => true;
}