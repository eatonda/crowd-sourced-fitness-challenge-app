/*
  File Name: authentication_optioms.dart 
  Description: This is the list of authentication options that a user has.
    By selecting a button the user is routed to the appropriate form to login.
*/
import 'package:fitness_gurus_challenger/components/general/my_title.dart';
import 'package:fitness_gurus_challenger/services/authentication_service.dart';
import 'package:fitness_gurus_challenger/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class AuthenticationOptions extends StatelessWidget {
  final _navigationService = NavigationService();
  final AuthenticationService _authenticationService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyTitle(title: 'Please Select a Login Method'),
          // Spacing
          SizedBox(
            height: MediaQuery.of(context).size.width * .1,
          ),

          // Email and Password
          SignInButtonBuilder(
            icon: Icons.email,
            onPressed: () {
              _navigationService.navigateToEmailPasswordLoginScreen(context);
            },
            text: 'Login with Email',
            backgroundColor: Colors.blueGrey,
          ),

          // Google Login
          SignInButton(Buttons.Google, text: 'Login with Google',
              onPressed: () {
            _authenticationService.loginWithGoogle();
          }),

          // Facebook Login
          SignInButton(Buttons.Facebook, text: 'Login with Facebook',
              onPressed: () {
            _authenticationService.loginWithFacebook();
          }),

          // Twitter Login
          // SignInButton(Buttons.Twitter, text: 'Login with Twitter',
          //     onPressed: () {
          //   _authenticationService.loginWithTwitter();
          // }),

          // Sign Up
          SignInButtonBuilder(
            icon: Icons.app_registration,
            onPressed: () {
              _navigationService.navigateToSignUpScreen(context);
            },
            text: 'Sign Up with Email',
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
