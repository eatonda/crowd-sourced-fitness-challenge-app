import 'package:fitness_gurus_challenger/components/authentication/email_password_form.dart';
import 'package:fitness_gurus_challenger/services/navigation_service.dart';
import 'package:flutter/material.dart';

class EmailPasswordLoginScreen extends StatelessWidget {
  static const routeName = 'EmailPasswordLogin';
  final navigationService = NavigationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Please login')),
      body: EmailPasswordForm(
        signUpFlag: false,
      ),
    );
  }
}
