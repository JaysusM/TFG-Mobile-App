import 'package:flutter/material.dart';
import 'package:internationalization/internationalization.dart';

class RegisterForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterFormState();
  }
}

class RegisterFormState extends State<RegisterForm> {
  GlobalKey<FormState> key = new GlobalKey<FormState>();
  String _username, _password;

  @override
  Widget build(BuildContext context) {
    double fieldWidth = MediaQuery.of(context).size.width * 0.6;

    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: fieldWidth / 8),
          child: Form(
              key: key,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: fieldWidth * 0.15),
                    Text(
                      Strings.of(context).valueOf("account_creation"),
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(fontSize: 30, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: fieldWidth * 0.25),
                    TextFormField(
                        validator: (value) => value?.length == 0
                            ? Strings.of(context).valueOf("username_required")
                            : null,
                        onChanged: (value) => this._username = value,
                        decoration: InputDecoration(
                            labelText: Strings.of(context).valueOf("username")),
                        style: Theme.of(context).textTheme.body1),
                    SizedBox(height: fieldWidth * 0.1),
                    TextFormField(
                      obscureText: true,
                      validator: (value) => value.length < 6
                          ? Strings.of(context).valueOf("password_too_short")
                          : null,
                      onChanged: (value) => this._password = value,
                      decoration: InputDecoration(
                          labelText: Strings.of(context).valueOf("password")),
                      style: Theme.of(context).textTheme.body1,
                    ),
                    SizedBox(height: fieldWidth * 0.1),
                    TextFormField(
                      obscureText: true,
                      validator: (value) => value != this._password
                          ? Strings.of(context)
                              .valueOf("password_repeat_different")
                          : null,
                      decoration: InputDecoration(
                          labelText:
                              Strings.of(context).valueOf("repeat_password")),
                      style: Theme.of(context).textTheme.body1,
                    ),
                    SizedBox(height: fieldWidth * 0.2),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      splashColor: Theme.of(context).splashColor,
                      onPressed: _onSubmit,
                      child: Container(
                        child: Text(Strings.of(context).valueOf("register"),
                            style: Theme.of(context).textTheme.body2),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                    SizedBox(height: fieldWidth * 0.3),
                  ]))),
      scrollDirection: Axis.vertical,
    );
  }

  void _onSubmit() {
    this.key.currentState.validate();
  }
}
