import 'package:farreco/models/user.dart';
import 'package:farreco/screens/signUp.dart';
import 'package:farreco/services/authService.dart';
import 'package:farreco/widgets/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../style.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Users user = Users("", "", "", "", "", "", 0.0, "");
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  _ProfileState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Container(
            padding: EdgeInsets.symmetric(horizontal: 100),
            child: Text(
              'Profile',
              style: AppBarTextStyle,
              textAlign: TextAlign.center,
            )),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder(
              future: _getUserInformation(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return _displayUserInformation(context, snapshot);
                } else {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator()]);
                }
              },
            )
          ]),
    );
  }

  _getUserInformation() async {
    final uid = Provider.of(context).auth.getCurrentUID();
    print(uid);
    return await Provider.of(context)
        .db
        .collection('users')
        .doc(uid)
        .get()
        .then((result) {
      user.name = result['name'];
      user.phoneNumber = result['phoneNumber'];
      user.landArea = result['landArea'];
      user.district = result['address']['district'];
      user.mandal = result['address']['mandal'];
      user.village = result['address']['village'];
      user.pincode = result['address']['pincode'];
    });
  }

  Widget _displayUserInformation(context, snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Name: ${user.name ?? 'Anonymous'}",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "phone: ${user.phoneNumber ?? 'Anonymous'}",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "landArea: ${user.landArea ?? 'Anonymous'}",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "village: ${user.village ?? 'Anonymous'}",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "mandal: ${user.mandal ?? 'Anonymous'}",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "district: ${user.district ?? 'Anonymous'}",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "pincode: ${user.pincode ?? 'Anonymous'}",
            style: TextStyle(fontSize: 20),
          ),
        ),
        ElevatedButton(
          child: Text("Sign Out"),
          onPressed: () {
            _signOut();
            _navigateToNav();
          },
        )
      ],
    );
  }

  Future<void> _signOut() async {
    try {
      AuthService authService = Provider.of(context).auth;
      await authService.signOut();
    } catch (e) {
      print(e);
    }
  }

  void _navigateToNav() {
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/nav');
  }
}
