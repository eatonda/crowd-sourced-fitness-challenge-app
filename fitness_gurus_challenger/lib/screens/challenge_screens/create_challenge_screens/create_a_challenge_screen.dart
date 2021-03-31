import 'package:fitness_gurus_challenger/components/create_challenge/create_challenge_form.dart';
import 'package:fitness_gurus_challenger/components/general/main_app_bar_.dart';
import 'package:fitness_gurus_challenger/components/general/my_title.dart';
import 'package:fitness_gurus_challenger/models/challenge.dart';
import 'package:fitness_gurus_challenger/services/database_service.dart';
import 'package:flutter/material.dart';

class CreateAChallengeScreen extends StatefulWidget {
  static const routeName = "create_a_challenge";

  @override
  _CreateAChallengeScreenState createState() => _CreateAChallengeScreenState();
}

class _CreateAChallengeScreenState extends State<CreateAChallengeScreen> {
  Future badgeUrls;
  final _datbaseService = DataBaseService();

  @override
  void initState() {
    super.initState();
    badgeUrls = _getUrlBadges();
  }

  Future _getUrlBadges() async {
    return await _datbaseService.getUrlsOfBadges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: FutureBuilder(
          future: badgeUrls,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text("Problem None");
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                return SingleChildScrollView(
                  child: Column(children: [
                    // Title
                    MyTitle(title: "Create a Challenge"),
                    CreateChallengeForm(
                      listOfBadgeUrls: snapshot.data,
                      challengeDTO: Challenge(),
                    ),
                  ]),
                );
              default:
                return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
