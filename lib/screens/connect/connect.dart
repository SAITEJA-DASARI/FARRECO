import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farreco/models/soilParameters.dart';
import 'package:farreco/screens/profile.dart';
import 'package:farreco/screens/signUp.dart';
import 'package:farreco/models/utils.dart';
import 'package:farreco/screens/connect/connectionDetail.dart';
import 'package:farreco/translation/translationConstants.dart';
import 'package:farreco/screens/sqi.dart';
import 'package:farreco/widgets/provider.dart';
import 'package:farreco/widgets/sqiGraph.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

import '../../style.dart';

class Connect extends StatefulWidget {
  static List users;

  @override
  _ConnectState createState() => _ConnectState();
}

//create two tabs people to follow and a tab for people who you follow
class _ConnectState extends State<Connect> with SingleTickerProviderStateMixin {
  //tab controller to control tab switching
  TabController tabController;
  var uid;

  List<String> filters = [
    FarmingType.in_organic.toString(),
    FarmingType.semi_organic.toString(),
    FarmingType.organic.toString()
  ];
  List<int> _selectedButtons = [0, 1, 2];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    //uid is passed to every other method to track current user easily
    uid = Provider.of(context).auth.getCurrentUID();

    //following is a list of phone numbers of the following users
    var following = getFollowingListPhoneNumbers(context, uid);

