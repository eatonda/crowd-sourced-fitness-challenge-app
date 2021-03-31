import 'package:email_validator/email_validator.dart';
import 'package:fitness_gurus_challenger/components/customButton.dart';
import 'package:fitness_gurus_challenger/services/authentication_service.dart';
import 'package:fitness_gurus_challenger/services/navigation_service.dart';
import 'package:flutter/material.dart';

import '../Colors.dart';

class EmailPasswordForm extends StatefulWidget {
  final bool signUpFlag;

  EmailPasswordForm({@required this.signUpFlag});

  @override
  _EmailPasswordFormState createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final authenticationService = AuthenticationService();
  final navigationService = NavigationService();
  String _email = "";
  String _password = "";
  dynamic _result;
  String error = "";

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final widths = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              Container(
                child: CircleAvatar(
                  backgroundColor: basicCOlor,
                  radius: 40.0,
                  backgroundImage: NetworkImage(
                      'https://cdn.pixabay.com/photo/2017/11/10/04/47/user-2935373_960_720.png'),
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),

              // Email Form Field
              Container(
                width: widths / 1.2,
                child: TextFormField(
                  style: TextStyle(color: Colors.black),
                  autofocus: true,
                  decoration: new InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(8.0),
                        ),
                        borderSide: BorderSide(color: Color(0xffF3F3F3))),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(color: Color(0xffF3F3F3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(color: Color(0xffF3F3F3)),
                    ),
                    filled: true,
                    hintStyle: new TextStyle(
                        color: Colors.grey[800].withOpacity(0.5), fontSize: 14),
                    hintText: "enter email address",
                    fillColor: Color(0xffEFEFF4),
                  ),
                  onSaved: (value) {
                    // Store value on valid input when form is submitted.
                    _email = value.trimRight();
                  },
                  validator: (value) {
                    // Validate input.
                    if (value.isEmpty) {
                      return 'Email cannot be empty!';
                    } else if (!EmailValidator.validate(value.trimRight())) {
                      return 'Must be a valid email address!';
                    } else {
                      // Valid data return null
                      return null;
                    }
                  },
                ),
              ),

              // Spacing
              SizedBox(
                height: MediaQuery.of(context).size.width * .1,
              ),

              // Password Form Field
              Container(
                width: widths / 1.2,
                child: TextFormField(
                  style: TextStyle(color: Colors.black),
                  autofocus: true,
                  decoration: new InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(8.0),
                        ),
                        borderSide: BorderSide(color: Color(0xffF3F3F3))),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(color: Color(0xffF3F3F3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(color: Color(0xffF3F3F3)),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: basicCOlor,
                      ),
                      iconSize: 18,
                      onPressed: _toggle,
                    ),
                    filled: true,
                    hintStyle: new TextStyle(
                        color: Colors.grey[800].withOpacity(0.5), fontSize: 14),
                    hintText: "enter password",
                    fillColor: Color(0xffEFEFF4),
                  ),
                  obscureText: _obscureText,
                  onSaved: (value) {
                    // Store value on valid input when form is submitted.
                    _password = value;
                  },
                  validator: (value) {
                    // Validate input.
                    if (value.isEmpty) {
                      return 'Password cannot be empty!';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    } else {
                      // Valid data return null
                      return null;
                    }
                  },
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.width * .1,
              ),
              Container(
                  width: widths / 1.2,
                  child: CustomerButton(
                    text: Text("Login"),
                    onPressed: () async {
                      // Save Valid Submissions.
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        if (widget.signUpFlag) {
                          // Create new account
                          _result = await authenticationService
                              .signUpEmailPassword(_email, _password);

                          if (_result == null) {
                            print('Error occurred with account registeration');
                            setState(() {
                              error =
                                  "Oops! Looks like that email is already in use!\nPlease try another one.";
                            });
                          }
                        } else {
                          // Login

                          _result = await authenticationService
                              .loginEmailPassword(_email, _password);

                          if (_result == null) {
                            print('Error occurred with account login');
                            // Show error to user
                            setState(() {
                              error = 'Invalid email and password';
                            });
                          }
                        }
                        if (_result != null)
                          // Go back to authentication/home router
                          navigationService.navigateBack(context);
                        //navigationService.navigateToHomeScreen(context);
                      }
                    },
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              Text(
                error,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
