import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farreco/screens/getStarted.dart';
import 'package:farreco/screens/profile.dart';
import 'package:farreco/screens/signUp.dart';
import 'package:farreco/screens/splashScreen.dart';
import 'package:farreco/screens/userRegistration.dart';
import 'package:farreco/services/authService.dart';
import 'package:farreco/translation/demoLocalization.dart';
import 'package:farreco/translation/translationConstants.dart';
import 'package:farreco/widgets/Loading.dart';
import 'package:farreco/widgets/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'style.dart';

final primaryColor = const Color(0xFF1B5E20);

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);
  static void setLocale(BuildContext context, Locale locale) {
    _AppState state = context.findAncestorStateOfType<_AppState>();
    state.setLocale(locale);
  }

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
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

  @override
  Widget build(BuildContext context) {
    if (this._locale == null) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              body: Container(
            color: primaryColor,
          )));
    } else {
      //Provider is used to inform the app about the user state and create a instance of db
      //db is available to entire app as provider wrapped the high level widget of the app
      return Provider(
          auth: AuthService(),
          db: FirebaseFirestore.instance,
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              //display splash screen at the start of the application
              home: SplashScreen(),
              //mention routes used in the application
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
                  if (supportedlocale.languageCode ==
                      deviceLocale.languageCode) {
                    return supportedlocale;
                  }
                }
                return supportedLocales.first;
              },

              //theme of the entire application
              theme: ThemeData(
                appBarTheme: AppBarTheme(
                  //TextTheme is a style widget available in the style.dart file
                  textTheme: TextTheme(headline1: AppBarTextStyle),
                ),
                textTheme: TextTheme(
                  headline1: TitleTextStyle,
                  bodyText1: Body1TextStyle,
                ),
              )));
    }
  }
}
