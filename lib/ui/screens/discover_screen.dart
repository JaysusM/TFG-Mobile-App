import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:mobile_app/ui/screens/active_screen.dart';
import 'package:mobile_app/ui/widgets/device_tile.dart';
import 'dart:convert';
import 'package:internationalization/internationalization.dart';
import 'package:mobile_app/ui/widgets/loading_indicator.dart';
import 'package:mobile_app/ui/widgets/loading_loader.dart';

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
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool _isLoading = true;

  @override
  void initState() {
    _devices = new Set();
    _flutterBluetoothSerial.startDiscovery().listen((event) {
      this.setState(() {
        _devices.add(event.device);
      });
    }).onDone(() {
      this.setState(() {
        this._isLoading = false;
      });
    });
    super.initState();
  }

  ListTile getListTile(String titleResource, String subtitleResource) {
    return ListTile(
        title: Text(Strings.of(context).valueOf(titleResource),
            style: Theme.of(context)
                .textTheme
                .headline
                .copyWith(color: Colors.white)),
        subtitle: Text(Strings.of(context).valueOf(subtitleResource)));
  }

  void connectToDevice(BluetoothDevice device) async {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: getListTile("pairing", "pairing_wait")));

    this.setState(() {
      this._isLoading = true;
    });

    try {
      BluetoothConnection connection =
          await BluetoothConnection.toAddress(device.address);

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => ActiveScreen(connection)));

    } catch (error) {
      this.setState(() {
        this._isLoading = false;
      });

      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
            content: getListTile("error_connecting_title", "error_connecting")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(Strings.of(context).valueOf("discover"),
              style: Theme.of(context).textTheme.title),
        ),
        body: Stack(children: <Widget>[
          ListView(
              children: _devices
                  .map((device) => DeviceTile(device, this.connectToDevice))
                  .toList()),
          this._isLoading ? Center(child: LoadingLoader()) : Container(),
        ]));
  }
}
