import 'package:flutter/material.dart';

import '../style.dart';

class Suggestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "welcome to Sugestion",
            style: TitleTextStyle,
          ),
          Text(
            "your suggestions are shown here",
            style: Body1TextStyle,
          )
        ],
      ),
    );
  }
}
