import 'package:flutter/material.dart';

import '../style.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "welcome to farreco",
            style: TitleTextStyle,
          ),
          Text(
            "Thank you for choosing farreco",
            style: Body1TextStyle,
          )
        ],
      ),
    );
  }
}
