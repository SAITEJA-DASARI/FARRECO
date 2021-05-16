//creating a provider class to provide single auth and db instance to entire application
import 'package:farreco/services/authService.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {
  final AuthService auth;
  final db;

  Provider({Key key, Widget child, this.auth, this.db})
      : super(key: key, child: child);

  //any update to the highest level widget wrapped in provider will be notified to all the child widgets in the application
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  //returns a provider at the particular context inherited from the highest level widget
  static Provider of(BuildContext context) {
    print("provider: ${context.dependOnInheritedWidgetOfExactType()}");
    return context.dependOnInheritedWidgetOfExactType<Provider>();
  }
}
