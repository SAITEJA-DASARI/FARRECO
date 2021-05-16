//displays splash screen for 5 seconds
//then navigates to nav page

import 'dart:async';
import 'package:farreco/nav.dart';
import 'package:farreco/services/authService.dart';
import 'package:farreco/widgets/provider.dart';
import 'package:flutter/material.dart';

import 'getStarted.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _primaryColor = const Color(0xFF1B5E20);
  @override
  void initState() {
    super.initState();
    //timer setting for splash screen
    //after 5 seconds routing is done based on the state of user using viewcontroller()
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ViewController(),
                fullscreenDialog: true)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: _primaryColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: Icon(
                          Icons.agriculture,
                          color: _primaryColor,
                          size: 50.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        "FARRECO",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "Farmers Guide",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class ViewController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //get auth from the provider
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder<String>(
      //inform provider if authState is changed
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        //check if connection is active
        if (snapshot.connectionState == ConnectionState.active) {
          //snapshot.hasdata returns true if authstate is signed in
          final bool signedIn = snapshot.hasData;
          //if signed in then return to nav page else return to gettingstarted page
          return signedIn ? Nav() : FirstView();
        }
        return CircularProgressIndicator();
      },
    );
  }
}
