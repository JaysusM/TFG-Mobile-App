import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapScreen extends StatelessWidget {
  
  static const String INITIAL_URL = "https://jmartinruiz-tfg-client.netlify.app/?mode=fullscreen";
  
  @override
  Widget build(BuildContext context) {
        return Container(
          child: WebView(
            initialUrl: INITIAL_URL,
            javascriptMode: JavascriptMode.unrestricted,
          ),
        );
  }
}