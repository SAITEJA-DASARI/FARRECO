import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:farreco/models/user.dart';
import 'package:farreco/screens/signUp.dart';
import 'package:farreco/screens/sqi.dart';
import 'package:farreco/style.dart';
import 'package:farreco/widgets/provider.dart';
import 'package:flutter/material.dart';
import 'package:farreco/widgets/buttons.dart';
import 'package:farreco/translation/translationConstants.dart';
import 'package:farreco/models/utils.dart';

class ConnectionDetail extends StatefulWidget {
  final String uid, name;
  ConnectionDetail({Key key, this.uid, this.name}) : super(key: key);
  @override
  _ConnectionDetailState createState() => _ConnectionDetailState(uid, name);
}

class _ConnectionDetailState extends State<ConnectionDetail> {
  final String uid, name;
  //create a user object with default values
  Users user = Users("", "", "", "", "", "", 0.0, "", FarmingType.in_organic);
  _ConnectionDetailState(this.uid, this.name);
  //display name, contact button and sqi details of the selected user in connection detail page
  //contact should open a bottom sheet consisting of users details
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    //build a future builder which returns a progress indicator while waiting for the user details
    //after getting user details build sqi for the user by calling the SQI() object
    return FutureBuilder(
        //returns user info
        future: _getUserInfo(context, widget.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //buildUserDetails builds the connection detail page
            return buildUserDetails(context, uid, name, _height, _width);
          } else {
            //return progress indicator indicating loading of data
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getTranslated(context, "loadingPleaseWaitText"),
                      // "Please wait...",
                      style: TextStyle(color: primaryColor, fontSize: 20),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    )
                  ]),
            );
          }
        });
  }

  buildUserDetails(BuildContext context, String uid, String name,
      double _height, double _width) {
    //return a scaffold
    return Scaffold(
      //create a app bar with username as its title and back button
      appBar: AppBar(
        title: AutoSizeText(name,
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontWeight: FontWeight.w500,
              fontSize: LargeTextSize,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        //customBackButton is defined in buttons.dart file
        leading: CustomBackButton(
          color: Colors.black,
        ),
        leadingWidth: 0.20 * _width,
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      //use column to display contact tile and sqi details

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            color: Colors.black12,
            child: ListTile(
              title: Center(
                child: Text(
                  getTranslated(
                      context, "connectionDetailPageContactButtonText"),
                  // 'contact',
                  style: ListTileTitleTextStyle,
                ),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
                size: 40,
              ),
              onTap: () {
                _showUserPersonalInfo(
                  context,
                  uid,
                );
              },
            ),
          ),
          //sqi is infinite screen display so we cannot use it directly with column
          //so we wrap it in expanded which enables us to scroll down the sqi details of the user
          //we cannot have another widget below expanded as sqi is infinite screen widget
          Expanded(
            child: ListTile(
              title: SQI(
                uid: uid,
              ),
            ),
          )
        ],
      ),
    );
  }

//user details are shown in a modal which covers entire screen because if we navigate to home with 2 routes added to connection then only 1 route is popped
//2nd route is shown on the selected nav item
  void _showUserPersonalInfo(BuildContext context, String uid) {
    final _height = MediaQuery.of(context).size.height;
    //bottom sheet of height 70%
    showModalBottomSheet(
        backgroundColor: Colors.deepPurple[100],
        useRootNavigator: true, //displays modal at root path
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return buildBottomSheetChildren(_height, context);
        });
  }

  _getUserInfo(BuildContext context, String uid) async {
    return await Provider.of(context)
        .db
        .collection("users")
        .doc(uid)
        .get()
        .then(
            //change user object details with the fetched values
            (result) {
      user.name = result['name'];
      user.phoneNumber = result['phoneNumber'];
      user.uid = result['uid'];
      user.village = result['address']['village'];
      user.mandal = result['address']['mandal'];
      user.district = result['address']['district'];
      user.pincode = result['address']['pincode'];
      user.landArea = result['landArea'];
    });
  }

  Container buildBottomSheetChildren(double _height, BuildContext context) {
    return Container(
      height: 0.7 * _height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Center(
                    child: Text(
                  getTranslated(context, "connectionDetailPageUserInfoText"),
                  // 'User info',
                  style: ListTileTitleTextStyle,
                )),
                Spacer(),
                IconButton(
                    icon: Icon(
                      Icons.cancel_sharp,
                      size: 34.0,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            ),
            buildBottomSheetChild(
              user.name,
              getTranslated(context, "connectionDetailPagenameText"),
              // "name"
            ),
            buildBottomSheetChild(
              user.phoneNumber.substring(3),
              getTranslated(context, "connectionDetailPagePhoneText"),
              // "phone number"
            ),
            buildBottomSheetChild(
              "${user.landArea} " +
                  getTranslated(context, "connectionDetailPageLandUnits"),
              getTranslated(context, "connectionDetailPageLandText"),
              //  "Agricultural land"
            ),
            buildBottomSheetChild(
              getTranslated(context, "${user.farmingType}"),
              getTranslated(context, "FarmingTypeText"),
              //  "Agricultural land"
            ),
            buildBottomSheetChild(
              user.village,
              getTranslated(context, "connectionDetailPageVillageText"),
              // "village"
            ),
            buildBottomSheetChild(
              user.mandal,
              getTranslated(context, "connectionDetailPageMandalText"),
              // "mandal"
            ),
            buildBottomSheetChild(
              user.district,
              getTranslated(context, "connectionDetailPageDistrictText"),
              // "district"
            ),
            buildBottomSheetChild(
              user.pincode,
              getTranslated(context, "connectionDetailPagePincodeText"),
              //  "pincode"
            ),
          ],
        ),
      ),
    );
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
}
