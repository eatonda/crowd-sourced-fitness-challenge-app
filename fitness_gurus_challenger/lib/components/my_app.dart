import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_gurus_challenger/components/general/my_material_app.dart';
import 'package:fitness_gurus_challenger/models/app_user.dart';
import 'package:fitness_gurus_challenger/services/database_service.dart';
import 'package:fitness_gurus_challenger/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_user.dart';

class MyApp extends StatefulWidget {
  static final routes = NavigationService().routes;
  final databaseService = DataBaseService();

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  AppUser appUser;

  @override
  Widget build(BuildContext context) {
    final firebaseUser = Provider.of<User>(context);

    if (firebaseUser != null) {
      appUser = AppUser(uid: firebaseUser.uid);
      // print('signed in');
    } else {
      appUser = null;
    }
    //final appUser = Provider.of<AppUser>(context);

    Future<Brightness> _brightness = getBrightnessArgument(context, appUser);

    // Future<AppUser> getUser = widget.databaseService.getUserFromFromDatabase(firebaseUser.uid);

    return StreamProvider<DocumentSnapshot>(
      create: (context) =>
          widget.databaseService.getUsersStream(firebaseUser.uid),
      child: FutureBuilder(
          future: _brightness,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // print("done got brightness");
              return MyMaterialApp(brightness: snapshot.data);
            } else {
              // print('myApp');
              return MyMaterialApp(
                brightness: Brightness.light,
              );
            }
          }),
    );
  }

  // Looks up darkThemeFlag in database and returns appropriate brightness arg.
  Future<Brightness> getBrightnessArgument(
      BuildContext context, AppUser user) async {
    if (user == null) {
      return Brightness.light;
    } else {
      if (await widget.databaseService.getUserDarkThemeFlag(user.uid) == true) {
        user.darkThemeFlag = true;
        return Brightness.dark;
      } else {
        user.darkThemeFlag = false;
        return Brightness.light;
      }
    }
  }

  Future<void> changeBrightness({BuildContext context, AppUser user}) async {
    await widget.databaseService.updateDarkThemeFlag(user);

    // Set brightness theme for app and rebuild
    setState(() => {});
  }

  void updateUserLocal() {
    appUser = null;
    setState(() {});
  }
}
