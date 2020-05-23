import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:loading/loading.dart';
import 'package:mobile_app/ui/widgets/loading_loader.dart';

class LoadingIndicator extends StatelessWidget {
  bool _isLoading;
  Widget _child;

  LoadingIndicator({@required isLoading, @required child}) {
    this._isLoading = isLoading;
    this._child = child;
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading) ? LoadingLoader() : _child;
  }
}
