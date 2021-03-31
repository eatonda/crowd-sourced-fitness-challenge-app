/*
  File Name: navigation_service.dart 
  Description: This service abstracts named route navigation. 
*/

// import 'dart:js';
import 'package:fitness_gurus_challenger/components/authentication/authentication_home_router.dart';
import 'package:fitness_gurus_challenger/models/goal_detail_arg.dart';
import 'package:fitness_gurus_challenger/models/hall_arg.dart';
import 'package:fitness_gurus_challenger/screens/authentication_screens/authentication_options_screen.dart';
import 'package:fitness_gurus_challenger/screens/authentication_screens/email_password_login_screen.dart';
import 'package:fitness_gurus_challenger/screens/authentication_screens/sign_up_screen.dart';
import 'package:fitness_gurus_challenger/screens/challenge_screens/create_challenge_screens/challenge_goal_list_screen.dart';
import 'package:fitness_gurus_challenger/screens/chat_screen.dart';
import 'package:fitness_gurus_challenger/screens/fitness_tracker.dart';
import 'package:fitness_gurus_challenger/screens/safe_screen.dart';
import 'package:fitness_gurus_challenger/screens/update_user_screen.dart';
import 'package:fitness_gurus_challenger/screens/user_profile_screen.dart';

import '../models/app_user.dart';
import '../screens/challenge_screens/challenge_detail_screens/goal_detail_screen.dart';
import '../screens/challenge_screens/create_challenge_screens/challenge_completion_screen.dart';
import '../screens/challenge_screens/create_challenge_screens/create_a_challenge_screen.dart';
import '../screens/challenge_screens/create_challenge_screens/goal_entry_screen.dart';

import 'package:fitness_gurus_challenger/screens/hall_of_fame_screen.dart';
import 'package:fitness_gurus_challenger/screens/my_favorites/my_favorites.dart';
import 'package:fitness_gurus_challenger/screens/home_screen.dart';
import 'package:fitness_gurus_challenger/screens/search_screen.dart';
import 'package:fitness_gurus_challenger/screens/settings_screen/setting_screen.dart';
import 'package:flutter/material.dart';
import '../models/challenge.dart';
import '../screens/home_screen.dart';
import '../screens/upload_screens/upload_image_screen.dart';

class NavigationService {
  final _routes = {
    HomeScreen.routeName: (context) => HomeScreen(),
    // ChatScreen.routeName: (context) => ChatScreen(),
    AuthenticationOptionsScreen.routeName: (context) =>
        AuthenticationOptionsScreen(),
    AuthenticationHomeRouter.routeName: (context) => AuthenticationHomeRouter(),
    EmailPasswordLoginScreen.routeName: (context) => EmailPasswordLoginScreen(),
    SignUpScreen.routeName: (context) => SignUpScreen(),
    CreateAChallengeScreen.routeName: (context) => CreateAChallengeScreen(),
    MyFavorites.routeName: (context) => MyFavorites(),
    ChallengeCompletion.routeName: (context) => ChallengeCompletion(),
    SettingsScreen.routeName: (context) => SettingsScreen(),
    SearchScreen.routeName: (context) => SearchScreen(),
    UploadImageScreen.routeName: (context) => UploadImageScreen(),
    GoalEntryScreen.routeName: (context) => GoalEntryScreen(),
    GoalDetailScreen.routeName: (context) => GoalDetailScreen(),
    HallOfFameScreen.routeName: (context) => HallOfFameScreen(),
    ChallengeGoalListScreen.routeName: (context) => ChallengeGoalListScreen(),
    FitnessTracker.routeName: (context) => FitnessTracker(),
    UserProfileScreen.routeName: (context) => UserProfileScreen(),
    UpdateUserScreen.routeName: (context) => UpdateUserScreen(),
    SafeScreen.routeName: (context) => SafeScreen(),
  };

  dynamic get routes => _routes;

  void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

  void navigateToHomeScreen(BuildContext context) {
    Navigator.of(context).pushNamed(HomeScreen.routeName);
  }

  Future<void> navigateToFitnessTracker(BuildContext context, Challenge dto) {
    return Navigator.of(context)
        .pushNamed(FitnessTracker.routeName, arguments: dto);
  }

  void navigateToAuthenticationHomeRouter(BuildContext context) {
    Navigator.of(context).pushNamed(AuthenticationHomeRouter.routeName);
  }

  void navigateToAuthenticationOptionsScreen(BuildContext context) {
    Navigator.of(context).pushNamed(AuthenticationOptionsScreen.routeName);
  }

  void navigateToEmailPasswordLoginScreen(BuildContext context) {
    Navigator.of(context).pushNamed(EmailPasswordLoginScreen.routeName);
  }

  void navigateToMyFavorites(BuildContext context) {
    Navigator.of(context).pushNamed(MyFavorites.routeName);
  }

  void navigateToChallengeCompletion(BuildContext context) {
    Navigator.of(context).pushNamed(ChallengeCompletion.routeName);
  }

  void navigateToSignUpScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      SignUpScreen.routeName,
    );
  }

  void navigateToCreateAChallengeScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      CreateAChallengeScreen.routeName,
    );
  }

  void navigationClearStack(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => AuthenticationHomeRouter()),
        (r) => false);
  }

  void navigateToChatScreen(BuildContext context) {
    Navigator.of(context).pushNamed(ChatScreen.routeName);
  }

  void navigateToSettingsScreen(BuildContext context) {
    Navigator.of(context).pushNamed(SettingsScreen.routeName);
  }

  void navigateToSearchScreen(BuildContext context) {
    Navigator.of(context).pushNamed(SearchScreen.routeName);
  }

  Future navigateToUploadScreen(BuildContext context) {
    return Navigator.of(context).pushNamed(UploadImageScreen.routeName);
  }

  Future navigateToGoalEntryScreen(BuildContext context) async {
    return Navigator.pushNamed(context, GoalEntryScreen.routeName);
  }

  Future<void> navigateToGoalDetailScreen(
      BuildContext context, GoalDetailArg dto) {
    return Navigator.pushNamed(context, GoalDetailScreen.routeName,
        arguments: dto);
  }

  void navigateToHallOfFameScreen(BuildContext context, HallArg dto) {
    Navigator.pushNamed(context, HallOfFameScreen.routeName, arguments: dto);
  }

  void navigateToChallengeGoalListScreen(BuildContext context, Challenge dto) {
    Navigator.pushNamed(context, ChallengeGoalListScreen.routeName,
        arguments: dto);
  }

  void navigateToUserProfileScreen(BuildContext context, String uid) {
    Navigator.pushNamed(context, UserProfileScreen.routeName, arguments: uid);
  }

  void navigateToUpdateUserScreen(BuildContext context, AppUser appUser) {
    Navigator.pushNamed(context, UpdateUserScreen.routeName,
        arguments: appUser);
  }

  void navigateToSafeScreen(BuildContext context, String uid) {
    Navigator.of(context).pushNamed(SafeScreen.routeName, arguments: uid);
  }
}
