import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:internationalization/internationalization.dart';
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

  void createToast(String message) {
    SchedulerBinding.instance.addPostFrameCallback((_) =>
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(message))));
  }

  @override
  void initState() {
    _timer = Timer.periodic(new Duration(seconds: SECONDS_PER_READ), (_) {
      Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        String parsedPosition = "${position.latitude},${position.longitude}";
        SchedulerBinding.instance.addPostFrameCallback((_) {
          String language = Strings.of(context).valueOf("language");
          _api
              .addNewValue("test", parsedPosition, "1.0", language)
              .then((_) => createToast("Success submitted read"))
              .catchError((_) => createToast("Error while submitting read"));
        });
      });
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
      body: Container(
        child: Text(Strings.of(context).valueOf("sending_data")),
      ),
    );
  }
}
