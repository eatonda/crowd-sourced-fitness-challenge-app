import 'package:fitness_gurus_challenger/components/authentication/authentication_options.dart';
import 'package:flutter/material.dart';

class AuthenticationOptionsScreen extends StatelessWidget {
  static const routeName = 'authentication_options';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Challenge, Persevere, Conquer')),
      body: AuthenticationOptions(),
    );
  }
}