    //using scaffold to build tab bar
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.0,
        flexibleSpace: SafeArea(
          //default tab controller to control tabs
          child: DefaultTabController(
            length: 2,
            //container is used to customize the tab color. cannot find other way of customizing color
            child: Container(
              color: Colors.white,
              child: TabBar(
                //mention tab controller name same in tabBar and TabView
                controller: tabController,
                tabs: [
                  Tab(
                    text: getTranslated(
                        context, "connectPageTabBarPeopleTabText"),
                    // "People"
                  ),
                  Tab(
                    text: getTranslated(
                        context, "connectPageTabBarFollowingTabText"),
                    // "Following"
                  )
                ],
                labelStyle: TextStyle(
                  fontFamily: 'arial',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                labelColor: primaryColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: primaryColor,
                indicatorWeight: 4.0,
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
          //observe same tab controller name
          controller: tabController,
          //body of the tabs
          children: [
            //function that builds people
            buildPeople(context, uid, following),
            //function that builds following
            buildFollowing(context, following, uid),
          ]),
    );
  }

//get all the users in the users collection in db
//show the users using a future builder
//isSaved is a boolean variable to check if the user is in the following list or not
//follow and unfollow are displayed based on isSaved variable
//every time a follow or unfollow is clicked update following collection in db in setState() method which automatically updates following list
  FutureBuilder buildPeople(BuildContext context, String uid, following) {
    //using future builder to load all the users in to the app
    return FutureBuilder(
      future: getListOfUsers(context, filters),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            // <3> Retrieve `List<DocumentSnapshot>` from snapshot
            return displayUsersList(context, snapshot, uid, following);
          } else {
            return Text(
              getTranslated(context, "loadingSomethingWentWrongText"),
              // 'there is an Error!'
            );
          }
        } else {
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
          ]);
        }
      },
    );
  }

  Future buildFilterDialogue(BuildContext context) {
    List<String> groupButtons = [
      getTranslated(context, FarmingType.in_organic.toString()),
      getTranslated(context, FarmingType.semi_organic.toString()),
      getTranslated(context, FarmingType.organic.toString()),
    ];
    List<String> _groupButtons = [
      FarmingType.in_organic.toString(),
      FarmingType.semi_organic.toString(),
      FarmingType.organic.toString()
    ];

    return showDialog(
        barrierDismissible: false,
        context: context,
        barrierLabel: "filter",
        builder: (BuildContext context) {
          return Scaffold(
              backgroundColor: Colors.black54,
              body: Container(
                  color: Colors.transparent,
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ]),
                    SizedBox(
                      height: 30,
                    ),
                    GroupButton(
                        borderRadius: BorderRadius.circular(10),
                        selectedButtons: _selectedButtons,
                        spacing: 10.0,
                        isRadio: false,
                        buttons: groupButtons,
                        onSelected: (index, _isSelected) {
                          if (_isSelected &&
                              !filters.contains(_groupButtons[index])) {
                            setState(() {
                              filters.add(_groupButtons[index]);

                              _selectedButtons.add(index);
                            });
                          } else if (!_isSelected &&
                              filters.contains(_groupButtons[index])) {
                            setState(() {
                              filters.remove(_groupButtons[index]);
                              _selectedButtons.remove(index);
                              if (filters.isEmpty) {
                                filters.addAll(_groupButtons);
                                _selectedButtons = [0, 1, 2];
                              }
                            });
                          }
                        }),
                    Center(
                        child: ElevatedButton(
                      child: Text(getTranslated(context, "ok")),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
                  ])));
        });
  }

  displayUsersList(context, snapshot, uid, following) {
    //store all the user documents in a list
    //iterate over the list
    final List<DocumentSnapshot> documents = snapshot.data.docs;

    //return a listview builder widget
    return Material(
        child: Container(
            child: Column(children: [
      ListTile(
        title: Center(
          child: Text(
            getTranslated(context, "connectionPageFilterButtonText"),
            // 'filter',
            style: ListTileSubTitleTextStyle,
          ),
        ),
        trailing: Icon(
          Icons.filter_list,
          color: Colors.black,
        ),
        onTap: () {
          buildFilterDialogue(context);
        },
      ),
      Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: documents.length,
              itemBuilder: (context, index) {
                //check if the user is in following list or not and assign label
                bool isSaved =
                    following.contains(documents[index]['phoneNumber']);

                return Column(
                  children: [
                    Card(
                      color: Colors.white70,
                      shadowColor: Colors.black87,
                      child: ListTile(
                        title: AutoSizeText(
                          documents[index]['name'],
                          style: ListTileTitleTextStyle,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              getTranslated(context, "connectPagePhoneText") +
                                  "${documents[index]['phoneNumber'].substring(3)}",
                              style: ListTileSubTitleTextStyle,
                            ),
                            buildUserSQI(context, uid),
                            Padding(
                              padding: EdgeInsets.all(0.0),
                              child: AutoSizeText(
                                getFarmingTypeText(documents[index]) +
                                    getTranslated(
                                        context, "connectPageAgricultureText"),
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            )
                          ],
                        ),
                        trailing: buildFollowButton(
                            context, documents[index], uid, isSaved),
                        onTap: () {
                          print(
                              "uid of the selected user is ==== ${documents[index]['name']}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ConnectionDetail(
                                          uid: documents[index]['uid'],
                                          name: documents[index]['name'])));
                        },
                        enabled: true,
                      ),
                    ),
                  ],
                );
              }))
    ])));
  }

  //method to get farming type text
  String getFarmingTypeText(doc) {
    if (doc['farmingType'] == FarmingType.in_organic.toString()) {
      return getTranslated(context, "FarmingType.in_organic");
    } else if (doc['farmingType'] == FarmingType.semi_organic.toString()) {
      return getTranslated(context, "FarmingType.semi_organic");
    } else {
      return getTranslated(context, "FarmingType.organic");
    }
  }

  //buildfollowing is same as buildPeople except its future is getting list of following users
  buildFollowing(BuildContext context, following, uid) {
    return FutureBuilder(
      future: getFollowingList(context, uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            // <3> Retrieve `List<DocumentSnapshot>` from snapshot
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        //show number of people the user is following
                        child: Text(
                      getTranslated(
                              context, "connectPageTabBarFollowingTabText") +
                          " ${following.length} " +
                          getTranslated(
                              context, "connectPageTabBarPeopleTabText"),
                      style: TextStyle(
                        color: primaryColor,
                        fontFamily: 'arial',
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                  ),
                  Expanded(
                      child:
                          displayUsersList(context, snapshot, uid, following)),
                ]);
          } else {
            return Text(
              getTranslated(context, "loadingSomethingWentWrongText"),
              // 'Something went wrong!'
            );
          }
        } else {
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
          ]);
        }
      },
    );
  }

  //build follow button assigns follow or unfollow label to the list tile
  //everytime the button is clicked either user is added to the db or removed from the db
  buildFollowButton(BuildContext context, DocumentSnapshot document, String uid,
      bool isSaved) {
    return ElevatedButton(
        child: isSaved
            ? Text(
                getTranslated(context, "connectPageUnfollowButtonText"),
                // "unfollow"
              )
            : Text(
                getTranslated(context, "connectPageFollowButtonText"),
                // "follow"
              ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(primaryColor)),
        onPressed: () {
          setState(() {
            if (isSaved) {
              //removing user from following collection
              Provider.of(context)
                  .db
                  .collection("users")
                  .doc(uid)
                  .collection("following")
                  .doc(document['phoneNumber'])
                  .delete();
            } else {
              //setting user into following collection in db
              //phone number is used as doc name to easily remove the document
              Provider.of(context)
                  .db
                  .collection("users")
                  .doc(uid)
                  .collection("following")
                  .doc(document['phoneNumber'])
                  .set({
                "phoneNumber": document['phoneNumber'],
                "name": document['name'],
                "uid": document['uid'],
                "farmingType": document['farmingType'],
              });
            }
          });
        });
  }

  //
  buildUserSQI(BuildContext context, uid) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, bottom: 8.0, right: 8.0),
      child: FutureBuilder(
        future:
            Provider.of(context).auth.getCurrentSoilParameteres(context, uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // <3> Retrieve `List<DocumentSnapshot>` from snapshot
              final List<DocumentSnapshot> documents = snapshot.data.docs;
              SoilParameters soilParameters =
                  Utils().setSoilParameters(documents[0]);
              return AutoSizeText(
                getTranslated(context, "connectPageSQIText") +
                    "${soilParameters.getSQI().toString()}",
                style: ListTileSubTitleTextStyle,
              );
            } else {
              return Text(
                  getTranslated(context, "connectPageSQIUnavailableText")
                  // 'SQI: unavailable'
                  );
            }
          } else {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  )
                ]);
          }
        },
      ),
    );
  }

  //this method returns list of phone numbers of the users
  //it is used for following list not as future of buildFollowing method
  getFollowingListPhoneNumbers(context, uid) {
    List<String> following = [];
    Provider.of(context)
        .db
        .collection("users")
        .doc(uid)
        .collection("following")
        .get()
        .then((querySnapshot) async {
      querySnapshot.docs.forEach((doc) {
        following.add(doc['phoneNumber']);
      });
    });
    return following;
  }

  //this method returns Future<QuerSnapshots> of following list
  //this is used as future in buildFollowing method
  getFollowingList(context, uid) async {
    return await Provider.of(context)
        .db
        .collection("users")
        .doc(uid)
        .collection("following")
        .where('farmingType', whereIn: filters)
        .get();
  }

  //returns list of users except current user to display under people tab
  getListOfUsers(context, List<String> filters) async {
    final currentUserPhoneNumber =
        Provider.of(context).auth.getUserPhoneNumber();
    //fetch all users except current user
    return await Provider.of(context)
        .db
        .collection("users")
        .where('phoneNumber', isNotEqualTo: currentUserPhoneNumber)
        .where('farmingType', whereIn: filters)
        .get();
  }

  _navigateToSQIDetail(BuildContext context, String uid) {
    Future.delayed(Duration.zero, () {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => Profile()));
      Navigator.pushNamed(context, '/profile');
    });
  }
}
