import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

class AppScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("AcouMeter", style: Theme.of(context).textTheme.title),
        ),
        body: SafeArea(
          child: LoginScreen(),
        ));
  }
}
