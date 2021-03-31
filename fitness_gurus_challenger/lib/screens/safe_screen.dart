import 'package:fitness_gurus_challenger/components/my_app.dart';
import 'package:fitness_gurus_challenger/services/authentication_service.dart';
import 'package:fitness_gurus_challenger/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class SafeScreen extends StatefulWidget {
  static const routeName = 'safe_screen';

  @override
  _SafeScreenState createState() => _SafeScreenState();
}

class _SafeScreenState extends State<SafeScreen> {
  final _navigationService = NavigationService();
  final _authenticationService = AuthenticationService();
  var r;

  @override
  Widget build(BuildContext context) {
    String uid = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Account'),
      ),
      body: deleteProcess(context, uid),
    );
  }

  Widget deleteProcess(BuildContext context, String uid) {
    final MyAppState _myAppState =
        context.findAncestorStateOfType<MyAppState>();

    return Center(
      child: ElevatedButton(
          child: Text('Delete Account Permanently',
              style: TextStyle(color: Colors.red)),
          onPressed: () async {
            r = await _authenticationService.deleteAccount(uid);
            setState(() {});
            print('r: $r');
            // Check for success
            if (r != null) {
              _myAppState.updateUserLocal();
              _navigationService.navigationClearStack(context);
              Phoenix.rebirth(context);
            } else {
              print('not working');
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(
                      'You must be recently signed in to delete your account.'),
                  content: Text('Log off and resign-in then delete account'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        _navigationService.navigateBack(context);
                        _navigationService.navigateBack(context);
                        _navigationService.navigateBack(context);
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
