import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:location/location.dart' as Location;
import 'package:mobile_app/ui/screens/active_screen.dart';
import 'package:mobile_app/ui/widgets/app_scaffold.dart';
import 'package:mobile_app/ui/widgets/device_tile.dart';
import 'package:internationalization/internationalization.dart';
import 'package:mobile_app/ui/widgets/loading_loader.dart';
import 'package:permission_handler/permission_handler.dart';

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

  void startDiscovery() {
    _flutterBluetoothSerial.startDiscovery().listen((event) {
      this.setState(() {
        _devices.add(event.device);
      });
    }).onDone(() {
      this.setState(() {
        this._isLoading = false;
      });
    });
  }

  void checkLocationEnabled() async {
    var location = Location.Location();
    bool enabled = await location.serviceEnabled();

    if (enabled) {
      startDiscovery();
    } else {
      bool gotEnabled = await location.requestService();
      if (gotEnabled) {
        startDiscovery();
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void initState() {
    _devices = new Set();

    Permission.location.request().then((PermissionStatus status) {
      if (status.isGranted) {
        checkLocationEnabled();
      } else if (status.isPermanentlyDenied) {
        openAppSettings().then((_) async {
          if (!(await Permission.location.status).isGranted) {
            Navigator.of(context).pop();
          } else {
            checkLocationEnabled();
          }
        });
      } else if (status.isDenied) {
        Navigator.of(context).pop();
      }
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
    return AppScaffold(
        scaffoldKey: _scaffoldKey,
        title: Strings.of(context).valueOf("discover"),
        mainView: Stack(children: <Widget>[
          ListView(
              children: _devices
                  .map((device) => DeviceTile(device, this.connectToDevice))
                  .toList()),
          this._isLoading ? Center(child: LoadingLoader()) : Container(),
        ]));
  }
}
