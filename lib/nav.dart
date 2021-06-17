//bottom navigation page

import 'package:auto_size_text/auto_size_text.dart';
import 'package:farreco/screens/getStarted.dart';
import 'package:farreco/screens/signUp.dart';
import 'package:farreco/screens/splashScreen.dart';
import 'package:farreco/screens/userRegistration.dart';
import 'package:farreco/widgets/Loading.dart';
import 'package:farreco/widgets/provider.dart';
import 'package:flutter/material.dart';
import 'package:custom_navigator/custom_navigator.dart';

import 'screens/connect/connect.dart';
import 'screens/home.dart';
import 'screens/profile.dart';
import 'screens/sqi.dart';
import 'screens/suggestion.dart';
import 'style.dart';
import 'package:farreco/translation/translationConstants.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:farreco/translation/demoLocalization.dart';

class Nav extends StatefulWidget {
  const Nav({Key key}) : super(key: key);

  static void setLocale(BuildContext context, Locale locale) {
    _NavState state = context.findAncestorStateOfType<_NavState>();
    state.setLocale(locale);
  }

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  final primaryColor = const Color(0xFF1B5E20);

  Locale _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  Widget _page = Home();
  int _currentIndex = 0;
  String uid;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  //we can use customnavigation package or botttomNavigationBar widget directly
  //for persistent navigation custom navigation is used
  //implementation of bottom navigation widget is commented in this page

  @override
  Widget build(BuildContext context) {
    //get uid of the current user to pass it to sqi
    uid = Provider.of(context).auth.getCurrentUID();
    //list of widgets mapping to index of each item in the bottom navigation
    List<Widget> _widgetOptions = <Widget>[
      Home(),
      SQI(
        uid: uid,
      ),
      Connect(),
      Suggestion(),
    ];
    if (this._locale == null) {
      return MaterialApp(
          home: Scaffold(
        body: Container(),
      ));
    } else {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
              backgroundColor: const Color(0xFF1B5E20),
              title: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                    child: AutoSizeText(
                      getTranslated(context, "navPageTitleText"),
                      // 'Farreco',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Times New Roman',
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )),
              actions: <Widget>[
                //adding profile icon on the appbar to navigate to profile
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: _navigateToProfile,
                ),
              ]),
          bottomNavigationBar: BottomNavigationBar(
            items: buildNavItems(context),
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
            //mention routes to be used inside the bottom navigation bar
            routes: <String, WidgetBuilder>{
              '/nav': (BuildContext context) => ViewController(),
              '/profile': (BuildContext context) => Profile(),
              '/getStarted': (BuildContext context) => FirstView(),
              //send AuthFormType signUp for signing up
              '/signUp': (BuildContext context) =>
                  SignUpView(authFormType: AuthFormType.signUp),
              //send AuthFormType signIn for signing in
              '/signIn': (BuildContext context) =>
                  SignUpView(authFormType: AuthFormType.signIn),
              '/register': (BuildContext context) => UserRegistration(),
              '/loading': (BuildContext context) => LoadingScreen(),
            },
          ),
        ),
        locale: _locale,
        localizationsDelegates: [
          DemoLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', 'US'),
          Locale('te', 'IN'),
        ],
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          for (var supportedlocale in supportedLocales) {
            if (supportedlocale.languageCode == deviceLocale.languageCode) {
              return supportedlocale;
            }
          }
          return supportedLocales.first;
        },
      );
    }
  }

  buildNavItems(BuildContext context) {
    final _items = [
      BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
        ),
        label: getTranslated(
            context, "navPageBottomNavigationBarHomeButtonText"), //'Home',
        backgroundColor: const Color(0xFF1B5E20),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.bar_chart),
        label: getTranslated(
            context, "navPageBottomNavigationBarSQIButtonText"), //'SQI',
        backgroundColor: const Color(0xFF1B5E20),
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.people,
        ),
        label: getTranslated(context,
            "navPageBottomNavigationBarConnectButtonText"), //'Connect',
        backgroundColor: const Color(0xFF1B5E20),
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.lightbulb,
        ),
        label: getTranslated(context,
            "navPageBottomNavigationBarSuggestionButtonText"), //'suggestion',
        backgroundColor: const Color(0xFF1B5E20),
      ),
    ];
    return _items;
  }

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
