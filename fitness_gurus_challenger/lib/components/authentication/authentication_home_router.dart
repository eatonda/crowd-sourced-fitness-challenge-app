/* 
  File Name: authentication_home_router.dart 

  Description: This component simply listens for user authentication and routes
    users to either the authentication_screen or the home_screen

  Citatiation(s):
    1. Pelling, Shaun "Flutter & Firebase App Tutorial #4 - Firebase Auth"
      Assisted with overall structure and logic for implementing authentication
      services utilizing firebase. 
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_gurus_challenger/screens/authentication_screens/authentication_options_screen.dart';
import 'package:fitness_gurus_challenger/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/home_screen.dart';

class AuthenticationHomeRouter extends StatefulWidget {
  static const routeName = '/';

  @override
  _AuthenticationHomeRouterState createState() =>
      _AuthenticationHomeRouterState();
}

class _AuthenticationHomeRouterState extends State<AuthenticationHomeRouter> {
  @override
  Widget build(BuildContext context) {
    // For authentication purposes
    final firebaseUser = Provider.of<User>(context);

    // Route to apporiate screen
    if (firebaseUser == null) {
      // print('HomeRouter appUser null');
      return AuthenticationOptionsScreen();
    } else {
      // print('home screen');
      // print(firebaseUser.uid);
      return HomeScreen();
    }
  }
}
