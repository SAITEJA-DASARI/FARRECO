import 'dart:async';
import 'dart:convert';
import 'package:farreco/sample datasets/sample soil parameters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farreco/models/soilParameters.dart';
import 'package:farreco/models/user.dart';
import 'package:farreco/widgets/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:farreco/translation/translationConstants.dart';
import 'package:farreco/models/utils.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final primaryColor = const Color(0xFF1B5E20);
  //listening to onAuthStateChanges
  //return uid of user if a user is signed in or null if a user is not signedin
  //helps whether to show getting started page for users
  Stream<String> get onAuthStateChanged {
    print("in onAuthStateChanged method");
    print(_firebaseAuth.currentUser?.uid);
    return _firebaseAuth.authStateChanges().map(
          (User user) => user?.uid,
        );
  }

  // GET UID
  String getCurrentUID() {
    return _firebaseAuth.currentUser.uid;
  }

  //get user
  Future getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  //get user phone Number
  String getUserPhoneNumber() {
    print(
        "\n \n \n authservice phone number is  ${_firebaseAuth.currentUser.phoneNumber} \n \n");
    return _firebaseAuth.currentUser.phoneNumber;
  }

//get soil parameters
  getSoilParameters(BuildContext context, String uid) async {
    return await Provider.of(context)
        .db
        .collection("users")
        .doc(uid)
        .collection("soil parameters")
        .orderBy('createdTime')
        .get();
  }

  //method to get current soil parameters
  getCurrentSoilParameteres(BuildContext context, String uid) async {
    return await Provider.of(context)
        .db
        .collection("users")
        .doc(uid)
        .collection("soil parameters")
        .orderBy("createdTime", descending: true)
        .limit(1)
        .get();
  }

  // Email & Password Sign Up
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    final currentUser = await _firebaseAuth
        .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
        .then((UserCredential userCredential) => userCredential.user);

    // Update the username
    await currentUser.updateProfile(displayName: name);
    print(currentUser.displayName);
    await currentUser.reload();
    return currentUser.uid;
  }

  // Email & Password Sign In
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((UserCredential userCredential) => userCredential.user.uid);
  }

  //create user or sign in user with phone number
  //if there is any exception while executing this function we just return error so that we can identify
  //there is an error and show a warning that phone number can't be verified
  Future createUserWithPhone(
      String phone, BuildContext context, String route) async {
    //verify phone number is a inbuilt method used for phone verification

    _firebaseAuth.verifyPhoneNumber(
        //takes 5 parameters
        //phone number
        phoneNumber: phone,
        //duration to display the dialogue to enter otp
        timeout: Duration(seconds: 10),
        //if the mobile supports auto verification and
        //the given mobile number is in the phone then code is detected automatically using verificationCompleted
        verificationCompleted: (AuthCredential authCredential) {
          //authCredential consists of the code sent by the firebase
          _firebaseAuth
              .signInWithCredential(authCredential)
              .then((UserCredential result) {
            print("user created or signed in succesfully");
            //pop out the dialogue after submit and navigate to nav page
            Navigator.pop(context);
            Navigator.of(context).pushReplacementNamed(route);
          }).catchError((e) {
            return "error";
          });
        },
        //if the verification is failed then raise the exception
        verificationFailed: (FirebaseAuthException exception) {
          return "error";
        },
        //if the user has to enter the code manually then this function will be executed
        codeSent: (String verificationId, [int forceResendingToken]) {
          //get the code entered by the user
          final _codeController = TextEditingController();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text(getTranslated(context,
                  "otpVerificationDialogueText")), //"Enter Verification Code sent to your phone"
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[TextField(controller: _codeController)],
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text(
                    getTranslated(
                        context, "otpVerificationDialogueSubmitButtonText"),
                    // "submit",
                    style: TextStyle(color: primaryColor),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {
                    //create a credential using verification id and code sent to mobile
                    var _credential = PhoneAuthProvider.credential(
                        verificationId: verificationId,
                        smsCode: _codeController.text.trim());
                    //sign in  with the created credential

                    _firebaseAuth
                        .signInWithCredential(_credential)
                        .then((UserCredential result) {
                      if (result.user != null) {
                        print("user created or signed in succesfully");
                        //pop out the dialogue after submit and navigate to nav page
                        Navigator.pop(context);
                        Navigator.of(context).pushReplacementNamed(route);
                      } else {
                        return "error";
                      }
                    }).catchError((e) {
                      return "error";
                    });
                  },
                )
              ],
            ),
          );
        },
        //if code retrieval time is up then this function will be executed
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
        });
  }

  //adding user to firestore
  //function to add user to firestore
  Future<void> addUserToFirestore(
      BuildContext context,
      String _name,
      String _phone,
      String _village,
      String _mandal,
      String _district,
      String _pincode,
      double _landArea,
      FarmingType farmingType) async {
    final user = await Provider.of(context).auth.getCurrentUser();

    Users user1 = Users(_name, _phone, _village, _mandal, _district, _pincode,
        _landArea, user.uid, farmingType);
    return await Provider.of(context)
        .db
        .collection("users")
        .doc(user.uid)
        .set(user1.toJson());
  }

  //function to add soil parameters collection to the user
  Future<void> setSoilParametersCollection(BuildContext context) async {
    //get current user for storing data in the user personal collection
    final user = await Provider.of(context).auth.getCurrentUser();
    //get sample data from sample data set file
    List<SoilParameters> soilParameters = SampleSoilParameters.getSampleData();
    //create collection refernce to soil parameters
    CollectionReference soilCollection = Provider.of(context)
        .db
        .collection("users")
        .doc(user.uid)
        .collection("soil parameters");
    //create a batch to write multiple documents at a time
    WriteBatch batch = Provider.of(context).db.batch();
    //add each object to seperate document
    for (var i = 0; i < soilParameters.length; i++) {
      batch.set(soilCollection.doc(), soilParameters[i].toJson());
    }
    //commit batch
    await batch.commit();
  }

  //check if the user is existing or not
  Future<String> isExistingUser(BuildContext context, String phone) async {
    Navigator.of(context).pushNamed('/loading');
    bool flag = false;
    await Provider.of(context)
        .db
        .collection('users')
        .get()
        .then((querySnapshot) async {
      querySnapshot.docs.forEach((doc) {
        print(doc['phoneNumber']);
        if (doc['phoneNumber'] == phone) {
          flag = true;
        }
      });
    });
    Navigator.pop(context);
    if (flag == true) {
      return "existing";
    } else {
      return "no";
    }
  }

  // Sign Out
  signOut() {
    return _firebaseAuth.signOut();
  }
}

//these validators are shown just below the textfield unlike the warning message shown
//name validator
class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Name can't be empty";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if (value.length > 50) {
      return "Name must be less than 50 characters long";
    }
    return null;
  }
}

//pincode validator
class PincodeValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "pincode can't be empty";
    }
    if (value.length < 6 || value.length > 6) {
      return "pincode should be 6 digits";
    }
    return null;
  }
}

//checks if entered text is a number or not
class NumberValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "this field can't be empty";
    }
    final number = num.tryParse(value);
    if (number == null) {
      return "please enter a valid number";
    }
    return null;
  }
}

//checks if a field is empty or not
class EmptyFieldValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "this field can't be empty";
    }
    return null;
  }
}

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Email can't be empty";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    }
    return null;
  }
}
