import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DevicesDialog extends StatelessWidget {

  final FlutterBlue flutterBlue = FlutterBlue.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BlueTooth'
        ),
      ),
      body: scanNearbyDevices(),
    );
  }

  Widget scanNearbyDevices() {
    return Column(
      children: <Widget>[
      RefreshIndicator(
      onRefresh: () =>
        FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<List<BluetoothDevice>>(
              stream: Stream.periodic(Duration(seconds: 2))
                .asyncMap((_) => FlutterBlue.instance.connectedDevices),
              initialData: [],
              builder: (c, snapshot) => Column(
                children: snapshot.data
                    .map((d) => ListTile(
                      title: Text(d.name),
                      subtitle: Text(d.id.toString()),
                      trailing: StreamBuilder<BluetoothDeviceState>(
                      stream: d.state,
                      initialData: BluetoothDeviceState.disconnected,
                        builder: (c, snapshot) {
                          if (snapshot.data ==
                              BluetoothDeviceState.connected) {
                            return RaisedButton(
                              child: Text('OPEN'),
                              onPressed: () => print(snapshot.data.toString())
                            );
                          }
                          return Text(snapshot.data.toString());
                        },
                      ),
                    ))
                .toList(),
              ),
            ),
            StreamBuilder<List<ScanResult>>(
              stream: FlutterBlue.instance.scanResults,
              initialData: [],
              builder: (c, snapshot) => Column(
                children: snapshot.data
                  .map(
                    (r) => Text(r.toString()
                  )
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    ),
    StreamBuilder<bool>(
      stream: FlutterBlue.instance.isScanning,
      initialData: false,
      builder: (c, snapshot) {
        if (snapshot.data) {
          return FloatingActionButton(
            child: Icon(Icons.stop),
            onPressed: () => FlutterBlue.instance.stopScan(),
            backgroundColor: Colors.red,
          );
        } else {
          return FloatingActionButton(
              child: Icon(Icons.search),
              onPressed: () => FlutterBlue.instance
                  .startScan(timeout: Duration(seconds: 4)));
            }
          },
        )
      ],
    );
  }
}