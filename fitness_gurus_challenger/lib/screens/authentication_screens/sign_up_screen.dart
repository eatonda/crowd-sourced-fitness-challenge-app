import 'package:fitness_gurus_challenger/components/authentication/email_password_form.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = 'sign_up_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: EmailPasswordForm(
        signUpFlag: true,
      ),
    );
  }
}
