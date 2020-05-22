import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:loading/loading.dart';

class LoadingIndicator extends StatelessWidget {
  bool _isLoading;
  Widget _child;

  LoadingIndicator({@required isLoading, @required child}) {
    this._isLoading = isLoading;
    this._child = child;
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingWidget = Loading(
        indicator: LineScalePulseOutIndicator(),
        color: Theme.of(context).primaryColor);

    return (_isLoading) ? loadingWidget : _child;
  }
}
