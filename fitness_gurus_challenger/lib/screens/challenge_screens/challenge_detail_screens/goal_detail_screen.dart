import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_gurus_challenger/components/general/main_app_bar_.dart';
import 'package:fitness_gurus_challenger/components/general/my_title.dart';
import 'package:fitness_gurus_challenger/models/app_user.dart';
import 'package:fitness_gurus_challenger/models/challenge.dart';
import 'package:fitness_gurus_challenger/models/goal.dart';
import 'package:fitness_gurus_challenger/models/goal_detail_arg.dart';
import 'package:fitness_gurus_challenger/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoalDetailScreen extends StatefulWidget {
  static const routeName = 'goal_detail';

  @override
  _GoalDetailScreenState createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen> {
  final _databaseService = DataBaseService();
  @override
  Widget build(BuildContext context) {
    GoalDetailArg goalDetailArg = ModalRoute.of(context).settings.arguments;

    AppUser appUser =
        AppUser.fromFirebaseDoc(Provider.of<DocumentSnapshot>(context));

    final _screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: MainAppBar(),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        if (MediaQuery.of(context).orientation == Orientation.portrait ||
            constraints.maxWidth < 500) {
          return goalDetailCard(
              imageHeight: _screenSize.height * .3,
              imageWidth: _screenSize.width,
              spacing: _screenSize.height * .1,
              goal: goalDetailArg.goal,
              isLive: goalDetailArg.isLive,
              appUser: appUser,
              challenge: goalDetailArg.challenge);
        } else {
          return goalDetailCard(
              imageHeight: _screenSize.height * .6,
              imageWidth: _screenSize.width * .6,
              spacing: _screenSize.height * .1,
              goal: goalDetailArg.goal,
              isLive: goalDetailArg.isLive,
              appUser: appUser,
              challenge: goalDetailArg.challenge);
        }
      }),
    );
  }

  Widget goalDetailCard(
      {@required double imageHeight,
      @required double imageWidth,
      @required double spacing,
      @required Goal goal,
      @required bool isLive,
      @required AppUser appUser,
      Challenge challenge}) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyTitle(title: goal.title),
          isLive == true
              ? goal.completed == false
                  ? Text(
                      "You Got This! Let's Complete this Goal",
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  : Text(
                      'Congrats You Completed this Goal!',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
              : Text(''),
          Center(
            child: SizedBox(
                width: imageWidth,
                height: imageHeight,
                child: Image.network(
                  goal.coverUrl,
                  fit: BoxFit.fill,
                )),
          ),
          SizedBox(
            height: spacing * .25,
          ),
          isLive == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    goal.completed == false
                        ? ElevatedButton(
                            onPressed: () async {
                              await _databaseService.completeGoal(
                                appUser: appUser,
                                goal: goal,
                                challenge: challenge,
                              );
                              setState(() {});
                            },
                            child: Text('Mark Complete',
                                style: TextStyle(color: Colors.green)))
                        : ElevatedButton(
                            onPressed: () async {
                              await _databaseService.undueCompletion(
                                  goal: goal,
                                  appUser: appUser,
                                  challenge: challenge);
                              setState(() {});
                            },
                            child: Text('Unmark Complete',
                                style: TextStyle(color: Colors.red)))
                  ],
                )
              : Text(''),
          SizedBox(
            height: spacing,
          ),
          Text("Type: ${goal.type}"),
          SizedBox(
            height: spacing,
          ),
          Text(goal.description),
        ],
      ),
    );
  }
}
