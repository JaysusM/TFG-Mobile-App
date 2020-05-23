import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:internationalization/internationalization.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_app/utils/api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_app/utils/globals.dart' as globals;

const SECONDS_PER_READ = 10;

class ActiveScreen extends StatefulWidget {
  final BluetoothConnection _connection;

  ActiveScreen(this._connection);

  @override
  State<StatefulWidget> createState() {
    return ActiveScreenState();
  }
}

class ActiveScreenState extends State<ActiveScreen> {
  final Api _api = Api.getInstance();
  int _numberReadOK, _numberReadFail;

  void sendRead(String username, String position, String value, String language) {
    _api
      .addNewValue(username, position, value, language)
      .then((_) => this.setState(() {
            this._numberReadOK++;
          }))
      .catchError((_) => this.setState(() {
            this._numberReadFail++;
          }));
  }

  @override
  void initState() {
    _numberReadOK = 0;
    _numberReadFail = 0;

    Permission.location.request().then((PermissionStatus status) {
      if (status.isGranted) {
        String readingData = "";
        widget._connection.input.listen((data) {
          readingData += ascii.decode(data);
          String separator = "\r\n";
          if (readingData.contains(separator)) {
            List<String> readings = readingData.split(separator);
            readingData = readings[1];
            Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
            .then((Position position) {
              String parsedPosition = "${position.latitude},${position.longitude}";
              String language = Strings.of(context).valueOf("language");
              String userId = globals.userId;

              sendRead(userId, parsedPosition, readings[0], language);
            }); 
          }
        });
      } else if (status.isPermanentlyDenied) {
        Navigator.of(context).pop();
        openAppSettings();
      } else if (status.isDenied) {
        Navigator.of(context).pop();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    widget._connection.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Strings.of(context).valueOf("active_screen"),
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: Card(
          child: ListTile(
        leading: Icon(Icons.hearing),
        title: Text(Strings.of(context).valueOf("sending_data"),
            style: Theme.of(context).textTheme.headline),
        subtitle: Text(
            "${Strings.of(context).valueOf("reads")}: ${this._numberReadOK + this._numberReadFail}",
            style: Theme.of(context)
                .textTheme
                .subtitle
                .copyWith(color: Theme.of(context).primaryColor)),
      )),
    );
  }
}
