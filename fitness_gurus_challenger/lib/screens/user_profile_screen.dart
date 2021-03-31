import 'package:fitness_gurus_challenger/models/challenge.dart';
import 'package:fitness_gurus_challenger/models/search_parameters.dart';
import 'package:fitness_gurus_challenger/models/trophy.dart';
import 'package:flutter/material.dart';

import '../components/general/main_app_bar_.dart';
import '../components/general/my_title.dart';
import '../models/app_user.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = 'user_profile_screen';

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _navigationService = NavigationService();

  final _databaseService = DataBaseService();

  @override
  Widget build(BuildContext context) {
    final uid = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: MainAppBar(),
      body: FutureBuilder(
        future: _databaseService.getUserFromFromDatabase(uid),
        builder: (BuildContext context, AsyncSnapshot<AppUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print("done");
            return SingleChildScrollView(
              child: userProfileCard(snapshot.data, context),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget userProfileCard(AppUser user, BuildContext context) {
    double radius;
    Size size = MediaQuery.of(context).size;
    double spacing = MediaQuery.of(context).size.height * .05;

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      radius = size.width * 0.25;
    } else {
      radius = size.width * 0.15;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        MyTitle(title: "${user.firstName} ${user.lastName}"),
        Center(
          child: CircleAvatar(
            backgroundImage: NetworkImage(user.profileImageUrl),
            radius: radius,
          ),
        ),
        SizedBox(
          height: spacing,
        ),
        Text(user.bio),
        SizedBox(
          height: spacing,
        ),
        Text(
          'Badge(s) Earned:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        trophyCase(user.uid, context),
      ],
    );
  }

  Widget trophyCase(String uid, BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _databaseService.getUserBadges(uid),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print("done");
            return Flexible(
              child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return listTileFromTrophy(snapshot.data[index], context);
                  },
                  separatorBuilder: (context, int index) => Divider()),
              fit: FlexFit.loose,
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget listTileFromTrophy(Trophy trophy, BuildContext context) {
    return ListTile(
        tileColor: Color(0xff335078),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(trophy.badgeUrl),
          backgroundColor: Colors.white,
        ),
        title: Text(trophy.title),
        onTap: () async {
          List<Challenge> res = await _databaseService
              .getListOfChallenges(SearchParameters(cid: trophy.cid));
          await _navigationService.navigateToFitnessTracker(context, res[0]);
          setState(() {});
          print(trophy.cid);
        });
  }
}
