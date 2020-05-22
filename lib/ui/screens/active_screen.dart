import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:internationalization/internationalization.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../utils/api.dart';
import 'package:geolocator/geolocator.dart';

const SECONDS_PER_READ = 10;

class ActiveScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ActiveScreenState();
  }
}

class ActiveScreenState extends State<ActiveScreen> {
  final Api _api = Api.getInstance();
  Timer _timer;
  int _numberReadOK, _numberReadFail;

  @override
  void initState() {
    _numberReadOK = 0;
    _numberReadFail = 0;

    Permission.location.request().then((PermissionStatus status) {
      if (status.isGranted) {
        _timer = Timer.periodic(new Duration(seconds: SECONDS_PER_READ), (_) {
          Geolocator()
              .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
              .then((Position position) {
            String parsedPosition =
                "${position.latitude},${position.longitude}";
            String language = Strings.of(context).valueOf("language");
            _api
                .addNewValue("test", parsedPosition, "1.0", language)
                .then((_) => this.setState(() {
                      this._numberReadOK++;
                    }))
                .catchError((_) => this.setState(() {
                      this._numberReadFail++;
                    }));
          });
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
    _timer.cancel();
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
