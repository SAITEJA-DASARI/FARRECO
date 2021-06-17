import 'package:auto_size_text/auto_size_text.dart';
import 'package:farreco/app.dart';
import 'package:farreco/models/user.dart';
import 'package:farreco/services/authService.dart';
import 'package:farreco/translation/language.dart';
import 'package:farreco/translation/translationConstants.dart';
import 'package:farreco/widgets/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:farreco/widgets/buttons.dart';
import 'package:farreco/translation/translationConstants.dart';
import 'package:farreco/nav.dart';
import '../style.dart';
import 'package:farreco/models/utils.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Users user = Users("", "", "", "", "", "", 0.0, "", FarmingType.in_organic);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  _ProfileState();
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Container(
              child: Text(
            getTranslated(context, "profilePageTitleText"),
            // 'Profile',
            style: AppBarTextStyle,
            textAlign: TextAlign.center,
          )),
          leading: CustomBackButton(color: Colors.white),
          leadingWidth: 0.25 * _width,
          actions: [buildLanguageDropDown()],
        ),
        body: FutureBuilder(
          future: _getUserInformation(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _displayUserInformation(context, snapshot);
            } else {
              return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      )
                    ]),
              );
            }
          },
        ));
  }

  Padding buildLanguageDropDown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton(
        onChanged: (Language language) {
          _changeLanguge(language);
        },
        underline: SizedBox(),
        icon: Icon(
          Icons.language,
          color: Colors.white,
        ),
        items: Language.languageList()
            .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
                  value: lang,
                  child: AutoSizeText(
                    lang.name,
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ))
            .toList(),
      ),
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
    final _width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: ListView(
        children: [
          SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Card(
              elevation: 0.0,
              color: Colors.orange.shade600,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: ListTile(
                  title: Center(
                      child: AutoSizeText(
                    user.name,
                    style: textFieldTextStyle(),
                  )),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Card(
              elevation: 0.0,
              color: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListTile(
                        title: AutoSizeText(
                          getTranslated(context, "profilePagePhoneText") +
                              "${user.phoneNumber.substring(3)}",
                          style: textFieldTextStyle(),
                        ),
                      ),
                    ),
                    ListTile(
                      title: AutoSizeText(
                        getTranslated(context, "profilePageAreaText") +
                            "${user.landArea} " +
                            getTranslated(context, "profilePageAreaUnitText"),
                        style: textFieldTextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Card(
              elevation: 0.0,
              color: Colors.amberAccent,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListTile(
                        title: Center(
                            child: AutoSizeText(
                          getTranslated(context, "profilePageAddressText"),
                          // "Address",
                          style: TextStyle(
                              color: primaryColor,
                              fontFamily: 'arial',
                              fontSize: 30,
                              fontWeight: FontWeight.w900),
                        )),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: AutoSizeText(
                                getTranslated(
                                        context, "profilePageVillageText") +
                                    "${user.village}",
                                style: textFieldTextStyle(),
                              ),
                            ),
                            ListTile(
                              title: AutoSizeText(
                                getTranslated(
                                        context, "profilePageMandalText") +
                                    "${user.mandal}",
                                style: textFieldTextStyle(),
                              ),
                            ),
                            ListTile(
                              title: AutoSizeText(
                                getTranslated(
                                        context, "profilePageDistrictText") +
                                    "${user.district}",
                                style: textFieldTextStyle(),
                              ),
                            ),
                            ListTile(
                              title: AutoSizeText(
                                getTranslated(
                                        context, "profilePagePincodeText") +
                                    "${user.pincode}",
                                style: textFieldTextStyle(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                          Size(0.5 * _width, 45.0)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.black87),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)))),
                  onPressed: () {
                    _signOut().then((value) => _navigateToNav());
                  },
                  child: Text(
                    getTranslated(context, "profilePageSignoutButtonText"),
                    // 'Sign out',
                    style: TextStyle(fontSize: 20),
                  )),
            ],
          ),
        ],
      ),
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

  Row buildBottomSheetChild(
    String title,
    String helperText,
  ) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 15.0, left: 8.0),
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              controller: TextEditingController(text: title),
              style: textFieldTextStyle(),
              readOnly: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(2.0),
                helperText: helperText,
                helperStyle: helperTextStyle(),
                labelStyle: textFieldTextStyle(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextStyle textFieldTextStyle() {
    return TextStyle(
        fontFamily: 'arial',
        fontSize: 25.0,
        fontWeight: FontWeight.w900,
        color: Colors.black);
  }

  TextStyle helperTextStyle() {
    return TextStyle(
      fontFamily: 'arial',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: primaryColor,
    );
  }

  void _changeLanguge(Language language) async {
    Locale _temp = await setLocale(language.languageCode);

    App.setLocale(context, _temp);

    print(language.name);
  }
}
