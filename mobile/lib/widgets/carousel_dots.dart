import 'package:flutter/material.dart';

class CarouselDots extends StatefulWidget {
  @override
  CarouselDotsState createState() =>
    new CarouselDotsState();

  const CarouselDots(Key key) : super(key : key);
}

class CarouselDotsState extends State<CarouselDots> {
int _index;
List<Icon> _dotIcons;

void initState() {
  super.initState();
  _index = 0;
  _dotIcons = [Icon(Icons.radio_button_checked), Icon(Icons.radio_button_unchecked), Icon(Icons.radio_button_unchecked),
                        Icon(Icons.radio_button_unchecked), Icon(Icons.radio_button_unchecked)];
}

void changeDots(i) {
  setState(() {
  _dotIcons[_index] = Icon(Icons.radio_button_unchecked);
  _dotIcons[i] = Icon(Icons.radio_button_checked);
  _index = i;
  });
}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _dotIcons,
      )
    );
  }

}

