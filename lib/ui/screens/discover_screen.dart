import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:mobile_app/ui/widgets/device_tile.dart';
import 'package:internationalization/internationalization.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DiscoverScreenState();
  }
}

// TODO Add permissions check for location & bluetooth

class DiscoverScreenState extends State<DiscoverScreen> {
  FlutterBluetoothSerial _flutterBluetoothSerial =
      FlutterBluetoothSerial.instance;
  Set<BluetoothDevice> _devices;

  @override
  void initState() {
    _devices = new Set();
    _flutterBluetoothSerial.startDiscovery().listen((event) {
      this.setState(() {
        _devices.add(event.device);
      });
    });
    super.initState();
  }

  void connectToDevice(BluetoothDevice device) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Pairing...",
                  style: Theme.of(context).textTheme.headline),
              content: Text(
                  "Please, wait, we are trying to connect with the selected device"));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).valueOf("discover"),
            style: Theme.of(context).textTheme.title),
      ),
      body: ListView(
          children: _devices
              .map((device) => DeviceTile(device, this.connectToDevice))
              .toList()),
    );
  }
}
