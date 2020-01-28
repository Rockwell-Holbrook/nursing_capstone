import 'package:flutter/material.dart';
import 'package:mobile/widgets/carousel_dots.dart';
import 'package:mobile/widgets/devices_dialog.dart';
import 'package:mobile/widgets/carousel.dart';
import 'package:mobile/widgets/form.dart';
import 'package:mobile/widgets/ekgvisual.dart';
import 'package:mobile/widgets/wavGenerator.dart';
import 'package:flutter_blue/flutter_blue.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  
  int _pageNumber;
  int _carouselPage;
  bool _admin;
  BluetoothDevice _device;

  GlobalKey<CarouselDotsState> _keyChild = GlobalKey();
  GlobalKey<EKGVisualState> _ekg = GlobalKey();

  void initState() {
    super.initState();
    _admin = true;
    _pageNumber = 0;
    _carouselPage = 0;
    _device = null;
    _getCurrentDevices();
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

  void _writeWav() {
    List<int> bytes = [];
    for(int i = 0; i < _ekg.currentState.traceDust.length; i++) {
      bytes.add(_ekg.currentState.traceDust as int);
    }
    WavGenerator wav =
        new WavGenerator("soundFile$_pageNumber", bytes);
    wav.writeAudio();
  }

  void _getCurrentDevices() {
    print(FlutterBlue.instance.toString());
    Future<List<BluetoothDevice>> connections = FlutterBlue.instance.connectedDevices;
    print(connections.toString());
    connections.then((onValue) {
      print(onValue.toString());
      setState(() {
        _device = onValue[0];
      });
    });
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
                        _getCurrentDevices();
                        await showDialog(
                          context: context,
                          builder: (_) => Padding(
                            padding: EdgeInsets.fromLTRB(0, 200, 0, 200),
                            child: Container(
                              height: 100,
                              width: 100,
                              color: Colors.red,
                              child: (_device == null) ? 
                                CircularProgressIndicator() 
                                : EKGVisual(
                                  key: _ekg,
                                  device: _device
                                ),
                            ),
                          )
                        ).then((value) {
                          _writeWav();
                        });
                      },
                    )
                  ),
                  Container(
                    height: 50,
                    width: 100,
                    color: Colors.red,
                    child: FlatButton(
                      child: Text('Review'),
                      onPressed: (){},
                    )
                  )
                ],
              ), 
              BeatsForm(),
            ],
          ),

          (_admin) ? Container(
            color: Colors.blue,
            child: Text(_carouselPage.toString()),
          ) : DevicesDialog(),
          DevicesDialog()
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