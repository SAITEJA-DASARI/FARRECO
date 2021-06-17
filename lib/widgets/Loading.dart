import 'package:farreco/screens/signUp.dart';
import 'package:flutter/material.dart';
import 'package:farreco/translation/translationConstants.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          ],
        ));
  }
}

class FutureLoading extends StatelessWidget {
  final Color color;
  FutureLoading({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          getTranslated(context, "loadingPleaseWaitText"),
          // "Please wait...",
          style: TextStyle(color: color, fontSize: 20),
        ),
        SizedBox(
          height: 20.0,
        ),
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
        )
      ]),
    );
  }
}
