import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_gurus_challenger/components/my_app.dart';
import 'package:fitness_gurus_challenger/models/app_user.dart';
import 'package:fitness_gurus_challenger/services/authentication_service.dart';
import 'package:fitness_gurus_challenger/services/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

class SettingOptions extends StatefulWidget {
  @override
  _SettingOptionsState createState() => _SettingOptionsState();
}

class _SettingOptionsState extends State<SettingOptions> {
  final NavigationService _navigationService = NavigationService();
  final AuthenticationService _authenticationService = AuthenticationService();
  bool darkThemeFlag;
  var r;
  AppUser _user;

  @override
  Widget build(BuildContext context) {
    final MyAppState _myAppState =
        context.findAncestorStateOfType<MyAppState>();

    DocumentSnapshot documentSnapshot = Provider.of<DocumentSnapshot>(context);
    if (documentSnapshot == null) {
      print('setting options doc null');
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      _user = AppUser.fromFirebaseDoc(Provider.of<DocumentSnapshot>(context));

      if (_user != null) {
        darkThemeFlag = _user.darkThemeFlag;
      }

      // darkThemeFlag = false;
      print(darkThemeFlag);

      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SwitchListTile(
                title: Text('Dark Mode'),
                value: darkThemeFlag,
                onChanged: (value) {
                  setState(() {
                    if (darkThemeFlag != value) {
                      print("Before $darkThemeFlag");
                      // darkThemeFlag = value;
                      _user.darkThemeFlag = value;
                      _myAppState.changeBrightness(
                        context: context,
                        user: _user,
                      );
                      print("After $value");
                    }
                  });
                }),
            TextButton(
              child: Text("Logout"),
              onPressed: () async {
                await _authenticationService.logout();
                _myAppState.updateUserLocal();
                _navigationService.navigationClearStack(context);
                Phoenix.rebirth(context);
              },
            ),
            TextButton(
              child: Text("Delete Account"),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title:
                        Text('Are you sure you want to delete your account?'),
                    content: Text('This cannot be undone'),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            _navigationService.navigateBack(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          _navigationService.navigateToSafeScreen(
                              context, _user.uid);
                        },
                        child: Text(
                          'Delete Account',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  barrierDismissible: false,
                );
              },
            ),
          ],
        ),
      );
    }
  }
}
