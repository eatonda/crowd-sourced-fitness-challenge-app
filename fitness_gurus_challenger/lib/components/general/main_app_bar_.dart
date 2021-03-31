import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_gurus_challenger/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final _navigationService = NavigationService();

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot documentSnapshot = Provider.of<DocumentSnapshot>(context);

    if (documentSnapshot != null) {
      AppUser appUser =
          AppUser.fromFirebaseDoc(Provider.of<DocumentSnapshot>(context));

      return AppBar(actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            _navigationService.navigateToSettingsScreen(context);
          },
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => _navigationService.navigateToSearchScreen(context),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _navigationService.navigateToCreateAChallengeScreen(context);
          },
        ),
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: Colors.white,
          ),
          onPressed: () => _navigationService.navigateToMyFavorites(context),
        ),
        IconButton(
          icon: CircleAvatar(
            backgroundImage: NetworkImage(appUser.profileImageUrl),
          ),
          onPressed: () => _navigationService.navigateToHomeScreen(context),
        ),
      ]);
    } else {
      print('doc null');
      return AppBar();
    }
  }

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}
