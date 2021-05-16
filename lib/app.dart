import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farreco/screens/getStarted.dart';
import 'package:farreco/screens/profile.dart';
import 'package:farreco/screens/signUp.dart';
import 'package:farreco/screens/splashScreen.dart';
import 'package:farreco/screens/userRegistration.dart';
import 'package:farreco/services/authService.dart';
import 'package:farreco/widgets/Loading.dart';
import 'package:farreco/widgets/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'nav.dart';
import 'style.dart';

class App extends StatelessWidget {
  final primaryColor = const Color(0xFF1B5E20);
  @override
  Widget build(BuildContext context) {
    //Provider is used to inform the app about the user state and create a instance of db
    //db is available to entire app as provider wrapped the high level widget of the app
    return Provider(
        auth: AuthService(),
        db: FirebaseFirestore.instance,
        child: MaterialApp(
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
