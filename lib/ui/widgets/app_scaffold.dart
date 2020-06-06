import 'package:flutter/material.dart';
import 'package:internationalization/internationalization.dart';
import 'package:mobile_app/ui/screens/map_screen.dart';

class AppScaffold extends StatefulWidget {

  final Widget mainView;
  final String title;
  final GlobalKey scaffoldKey;

  AppScaffold({@required this.mainView, @required this.title, this.scaffoldKey = null});

  @override
  State<StatefulWidget> createState() {
    return AppScaffoldState();
  }
}

class AppScaffoldState extends State<AppScaffold> {

  int _currentIndex;

  @override
  void initState() {
    _currentIndex = 0;
    super.initState();
  }

  void changePage(int index) {
    setState(() {
      this._currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentView = (this._currentIndex == 0) ? widget.mainView : MapScreen();
    String title = (this._currentIndex == 0) ? widget.title : Strings.of(context).valueOf("map");

    return Scaffold(
        key: widget.scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(title, style: Theme.of(context).textTheme.title),
        ),
        body: SafeArea(
          child: currentView,
        ),
        bottomNavigationBar: bottomNavBar(),
        );
  }

  Widget bottomNavBar() {
    Color primaryColor = Theme.of(context).primaryColor;
    Color accentColor = Theme.of(context).accentColor;
    String mapText = Strings.of(context).valueOf("map");
    String homeText = Strings.of(context).valueOf("home");

    return BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(homeText),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text(mapText),
          )
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: accentColor,
        backgroundColor: primaryColor,
        onTap: changePage
    );
  }
}
