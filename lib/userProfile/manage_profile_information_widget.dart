import 'package:expiree_app/userProfile/locator.dart';
import 'package:expiree_app/userProfile/user_model.dart';
import 'package:expiree_app/userProfile/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageProfileInformationWidget extends StatefulWidget {
  final UserModel currentUser;

  ManageProfileInformationWidget({this.currentUser});

  @override
  _ManageProfileInformationWidgetState createState() =>
      _ManageProfileInformationWidgetState();
}

class _ManageProfileInformationWidgetState
    extends State<ManageProfileInformationWidget> {
  var _displayNameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _newPasswordController = TextEditingController();
  var _repeatPasswordController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  bool checkCurrentPasswordValid = true;

  @override
  void initState() {
    _displayNameController.text = widget.currentUser.displayName;
    super.initState();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Username:',
              textAlign: TextAlign.left,
              style: GoogleFonts.roboto(fontSize: 20, color: Colors.black),
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "Username"),
              controller: _displayNameController,
            ),
            SizedBox(height: 20.0),
            Flexible(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Text(
                      "Manage Password",
                      style: Theme.of(context).textTheme.display1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Current Password:',
                      textAlign: TextAlign.start,
                      style:
                          GoogleFonts.roboto(fontSize: 20, color: Colors.black),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Password",
                        errorText: checkCurrentPasswordValid
                            ? null
                            : "Please double check your current password",
                      ),
                      controller: _passwordController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'New Password:',
                      textAlign: TextAlign.left,
                      style:
                          GoogleFonts.roboto(fontSize: 20, color: Colors.black),
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: "New Password"),
                      controller: _newPasswordController,
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Confirm Password:',
                      textAlign: TextAlign.left,
                      style:
                          GoogleFonts.roboto(fontSize: 20, color: Colors.black),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                      ),
                      obscureText: true,
                      controller: _repeatPasswordController,
                      validator: (value) {
                        return _newPasswordController.text == value
                            ? null
                            : "Please validate your entered password";
                      },
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            RaisedButton(
              onPressed: () async {
                var userController = locator.get<UserController>();

                if (widget.currentUser.displayName !=
                    _displayNameController.text) {
                  var displayName = _displayNameController.text;
                  userController.updateDisplayName(displayName);
                }

                checkCurrentPasswordValid = await userController
                    .validateCurrentPassword(_passwordController.text);

                setState(() {});

                if (_formKey.currentState.validate() &&
                    checkCurrentPasswordValid) {
                  userController
                      .updateUserPassword(_newPasswordController.text);
                  Navigator.pop(context);
                }
              },
              child: Text("Save Profile"),
            )
          ],
        ),
      ),
    );
  }
}
