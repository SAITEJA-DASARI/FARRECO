import 'package:auto_size_text/auto_size_text.dart';
import 'package:farreco/screens/signUp.dart';
import 'package:farreco/services/authService.dart';
import 'package:farreco/widgets/provider.dart';
import 'package:flutter/material.dart';

class UserRegistration extends StatefulWidget {
  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  String _name, _error, phone, village, mandal, district, pincode;
  double landArea;

  final formKey = GlobalKey<FormState>();

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

  void submit() async {
    //when users submits data validate
    //add user data to user collection
    //add soil paramters to soil parameters collection of user
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        final user = await auth.getCurrentUser();
        await auth
            .addUserToFirestore(context, _name, user.phoneNumber, village,
                mandal, district, pincode, landArea)
            //when the user is registered add soil parameters to his collection
            .then((value) async =>
                await auth.setSoilParametersCollection(context))
            .then((value) => Navigator.pushReplacementNamed(context, '/nav'));
      } catch (e) {
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
              AutoSizeText(
                "Let us know more about you..",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                ),
              ),
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

  //function to return list of input fields
  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    // if were in the sign up state add name,address,land fields

    textFields.add(
      TextFormField(
        validator: NameValidator.validate,
        style: TextStyle(fontSize: 22.0),
        decoration: buildSignUpInputDecoration("Name"),
        onSaved: (value) => _name = value,
      ),
    );
    textFields.add(SizedBox(height: 20));
    textFields.add(
      TextFormField(
        validator: EmptyFieldValidator.validate,
        style: TextStyle(fontSize: 22.0),
        decoration: buildSignUpInputDecoration("Village"),
        onSaved: (value) => village = value,
      ),
    );
    textFields.add(SizedBox(height: 20));
    textFields.add(
      TextFormField(
        validator: EmptyFieldValidator.validate,
        style: TextStyle(fontSize: 22.0),
        decoration: buildSignUpInputDecoration("Mandal"),
        onSaved: (value) => mandal = value,
      ),
    );
    textFields.add(SizedBox(height: 20));
    textFields.add(
      TextFormField(
        validator: EmptyFieldValidator.validate,
        style: TextStyle(fontSize: 22.0),
        decoration: buildSignUpInputDecoration("district"),
        onSaved: (value) => district = value,
      ),
    );
    textFields.add(SizedBox(height: 20));
    textFields.add(
      TextFormField(
        validator: PincodeValidator.validate,
        style: TextStyle(fontSize: 22.0),
        decoration: buildSignUpInputDecoration("pincode"),
        onSaved: (value) => pincode = value,
      ),
    );
    textFields.add(SizedBox(height: 20));
    textFields.add(
      TextFormField(
        validator: NumberValidator.validate,
        style: TextStyle(fontSize: 22.0),
        decoration: buildSignUpInputDecoration("agricultural land in acres"),
        onSaved: (value) => landArea = double.parse(value),
      ),
    );
    textFields.add(SizedBox(height: 20));

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
              "Submit",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
          ),
          onPressed: submit,
        ),
      ),
    ];
  }
}
