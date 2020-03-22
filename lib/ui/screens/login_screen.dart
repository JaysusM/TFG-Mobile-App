import 'package:flutter/material.dart';
import 'package:internationalization/internationalization.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double fieldWidth = MediaQuery.of(context).size.width * 0.6;

    return Center(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: fieldWidth / 8),
                child: Column(
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
                          decoration: InputDecoration(
                              labelText:
                                  Strings.of(context).valueOf("username")),
                          style: Theme.of(context).textTheme.body1),
                      SizedBox(height: fieldWidth * 0.1),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: Strings.of(context).valueOf("password")),
                        style: Theme.of(context).textTheme.body1,
                      ),
                      SizedBox(height: fieldWidth * 0.1),
                      RaisedButton(
                        color: Theme.of(context).primaryColor,
                        splashColor: Theme.of(context).splashColor,
                        onPressed: () => {},
                        child: Container(
                          child: Text(Strings.of(context).valueOf("login"),
                              style: Theme.of(context).textTheme.body2),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                      SizedBox(height: fieldWidth * 0.2),
                      Container(height: 1, color: const Color(0xFF000000)),
                      SizedBox(height: fieldWidth * 0.15),
                      Text(Strings.of(context).valueOf("new_account")),
                      SizedBox(height: fieldWidth * 0.05),
                      RaisedButton(
                        color: Theme.of(context).buttonColor,
                        splashColor: Theme.of(context).splashColor,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => RegisterScreen())),
                        child: Container(
                          child: Text(Strings.of(context).valueOf("register"),
                              style: Theme.of(context).textTheme.body2),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      )
                    ]))));
  }
}
