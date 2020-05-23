import 'package:flutter/material.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:loading/loading.dart';

class LoadingLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Loading(
        indicator: LineScalePulseOutIndicator(),
        color: Theme.of(context).primaryColor);
  }
}