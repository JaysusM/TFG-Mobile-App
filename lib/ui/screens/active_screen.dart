import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:internationalization/internationalization.dart';
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
  int _numberReadOK;
  Queue<String> _failsQueue;

  void sendRead(
      String username, double latitude, double longitude, String value, String language) {
        const String SEPARATOR = "|";

    if (_failsQueue.isNotEmpty) {
      do {
        List<String> values = _failsQueue.removeFirst().split(SEPARATOR);
        double latitude = double.parse(values[0]);
        double longitude = double.parse(values[1]);
        String value = values[2];
        sendRead(username, latitude, longitude, value, language);
      } while(_failsQueue.isNotEmpty);
    }

    _api
        .addNewValue(username, latitude, longitude, value, language)
        .then((message) => this.setState(() {
              print(message.body);
              this._numberReadOK++;
            }))
        .catchError((err) => this.setState(() {
              print(err);
              _failsQueue.add(latitude.toString() + SEPARATOR + longitude.toString() + SEPARATOR + value);
            }));
  }

  @override
  void initState() {
    _failsQueue = new Queue();
    _numberReadOK = 0;
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
          String language = Strings.of(context).valueOf("language");
          String userId = globals.userId;

          sendRead(userId, position.latitude, position.longitude, readings[0], language);
        });
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
        body: Stack(children: <Widget>[
          Card(
              child: ListTile(
            leading: Icon(Icons.hearing),
            title: Text(Strings.of(context).valueOf("sending_data"),
                style: Theme.of(context).textTheme.headline),
            subtitle: Text(
                "${Strings.of(context).valueOf("reads")}: ${this._numberReadOK}\n${Strings.of(context).valueOf("queued")}: ${_failsQueue.length}",
                style: Theme.of(context)
                    .textTheme
                    .subtitle
                    .copyWith(color: Theme.of(context).primaryColor)),
          )),
          Center(child: RaisedButton(
            child: Text(Strings.of(context).valueOf("stop_read"), style: TextStyle(color: Colors.white)),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ))
        ]));
  }
}
