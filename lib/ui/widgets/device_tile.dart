import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:internationalization/internationalization.dart';
import 'dart:convert';

class DeviceTile extends StatelessWidget {
  final BluetoothDevice _device;
  final void Function(BluetoothDevice) _onConnectClicked;

  DeviceTile(this._device, this._onConnectClicked);

  String getName(BuildContext context) {
    String name = this._device.name;
    return (name != null && name.isNotEmpty)
        ? name
        : Strings.of(context).valueOf("unnamed");
  }

  void connectToDevice() async {
    this._onConnectClicked(this._device);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      trailing: Container(
          child: IconButton(
              color: Theme.of(context).primaryColor,
              splashColor: Theme.of(context).secondaryHeaderColor,
              icon: Icon(Icons.bluetooth),
              onPressed: connectToDevice
              ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Theme.of(context).secondaryHeaderColor)),
      title:
          Text(getName(context), style: Theme.of(context).textTheme.headline),
      subtitle:
          Text(_device.address, style: Theme.of(context).textTheme.subtitle),
    ));
  }
}
