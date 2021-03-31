import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_gurus_challenger/components/general/main_app_bar_.dart';
import 'package:fitness_gurus_challenger/components/general/my_title.dart';
import 'package:fitness_gurus_challenger/models/app_user.dart';
import 'package:fitness_gurus_challenger/models/challenge.dart';
import 'package:fitness_gurus_challenger/models/hall_arg.dart';
import 'package:fitness_gurus_challenger/models/hall_entry.dart';
import 'package:fitness_gurus_challenger/models/search_parameters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/database_service.dart';
import '../services/navigation_service.dart';

class HallOfFameScreen extends StatefulWidget {
  static const routeName = 'hall_of_fame_screen';

  @override
  _HallOfFameScreenState createState() => _HallOfFameScreenState();
}

class _HallOfFameScreenState extends State<HallOfFameScreen> {
  final _databaseService = DataBaseService();
  final _navigationService = NavigationService();

  @override
  Widget build(BuildContext context) {
    AppUser appUser =
        AppUser.fromFirebaseDoc(Provider.of<DocumentSnapshot>(context));

    HallArg hallArg = ModalRoute.of(context).settings.arguments;

    if (hallArg.isHallOfFame) {
      return hallOfFame(hallArg.challenge, context);
    } else if (hallArg.isCompletedChallenges) {
      return completedChallenges(
          uid: appUser.uid, context: context, challenge: hallArg.challenge);
    } else {
      return myChallenges(uid: appUser.uid, context: context);
    }
  }

  Widget hallOfFame(Challenge challengeDTO, BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: FutureBuilder(
          future: _databaseService.getHallOfFame(challengeDTO.cid),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print("done hall of fame:");
              challengeDTO.hallOfFame = snapshot.data;
              return Column(
                children: [
                  MyTitle(title: 'Hall of Fame'),
                  challengeDTO.hallOfFame.length == 0
                      ? Center(
                          child: Text(
                          'No Users Have Completed this Challenge!',
                          style: TextStyle(color: Colors.red),
                        ))
                      : Expanded(
                          child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            itemCount: challengeDTO.hallOfFame.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                    "${challengeDTO.hallOfFame[index].userName}"),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    challengeDTO
                                        .hallOfFame[index].userProfileImageUrl,
                                  ),
                                ),
                                onTap: () => _navigationService
                                    .navigateToUserProfileScreen(context,
                                        challengeDTO.hallOfFame[index].uid),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(
                              height: MediaQuery.of(context).size.height * .04,
                            ),
                          ),
                        ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Widget completedChallenges(
      {String uid, BuildContext context, Challenge challenge}) {
    List<HallEntry> entries;
    List<Challenge> challenges;

    return Scaffold(
      appBar: MainAppBar(),
      body: FutureBuilder(
          future: _databaseService.getCompletedChallenges(uid),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print("done completed challenges:");
              entries = snapshot.data;
              return Column(
                children: [
                  MyTitle(title: 'Completed Challenges'),
                  entries.length == 0
                      ? Center(
                          child: Text(
                          'You Have Not Completed Any Challenges!',
                          style: TextStyle(color: Colors.red),
                        ))
                      : Expanded(
                          child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            itemCount: entries.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                tileColor: Colors.green,
                                title: Text("${entries[index].title}"),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    entries[index].coverUrl,
                                  ),
                                ),
                                onTap: () async {
                                  // Get Challenges
                                  challenges = await _databaseService
                                      .getListOfChallenges(SearchParameters(
                                          cid: entries[index].cid));

                                  _navigationService.navigateToFitnessTracker(
                                      context, challenges[index]);
                                },
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(
                              height: MediaQuery.of(context).size.height * .04,
                            ),
                          ),
                        ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Widget myChallenges({String uid, BuildContext context}) {
    List<Challenge> entries;

    return Scaffold(
      appBar: MainAppBar(),
      body: FutureBuilder(
          future:
              _databaseService.getListOfChallenges(SearchParameters(uid: uid)),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print("done my challenges:");
              entries = snapshot.data;
              return Column(
                children: [
                  MyTitle(title: 'My Challenges'),
                  entries.length == 0
                      ? Center(
                          child: Text(
                          'You Have Not Started Any Challenges!',
                          style: TextStyle(color: Colors.red),
                        ))
                      : Expanded(
                          child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            itemCount: entries.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                tileColor: Colors.amber,
                                title: Text("${entries[index].title}"),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    entries[index].coverUrl,
                                  ),
                                ),
                                onTap: () async {
                                  _navigationService.navigateToFitnessTracker(
                                      context, entries[index]);
                                },
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(
                              height: MediaQuery.of(context).size.height * .04,
                            ),
                          ),
                        ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
