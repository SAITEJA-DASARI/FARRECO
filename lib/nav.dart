//bottom navigation page

import 'package:flutter/material.dart';
import 'package:custom_navigator/custom_navigator.dart';

import 'screens/connect.dart';
import 'screens/home.dart';
import 'screens/profile.dart';
import 'screens/sqi.dart';
import 'screens/suggestion.dart';
import 'style.dart';

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  final primaryColor = const Color(0xFF1B5E20);
  //list of widgets mapping to index of each item in the bottom navigation
  List<Widget> _widgetOptions = <Widget>[
    Home(),
    SQI(),
    Connect(),
    Suggestion(),
  ];

  Widget _page = Home();
  int _currentIndex = 0;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  //we can use customnavigation package or botttomNavigationBar widget directly
  //for persistent navigation custom navigation is used
  //implementation of bottom navigation widget is commented in this page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFF1B5E20),
          title: Container(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Text(
                'Farreco',
                style: AppBarTextStyle,
                textAlign: TextAlign.center,
              )),
          actions: <Widget>[
            //adding profile icon on the appbar to navigate to profile
            IconButton(
              icon: Icon(Icons.person),
              onPressed: _navigateToProfile,
            ),
          ]),
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        onTap: (index) {
          navigatorKey.currentState.maybePop();
          setState(() => _page = _widgetOptions[index]);
          _currentIndex = index;
        },
        currentIndex: _currentIndex,
        selectedFontSize: 18.0,
        unselectedFontSize: 13.0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
      //used custome navigator library for bottom navigation bar
      body: CustomNavigator(
        navigatorKey: navigatorKey,
        home: _page,
        pageRoute: PageRoutes.materialPageRoute,
      ),
    );
  }

  final _items = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.home,
      ),
      label: 'Home',
      backgroundColor: const Color(0xFF1B5E20),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bar_chart),
      label: 'SQI',
      backgroundColor: const Color(0xFF1B5E20),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.people,
      ),
      label: 'Connect',
      backgroundColor: const Color(0xFF1B5E20),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.lightbulb,
      ),
      label: 'suggestion',
      backgroundColor: const Color(0xFF1B5E20),
    ),
  ];

  //function to navigate to profile
  void _navigateToProfile() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Profile()));
  }

  // void _onItemTap(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  // appBar: AppBar(
  //     backgroundColor: const Color(0xFF1B5E20),
  //     title: Container(
  //         padding: EdgeInsets.symmetric(horizontal: 100),
  //         child: Text(
  //           'Farreco',
  //           style: AppBarTextStyle,
  //           textAlign: TextAlign.center,
  //         )),
  //     actions: <Widget>[
  //       IconButton(
  //         icon: Icon(Icons.person),
  //         onPressed: _navigateToProfile,
  //       ),
  //     ]),
  //     body: Center(
  //       child: _widgetOptions.elementAt(_selectedIndex),
  //     ),
  //     //bottom navigation bar
  //     bottomNavigationBar: BottomNavigationBar(
  //       //make it fixed for 5 items in the navigation bar
  //       type: BottomNavigationBarType.fixed,
  //       items: const <BottomNavigationBarItem>[
  //   BottomNavigationBarItem(
  //     icon: Icon(
  //       Icons.home,
  //     ),
  //     label: 'Home',
  //   ),
  //   BottomNavigationBarItem(
  //     icon: Icon(Icons.bar_chart),
  //     backgroundColor: Colors.brown,
  //     label: 'SQI',
  //   ),
  //   BottomNavigationBarItem(
  //     icon: Icon(
  //       Icons.people,
  //     ),
  //     backgroundColor: Colors.white,
  //     label: 'Connect',
  //   ),
  //   BottomNavigationBarItem(
  //     icon: Icon(
  //       Icons.lightbulb,
  //     ),
  //     backgroundColor: Colors.green,
  //     label: 'suggestion',
  //   ),
  // ],
  //       onTap: _onItemTap,
  //       currentIndex: _selectedIndex,
  // selectedFontSize: 18.0,
  // unselectedFontSize: 13.0,
  // selectedItemColor: Colors.white,
  // unselectedItemColor: Colors.grey,
  // backgroundColor: const Color(0xFF1B5E20),
  //     ),
  //   );
  // }

}
