import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {

  final Function callback;
  final Function submit;
  Carousel({
    @required this.callback,
    @required this.submit
  });

  @override
  _CarouselState createState() => 
    new _CarouselState(
      callback: callback,
      submit: submit
    );
}

class _CarouselState extends State<Carousel> {

  List<String> photos = [
    "graphics/aorticPoint.jpg",
    "graphics/hearsound1.jpg",
    "graphics/heartsound2.jpg"
  ];

  PageController _pageController;
  int _currentPage;
  final Function callback;
  final Function submit;

  _CarouselState({
    @required this.callback,
    @required this.submit
  });

  void initState() {
    super.initState();
    _currentPage = 0;
    _pageController = PageController(
      initialPage: _currentPage,
      keepPage: true,
      viewportFraction: 0.9
    );
  }

  backPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage -= 1;
      });
      callback(_currentPage);
      _pageController.animateToPage(_currentPage, duration: Duration(milliseconds: 400), curve: Curves.linear );
    } else {
      _pageController.animateToPage(_currentPage, duration: Duration(milliseconds: 400), curve: Curves.linear );
    }
  }

  forwardPage() {
    if (_currentPage < 4) {
      setState(() {
        _currentPage += 1;
      });
      callback(_currentPage);
      _pageController.animateToPage(_currentPage, duration: Duration(milliseconds: 400), curve: Curves.linear );
    } else {
      _pageController.animateToPage(_currentPage, duration: Duration(milliseconds: 400), curve: Curves.linear );
    }
  }

  itemBuilder(int index) {
    return AnimatedBuilder (
      animation: _pageController,
      builder: (context, child) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1.0 -(value.abs() * 0.6)).clamp(0.0, 1.0);
        }

        return Center (
          child: SizedBox(
            height: Curves.easeOut.transform(value) * 300,
            width: Curves.easeOut.transform(value) * 300,
            child: child,
          ),
        );
      },
      child: Container (
        //margin: const EdgeInsets.all(5.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                photos[(index % 3)]
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center (
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                //add buttons before and after expanded
                (_currentPage > 0) ? Container(
                  width: 50,
                  child: FlatButton (
                    onPressed: backPage,
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ) : Container(
                  width: 50,
                ),
                Expanded (
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width * 0.75),
                    height: (MediaQuery.of(context).size.height * 0.5),
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const AlwaysScrollableScrollPhysics (),
                      onPageChanged: (value) {
                        setState(() {
                        _currentPage = value;
                        });
                        callback(value);
                      },
                      itemBuilder: (context, index) => itemBuilder(index),
                      itemCount: 3,
                    ),
                  ),
                ),
                (_currentPage < photos.length - 1) ? Container(
                  width: 50,
                  child: FlatButton (
                    onPressed: forwardPage,
                    child: Icon(Icons.arrow_forward_ios),
                  ),
                ) : Container(
                  height: 50,
                  width: 50,
                  color: Colors.black12,
                  child: FlatButton(
                    child: Text('submit'),
                    onPressed: submit,
                  )
                ),
              ],
            )
          ]
        )
    );
  }
}