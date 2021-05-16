import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farreco/screens/signUp.dart';
import 'package:farreco/widgets/provider.dart';
import 'package:flutter/material.dart';

import '../style.dart';

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
                tabs: [Tab(text: "People"), Tab(text: "Following")],
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
      future: getListOfUsers(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            // <3> Retrieve `List<DocumentSnapshot>` from snapshot
            return displayUsersList(context, snapshot, uid, following);
          } else {
            return Text('there is an Error!');
          }
        } else {
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Please wait...",
              style: TextStyle(color: primaryColor, fontSize: 20),
            ),
            SizedBox(
              height: 20.0,
            ),
            CircularProgressIndicator()
          ]);
        }
      },
    );
  }

  displayUsersList(context, snapshot, uid, following) {
    //store all the user documents in a list
    //iterate over the list
    final List<DocumentSnapshot> documents = snapshot.data.docs;

    //return a listview builder widget
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: documents.length,
            itemBuilder: (context, index) {
              //check if the user is in following list or not and assign label
              bool isSaved =
                  following.contains(documents[index]['phoneNumber']);

              return Card(
                child: ListTile(
                  title: AutoSizeText(
                    documents[index]['name'],
                    style: ListTileTitleTextStyle,
                  ),
                  subtitle: AutoSizeText(
                    "phone: ${documents[index]['phoneNumber'].substring(3)}",
                    style: ListTileSubTitleTextStyle,
                  ),
                  trailing: buildFollowButton(
                      context, documents[index], uid, isSaved),
                ),
              );
            }),
      ],
    );
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
                      "following ${following.length} people",
                      style: TextStyle(
                        color: primaryColor,
                        fontFamily: 'arial',
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                  ),
                  displayUsersList(context, snapshot, uid, following)
                ]);
          } else {
            return Text('there is an Error!');
          }
        } else {
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Please wait...",
              style: TextStyle(color: primaryColor, fontSize: 20),
            ),
            SizedBox(
              height: 20.0,
            ),
            CircularProgressIndicator()
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
        child: isSaved ? Text("unfollow") : Text("follow"),
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
                "uid": document['uid']
              });
            }
          });
        });
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
        .get();
  }

//returns list of users except current user to display under people tab
  getListOfUsers(context) async {
    final currentUserPhoneNumber =
        Provider.of(context).auth.getUserPhoneNumber();
    //fetch all users except current user
    return await Provider.of(context)
        .db
        .collection("users")
        .where('phoneNumber', isNotEqualTo: currentUserPhoneNumber)
        .get();
  }
}
