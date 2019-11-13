import 'package:flutter/material.dart';
import 'package:mobile/widgets/carousel_dots.dart';
import 'package:mobile/widgets/devices_dialog.dart';
import 'package:mobile/widgets/carousel.dart';
import 'package:mobile/widgets/form.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  
  int _pageNumber;
  int _carouselPage;
  bool _admin;
  
  GlobalKey<CarouselDotsState> _keyChild = GlobalKey();

  void initState() {
    super.initState();
    _admin = true;
    _pageNumber = 0;
    _carouselPage = 0;
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

  List<BottomNavigationBarItem> getItems() {
    List<BottomNavigationBarItem> authorized = [];

    authorized.add(items[0]);
    if (_admin) {
      authorized.add(items[1]);
    }
    authorized.add(items[2]);

    return authorized;
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
              Text(_carouselPage.toString()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 100,
                    color: Colors.red,
                    child: FlatButton(
                      child: Text('Record'),
                      onPressed: (){},
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
          ) : Container()//DevicesDialog(),

          //DevicesDialog()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: getItems(),
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