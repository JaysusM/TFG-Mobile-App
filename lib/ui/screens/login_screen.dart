import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double fieldWidth = MediaQuery.of(context).size.width * 0.6;

    return Container(
        padding: EdgeInsets.symmetric(horizontal: fieldWidth / 8),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Bienvenido a AcouMeter!",
                style: Theme.of(context).textTheme.body1.copyWith(fontSize: 20),
              ),
              SizedBox(height: fieldWidth * 0.15),
              TextFormField(
                  decoration: InputDecoration(labelText: "Usuario"),
                  style: Theme.of(context).textTheme.body1),
              SizedBox(height: fieldWidth * 0.1),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: "Contraseña"),
                style: Theme.of(context).textTheme.body1,
              ),
              SizedBox(height: fieldWidth * 0.1),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                splashColor: Theme.of(context).splashColor,
                onPressed: () => {},
                child:
                    Text("Registro", style: Theme.of(context).textTheme.body2),
              )
            ]));
  }
}
