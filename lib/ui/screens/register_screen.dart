import 'package:flutter/material.dart';
import 'package:internationalization/internationalization.dart';
import 'package:mobile_app/ui/widgets/app_scaffold.dart';
import '../widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: Strings.of(context).valueOf("register"),
        mainView: Center(child: RegisterForm()));
  }
}
