import 'package:flutter/material.dart';
import 'package:internationalization/internationalization.dart';
import '../widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(Strings.of(context).valueOf("register"),
              style: Theme.of(context).textTheme.title),
        ),
        body: Center(child: RegisterForm()));
  }
}
