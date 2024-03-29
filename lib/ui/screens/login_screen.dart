import 'dart:convert';
import 'package:mobile_app/utils/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:internationalization/internationalization.dart';
import 'package:mobile_app/ui/widgets/loading_indicator.dart';
import 'package:mobile_app/utils/api.dart';
import 'register_screen.dart';
import 'discover_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _errorMessage, _username, _password;
  bool _isLoading;

  void handleLoginResponse(Response response, BuildContext context) {
    Map<String, dynamic> body = jsonDecode(response.body);
    if (body["code"] != 0) {
      this.setState(() {
        _isLoading = false;
        _errorMessage = body["message"];
      });

    } else {
      String userId = body["data"]["userId"];
      globals.userId = userId;
      
      this.setState(() {
        _isLoading = false;
      });

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => DiscoverScreen()));
    }
  }

  void handleLoginAction(BuildContext context) {
    bool isFormValid = _formKey.currentState.validate();
    if (isFormValid) {
      this.setState(() {
        this._isLoading = true;
      });
      Api apiInstance = Api.getInstance();
      String language = Strings.of(context).valueOf("language");
      apiInstance
          .signIn(_username, _password, language)
          .then((response) => handleLoginResponse(response, context));
    }
  }

  String passwordValidation(String value, BuildContext context) {
    if (value?.length == 0) {
      return Strings.of(context).valueOf("password_required");
    }

    _formKey.currentState.save();
    return null;
  }

  String usernameValidation(String value, BuildContext context) {
    if (value?.length == 0) {
      return Strings.of(context).valueOf("username_required");
    }

    _formKey.currentState.save();
    return null;
  }

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double fieldWidth = MediaQuery.of(context).size.width * 0.6;

    return Center(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: fieldWidth / 8),
                child: Form(key: _formKey, child: getFormWidget(fieldWidth)))));
  }

  Widget getErrorWidget(BuildContext context) {
    return (_errorMessage != null && _errorMessage.length > 0)
        ? Text(_errorMessage, style: Theme.of(context).textTheme.caption)
        : Container();
  }

  Widget getLoginButton(BuildContext context) {
    return LoadingIndicator(
        isLoading: _isLoading,
        child: RaisedButton(
          color: Theme.of(context).primaryColor,
          splashColor: Theme.of(context).splashColor,
          onPressed: () => handleLoginAction(context),
          child: Container(
            child: Text(Strings.of(context).valueOf("login"),
                style: Theme.of(context).textTheme.button),
            padding: EdgeInsets.symmetric(horizontal: 10),
          ),
        ));
  }

  Widget getFormWidget(double fieldWidth) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: fieldWidth * 0.15),
          Text(
            Strings.of(context).valueOf("welcome"),
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(fontSize: 30, fontWeight: FontWeight.w300),
          ),
          SizedBox(height: fieldWidth * 0.15),
          TextFormField(
              onSaved: (value) {
                setState(() {
                  _username = value;
                });
              },
              validator: (value) => usernameValidation(value, context),
              decoration: InputDecoration(
                  labelText: Strings.of(context).valueOf("username")),
              style: Theme.of(context).textTheme.body1),
          SizedBox(height: fieldWidth * 0.1),
          TextFormField(
            onSaved: (value) {
              setState(() {
                _password = value;
              });
            },
            validator: (value) => passwordValidation(value, context),
            obscureText: true,
            decoration: InputDecoration(
                labelText: Strings.of(context).valueOf("password")),
            style: Theme.of(context).textTheme.body1,
          ),
          SizedBox(height: fieldWidth * 0.1),
          getErrorWidget(context),
          SizedBox(height: fieldWidth * 0.05),
          getLoginButton(context),
          SizedBox(height: fieldWidth * 0.2),
          Container(height: 1, color: const Color(0xFF000000)),
          SizedBox(height: fieldWidth * 0.15),
          Text(Strings.of(context).valueOf("new_account")),
          SizedBox(height: fieldWidth * 0.05),
          RaisedButton(
            color: Theme.of(context).buttonColor,
            splashColor: Theme.of(context).splashColor,
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => RegisterScreen())),
            child: Container(
              child: Text(Strings.of(context).valueOf("register"),
                  style: Theme.of(context).textTheme.button),
              padding: EdgeInsets.symmetric(horizontal: 10),
            ),
          )
        ]);
  }
}
