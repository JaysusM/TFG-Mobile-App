import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:internationalization/internationalization.dart';
import 'package:mobile_app/utils/api.dart';

class RegisterForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterFormState();
  }
}

class RegisterFormState extends State<RegisterForm> {
  GlobalKey<FormState> key = new GlobalKey<FormState>();
  String _username, _password, _errorMessage;

  void handleUsernameSave(value) {
    this.setState(() {
      this._username = value;
    });
  }

  void handlePasswordSave(value) {
    this.setState(() {
      this._password = value;
    });
  }

  String handleUsernameValidation(value) {
    if (value?.length == 0) {
      return Strings.of(context).valueOf("username_required");
    }

    key.currentState.save();
    return null;
  }

  String handlePasswordValidation(value) {
    if (value.length < 6) {
      return Strings.of(context).valueOf("password_too_short");
    }

    key.currentState.save();
    return null;
  }

  void handleSignUpResponse(Response response, BuildContext context) {
    Map<String, dynamic> body = jsonDecode(response.body);
    if (body["code"] != 0) {
      this.setState(() {
        _errorMessage = body["message"];
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  void handleRegisterAction(BuildContext context) {
    bool isFormValid = key.currentState.validate();
    if (isFormValid) {
      Api apiInstance = Api.getInstance();
      String language = Strings.of(context).valueOf("language");
      apiInstance
          .signUp(_username, _password, language)
          .then((response) => handleSignUpResponse(response, context));
    }
  }

   Widget getErrorWidget(BuildContext context) {
    return (_errorMessage != null && _errorMessage.length > 0)
        ? Text(_errorMessage, style: Theme.of(context).textTheme.caption)
        : Container();
  }

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
                          .body2
                          .copyWith(fontSize: 30, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: fieldWidth * 0.25),
                    TextFormField(
                        validator: handleUsernameValidation,
                        onSaved: handleUsernameSave,
                        decoration: InputDecoration(
                            labelText: Strings.of(context).valueOf("username")),
                        style: Theme.of(context).textTheme.body1),
                    SizedBox(height: fieldWidth * 0.1),
                    TextFormField(
                      obscureText: true,
                      validator: handlePasswordValidation,
                      onChanged: (value) => this._password = value,
                      decoration: InputDecoration(
                          labelText: Strings.of(context).valueOf("password")),
                      style: Theme.of(context).textTheme.body1,
                    ),
                    SizedBox(height: fieldWidth * 0.1),
                    TextFormField(
                      obscureText: true,
                      onSaved: handlePasswordSave,
                      validator: (value) => value != this._password
                          ? Strings.of(context)
                              .valueOf("password_repeat_different")
                          : null,
                      decoration: InputDecoration(
                          labelText:
                              Strings.of(context).valueOf("repeat_password")),
                      style: Theme.of(context).textTheme.body1,
                    ),
                    SizedBox(height: fieldWidth * 0.1),
                    getErrorWidget(context),
                    SizedBox(height: fieldWidth * 0.1),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      splashColor: Theme.of(context).splashColor,
                      onPressed: _onSubmit,
                      child: Container(
                        child: Text(Strings.of(context).valueOf("register"),
                            style: Theme.of(context).textTheme.button),
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
