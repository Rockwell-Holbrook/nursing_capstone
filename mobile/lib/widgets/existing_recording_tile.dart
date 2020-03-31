import 'package:flutter/material.dart';

class ExistingRecordingTile extends StatelessWidget {

  ExistingRecordingTile({
    this.timeStamp
  });

  String timeStamp;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white70,
        border: Border.all(
          color: Colors.black,
          width: 0.5,
        )
      ),
      child: Text(
        timeStamp,
        textAlign: TextAlign.center,
      )
    );
  }
}