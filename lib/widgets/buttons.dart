import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final Color color;
  CustomBackButton({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.arrow_back,
          ),
        ],
      ),
      color: color,
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
