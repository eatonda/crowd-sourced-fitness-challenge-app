/* 
  File Name: authentication_service.dart 
  Description: This services class abstracts all authentication services of
    firebase authentication. 
  Citatiation(s):
    1. Pelling, Shaun "Flutter & Firebase App Tutorial #4 - Firebase Auth"
      https://www.youtube.com/watch?v=mZYuuGAIwe4&list=PL4cUxeGkcC9j--TKIdkb3ISfRbJeJYQwC&index=4
      Assisted with overall structure and logic for implementing authentication
      services utilizing firebase. 

    2. Milke, Johannes "Flutter Tutorial - Google SignIn With Firebase"
      https://www.youtube.com/watch?v=ogW83xGQGTg
      Assisted with setup of the google sign in via firebase and with structure
      of lohinWithGoogle function.

    3. Julow, Andy "Facebook login with Firebase and Flutter"
      https://www.youtube.com/watch?v=r0JtCUkSdWQ&t=1845s
      Assisted with setup of facebook sign in via firebase.

    4. "flutter_twitter 1.1.3"
      https://pub.dev/packages/flutter_twitter
      Developer package that assisted with twitter authentication.

    5. "google_sign_in 4.5.9"
      https://pub.dev/packages/google_sign_in
      Developer package that assisted with google authentication

    6. "flutter_login_facebook 0.5.0"
      https://pub.dev/packages/flutter_login_facebook
      Developer package that assisted with facebook authentication

*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_gurus_challenger/models/app_user.dart';
// import 'package:fitness_gurus_challenger/models/twitter_api_credentials.dart';
import 'package:fitness_gurus_challenger/services/api_credentials.dart';
import 'package:fitness_gurus_challenger/services/database_service.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
// import 'package:flutter_twitter/flutter_twitter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/app_user.dart';

class AuthenticationService {
  // Access to api credentials
  final APICredentials _apiCredentials = APICredentials();

  // Access to firebase_auth methods
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Access Google Sign in methods
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Access to Facebook Login Methods
  final _facebookLogin = FacebookLogin();

  // Database service
  final _databaseService = DataBaseService();

  // Creates a AppUser instance from a Firebase User instance.
  AppUser _appUserFromFirebaseUser(User user) {
    if (user != null) {
      return AppUser(uid: user.uid);
    } else {
      return null;
    }
  }

  // Stream of authentication changes for user, mapped to AppUser model.
  // Stream<AppUser> get appUser {
  //   return _auth.authStateChanges().map(_appUserFromFirebaseUser);
  // }

  // Stream for authentication changes such as sign or sign out
  // Stream<User> get user => _auth.authStateChanges();

  Stream<User> get user => _auth.userChanges();

  // login with email and password
  Future loginEmailPassword(String email, String password) async {
    try {
      // Get the user's credential info from the firebase_auth instance.
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _appUserFromFirebaseUser(userCredential.user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future signUpEmailPassword(String email, String password) async {
    try {
      // Get the user's credential info from the firebase_auth instance.
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // _auth.currentUser.reload();

      AppUser user = _appUserFromFirebaseUser(userCredential.user);
      _databaseService.addUserToDatabase(user);

      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // login with google account
  Future loginWithGoogle() async {
    try {
      // Extract Google User credentials
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      // Utilize the extracted credentials to login to firebase.
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Returned info mapped to AppUser model
      AppUser appUser = _appUserFromFirebaseUser(userCredential.user);

      // if a new user
      if (await _databaseService.isNewUser(appUser.uid)) {
        // Get Google info for user
        final names = googleUser.displayName.split(' ');
        appUser.firstName = names[0];
        appUser.lastName = names[1];
        appUser.profileImageUrl = googleUser.photoUrl;

        // Upload user to database
        _databaseService.addUserToDatabase(appUser);
      } else {
        print("Google not new user");
        // Get user info from database
        appUser = await _databaseService.getUserFromFromDatabase(appUser.uid);
      }
      return appUser;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // login with facebook account
  Future loginWithFacebook() async {
    try {
      // Extract Facebook User credentials
      final res = await _facebookLogin.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email
      ]);

      final FacebookAccessToken token = res.accessToken;

      final AuthCredential credential =
          FacebookAuthProvider.credential(token.token);

      // Utilize the extracted credentials to login to firebase.
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Returned info mapped to AppUser model
      AppUser appUser = _appUserFromFirebaseUser(userCredential.user);

      // if a new user
      if (await _databaseService.isNewUser(appUser.uid)) {
        // Get Facebook info for user
        final profile = await _facebookLogin.getUserProfile();

        appUser.firstName = profile.firstName;
        appUser.lastName = profile.lastName;
        appUser.profileImageUrl =
            await _facebookLogin.getProfileImageUrl(width: 1000);

        // Upload user to database
        _databaseService.addUserToDatabase(appUser);
        return appUser;
      } else {
        print("Facebook not new user");
        // Get user info from database
        appUser = await _databaseService.getUserFromFromDatabase(appUser.uid);
      }
      return appUser;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Removed my personal twitter api key thus commented out
  // login with twitter account
  // Future loginWithTwitter() async {
  //   try {
  //     // Get api credentials
  //     final TwitterAPICredentials apiCredentials =
  //         await _apiCredentials.twitterConsumerKey;

  //     // Get instance of twitter login
  //     var twitterLogin = new TwitterLogin(
  //         consumerKey: apiCredentials.consumerKey,
  //         consumerSecret: apiCredentials.consumerSecret);

  //     // Extract Twitter credentials
  //     final TwitterLoginResult result = await twitterLogin.authorize();
  //     var session = result.session;

  //     //print(session.secret);

  //     // Utilize the extracted credentials to login to firebase.
  //     final AuthCredential credential = TwitterAuthProvider.credential(
  //         accessToken: session.token, secret: session.secret);

  //     UserCredential userCredential =
  //         await _auth.signInWithCredential(credential);

  //     // Returned info mapped to AppUser model
  //     AppUser appUser = _appUserFromFirebaseUser(userCredential.user);

  //     // if a new user
  //     if (await _databaseService.isNewUser(appUser.uid)) {
  //       // All of twitter info not supported so save just the username
  //       appUser.firstName = session.username;

  //       // Upload user to database
  //       _databaseService.addUserToDatabase(appUser);
  //       return appUser;
  //     }
  //   } catch (error) {
  //     print(error.toString());
  //     return null;
  //   }
  // }

  // logout
  Future logout() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // delete account
  Future deleteAccount(String uid) async {
    try {
      await _auth.currentUser.delete();
      print('delete');
    } catch (error) {
      print("error deleting account ${error.toString()}");
      return null;
    }
    // Delete user from users collection
    await _databaseService.deleteUserFromUsers(uid);
    // Delete user associated  completedChallenge entries
    await _databaseService.deleteUserCompletedChallenges(uid);
    return true;
  }
}
