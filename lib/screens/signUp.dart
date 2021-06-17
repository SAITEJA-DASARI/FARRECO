//signup and signin are same in same page and we switch between signup and signin using state
import 'package:farreco/models/user.dart';
import 'package:farreco/services/authService.dart';
import 'package:farreco/widgets/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:farreco/translation/translationConstants.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:international_phone_input/international_phone_input.dart';

// TODO move this to tone location
final primaryColor = const Color(0xFF1B5E20);

//to choose sign in or signup define a enum
enum AuthFormType { signIn, signUp }

//this page recieves authform type as argument from getstarted page
class SignUpView extends StatefulWidget {
  final AuthFormType authFormType;

  SignUpView({Key key, @required this.authFormType}) : super(key: key);

  //send authFormType to _signUpViewState
  @override
  _SignUpViewState createState() =>
      _SignUpViewState(authFormType: this.authFormType);
}

class _SignUpViewState extends State<SignUpView> {
  AuthFormType authFormType;
  final primaryColor = const Color(0xFF1B5E20);

  _SignUpViewState({this.authFormType});

  //create a form key to access form elements
  final formKey = GlobalKey<FormState>();
  String _email,
      _password,
      _name,
      _error,
      phone,
      village,
      mandal,
      district,
      pincode,
      landArea,
      _navRoute = "/nav",
      _userRegistrationRoute = '/register';

  //method to switch between signUp and signIn views
  void switchFormState(String state) {
    //reset the form before switching
    formKey.currentState.reset();

    //set state
    if (state == "signUp") {
      setState(() {
        authFormType = AuthFormType.signUp;
        _error = null;
      });
    } else {
      setState(() {
        authFormType = AuthFormType.signIn;
        _error = null;
      });
    }
  }

  //methodToValidateForm
  bool validate() {
    //get current state of the form
    final form = formKey.currentState;
    //save the form before submitting
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  //method to submit form
  void submit() async {
    if (validate()) {
      try {
        print("in submit");
        print("context: ${context.toString()}");
        final auth = Provider.of(context).auth;

        //for signin
        if (authFormType == AuthFormType.signIn) {
          if (await auth.isExistingUser(context, phone) == "existing") {
            var result =
                await auth.createUserWithPhone(phone, context, _navRoute);
            if (phone == "" || result == "error") {
              setState(() {
                _error = getTranslated(context,
                    "signUpPagePhoneNotValidatedText"); //"Your phone number could not be validated";
              });
            }
          } else {
            setState(() {
              _error = getTranslated(context,
                  "signInPageUserNotFoundText"); //"Requested user not found. Please sign up to continue..";
            });
          }
        } else {
          //for signup
          if (await auth.isExistingUser(context, phone) == "existing") {
            setState(() {
              _error = getTranslated(context,
                  "signUpPageUserExistingText"); //"This phone number is already in use. please sign in to continue";
            });
          } else {
            var result = await auth.createUserWithPhone(
                phone, context, _userRegistrationRoute);
            if (phone == "" || result == "error") {
              setState(() {
                _error = getTranslated(context,
                    "signUpPagePhoneNotValidatedText"); //"Your phone number could not be validated";
              });
            }
          }
        }
      } catch (e) {
        //if there is any exception in form submission then exception message is set to _error
        //by modifying the state
        print("exception in form submit");
        print(e);
        setState(() {
          _error = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        color: primaryColor,
        height: _height,
        width: _width,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(height: _height * 0.025),
              //if there is any error then we set the state with error message assigned to error
              //if there is no error no alert is shown
              showAlert(),
              SizedBox(height: _height * 0.025),
              //header text is build here
              buildHeaderText(),
              SizedBox(height: _height * 0.05),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: buildInputs() + buildButtons(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  //if there is any errors while submitting the form an alert message is shown to users
  Widget showAlert() {
    if (_error != null) {
      return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            color: Colors.amberAccent,
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.error_outline),
                ),
                Expanded(
                  child: AutoSizeText(
                    _error,
                    maxLines: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      //when dismissed icon is pressed state should be modified by setting _error to null
                      setState(() {
                        _error = null;
                      });
                    },
                  ),
                )
              ],
            ),
          ));
    }
    return SizedBox(
      height: 0,
    );
  }

  //function to build header text
  AutoSizeText buildHeaderText() {
    String _headerText;
    if (authFormType == AuthFormType.signUp) {
      _headerText = getTranslated(context, "signUpPageCreateAccountText");
      // _headerText = "Create New Account";
    } else {
      _headerText = getTranslated(context, "signInPageSignInButtonText");
      // _headerText = "Sign In";
    }
    return AutoSizeText(
      _headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 35,
        color: Colors.white,
      ),
    );
  }

  //function that runs on phone number change in the phone number field
  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phone = internationalizedPhoneNumber;
    });
  }

  //function to return list of input fields
  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    //phone number
    textFields.add(
      InternationalPhoneInput(
          decoration: buildSignUpInputDecoration(
              getTranslated(context, "signUpPagePhoneNumberPlaceHolderText")),
          onPhoneNumberChange: onPhoneNumberChange,
          initialPhoneNumber: phone,
          initialSelection: '+91',
          showCountryCodes: true),
    );

    textFields.add(SizedBox(height: 20));

    return textFields;
  }

  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 0.0)),
      contentPadding:
          const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
    );
  }

  //function to build buttons
  List<Widget> buildButtons() {
    String _switchButtonText, _newFormState, _submitButtonText;

    if (authFormType == AuthFormType.signIn) {
      _switchButtonText = getTranslated(
          context, "signUpPageCreateAccountText"); //"Create New Account"
      _newFormState = "signUp";
      _submitButtonText =
          getTranslated(context, "signInPageSignInButtonText"); //"Sign In";
    } else {
      _switchButtonText = getTranslated(
          context, "signUpPageSignInButtonText"); //"Have an Account? Sign In";
      _newFormState = "signIn";
      _submitButtonText =
          getTranslated(context, "signUpPageSignUpButtonText"); //"Continue";
    }

    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _submitButtonText,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
          ),
          onPressed: submit,
        ),
      ),
      TextButton(
        child: Text(
          _switchButtonText,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          switchFormState(_newFormState);
        },
      )
    ];
  }
}
