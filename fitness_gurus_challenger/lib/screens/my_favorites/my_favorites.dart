import 'package:fitness_gurus_challenger/models/app_user.dart';
import 'package:fitness_gurus_challenger/models/challenge.dart';
import 'package:fitness_gurus_challenger/models/search_parameters.dart';
import 'package:fitness_gurus_challenger/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:fitness_gurus_challenger/services/navigation_service.dart';
import 'package:fitness_gurus_challenger/components/general/main_app_bar_.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../components/general/my_title.dart';

// ignore: must_be_immutable
class MyFavorites extends StatelessWidget {
  final _navigationService = NavigationService();
  static const routeName = 'MyFavorites';
  final _databaseService = DataBaseService();

  var favorites = [
    'favorites 1',
    'favorites 2',
    'favorites 3',
    'favorites 4',
    'favorites 5',
    'favorites 6',
  ];

  @override
  Widget build(BuildContext context) {
    // GridView userFavorites = displayFavorites();

    // You have a stream you can use, thus no need for extra backend call.
    // Streams are automatically updated when things change and that is why
    // I made that structural change to have a StreamProvider wrap my_app
    AppUser appUser =
        AppUser.fromFirebaseDoc(Provider.of<DocumentSnapshot>(context));

    final spacing = MediaQuery.of(context).size.width * 0.1;

    return Scaffold(
      appBar: MainAppBar(),
      body: getMyFavoritesBody(appUser, spacing),
      // body: listViewFavorites(appUser),
    );
  }

  Widget getMyFavoritesBody(AppUser appUser, double spacing) {
    return Column(
      children: [
        MyTitle(title: 'Favorites'),
        Text("${appUser.firstName}'s favorites",
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: spacing,
        ),
        Expanded(child: listViewFavorites(appUser)),
      ],
    );
  }

  // GridView displayFavorites(AppUser appUser, double spacing) {
  //   //You can now use appUser directly to render your page.
  //   // i.e appUser.favorites[i] etc

  //   return GridView.count(
  //     crossAxisCount: 1,
  //     mainAxisSpacing: spacing,
  //     // Generate 4 widgets that display their index in the List.
  //     children: List.generate(appUser.favorites.length, (index) {
  //       return Center(
  //         child: ListTile(
  //           leading: CircleAvatar(
  //             backgroundImage: NetworkImage(appUser.favorites[index].coverUrl),
  //           ),
  //           title: Text(appUser.favorites[index].title),
  //           onTap: () => null,
  //           tileColor: Colors.red,
  //         ),
  //       );
  //     }
  //   ));
  // }

  Widget listViewFavorites(AppUser appUser) {
    List<Challenge> challenges;

    return ListView.separated(
      itemCount: appUser.favorites.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(appUser.favorites[index].coverUrl),
          ),
          title: Text(appUser.favorites[index].title),
          onTap: () async {
            challenges = await _databaseService.getListOfChallenges(
                SearchParameters(cid: appUser.favorites[index].cid));
            _navigationService.navigateToFitnessTracker(context, challenges[0]);
          },
          tileColor: Colors.red,
        );
      },
      separatorBuilder: (context, index) => Divider(),
      shrinkWrap: true,
    );
  }
}
