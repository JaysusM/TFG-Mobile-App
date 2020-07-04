import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:internationalization/internationalization.dart';
import 'package:mobile_app/ui/screens/login_screen.dart';
import 'package:mobile_app/ui/widgets/app_scaffold.dart';

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Internationalization.loadConfigurations();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: suportedLocales,
      localizationsDelegates: [
        Internationalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      title: 'Sound Reader',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: const Color(0xFF333349),
        accentColor: const Color(0xFF7E7F92),
        backgroundColor: const Color(0xFF333349),
        focusColor: const Color(0xFF7E7F92),
        buttonColor: const Color(0xFF3066BE),
        toggleableActiveColor: const Color(0xFFEA3742),
        textTheme: TextTheme(
          body1: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w300,
              color: Colors.black,
              fontSize: 17.0),
          caption: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w200,
              color: Colors.red,
              fontSize: 17.0),
          body2: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w200,
              color: Colors.black,
              fontSize: 17.0),
          title: TextStyle(
              fontFamily: 'OpenSansCondensed',
              fontSize: 24.0,
              fontStyle: FontStyle.italic,
              color: Colors.white),
          subtitle: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w100,
            fontSize: 14.0,
            color: Colors.black,
          ),
          headline: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w300,
            fontSize: 18.0,
            color: Colors.black,
          ),
          subhead: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w100,
            fontSize: 15.0,
            color: Colors.black,
          ),
          display1: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
            color: Colors.black,
          ),
          button: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w300,
              color: Colors.white,
              fontSize: 17.0
          )
        ),
      ),
      home: AppScaffold(mainView: LoginScreen(), title: "Sound Reader")
    );
  }
}
