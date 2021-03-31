import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_gurus_challenger/components/Colors.dart';
import 'package:fitness_gurus_challenger/components/customButton.dart';
import 'package:fitness_gurus_challenger/components/general/main_app_bar_.dart';
import 'package:fitness_gurus_challenger/components/general/my_title.dart';
import 'package:fitness_gurus_challenger/models/hall_arg.dart';
import 'package:fitness_gurus_challenger/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_user.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home';
  final uid;

  HomeScreen({this.uid});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _navigationService = NavigationService();

  @override
  Widget build(BuildContext context) {
    //return (Text('test'));
    DocumentSnapshot documentSnapshot = Provider.of<DocumentSnapshot>(context);

    if (documentSnapshot == null) {
      // print('doc is null');
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: CircleAvatar(),
        ),
      );
    } else {
      AppUser appUser =
          AppUser.fromFirebaseDoc(Provider.of<DocumentSnapshot>(context));

      return Scaffold(
        appBar: MainAppBar(),
        body: homePageBody(appUser, context),
      );
    }
  }

  Widget homePageBody(AppUser appUser, BuildContext context) {
    final _spacing = MediaQuery.of(context).size.height / 60;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Center(
              child: MyTitle(
                  title:
                      "Welcome Back, ${appUser.firstName} ${appUser.lastName}!"),
            ),
          ),
          Container(
            child: CircleAvatar(
              backgroundColor: basicCOlor,
              radius: 60.0,
              backgroundImage: NetworkImage(appUser.profileImageUrl),
            ),
          ),
          SizedBox(
            height: _spacing,
          ),
          CustomerButton(
            text: Text(
              "My Profile",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => _navigationService.navigateToUserProfileScreen(
                context, appUser.uid),
            disbaleColor: basicCOlor,
            focusColor: basicCOlor,
          ),
          SizedBox(
            height: _spacing,
          ),
          CustomerButton(
            text: Text(
              "My Challenges",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => _navigationService.navigateToHallOfFameScreen(
                context, HallArg(isMyChallenges: true)),
            disbaleColor: basicCOlor,
            focusColor: basicCOlor,
          ),
          SizedBox(
            height: _spacing,
          ),
          // CustomerButton(
          //   text: Text(
          //     "My Badges",
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   onPressed: null,
          //   disbaleColor: basicCOlor,
          //   focusColor: basicCOlor,
          // ),
          // SizedBox(
          //   height: _spacing,
          // ),
          CustomerButton(
            text: Text(
              "Completed Challenges",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => _navigationService.navigateToHallOfFameScreen(
                context, HallArg(isCompletedChallenges: true)),
            disbaleColor: basicCOlor,
            focusColor: basicCOlor,
          ),
          SizedBox(
            height: _spacing,
          ),
          CustomerButton(
            text: Text(
              "My Favorites",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => _navigationService.navigateToMyFavorites(context),
            disbaleColor: basicCOlor,
            focusColor: basicCOlor,
          ),
          SizedBox(
            height: _spacing,
          ),
          CustomerButton(
            text: Text(
              "Update My Profile Image/Info",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () =>
                _navigationService.navigateToUpdateUserScreen(context, appUser),
            disbaleColor: basicCOlor,
            focusColor: basicCOlor,
          ),
        ],
      ),
    );
  }
}
