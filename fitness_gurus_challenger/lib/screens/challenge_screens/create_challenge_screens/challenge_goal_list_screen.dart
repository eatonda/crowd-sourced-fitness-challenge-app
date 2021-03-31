import 'package:fitness_gurus_challenger/components/goal_components/goal_tiles.dart';
import 'package:fitness_gurus_challenger/models/challenge.dart';
import 'package:flutter/material.dart';

class ChallengeGoalListScreen extends StatelessWidget {
  static const routeName = "challenge_goal_list";

  @override
  Widget build(BuildContext context) {
    String goalsText = "Goals";
    final Challenge dto = ModalRoute.of(context).settings.arguments;

    if (dto.goals.length == 1) {
      goalsText = "Goal";
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('${dto.goals.length} ' + goalsText),
        ),
        body: GoalTiles(goalsList: dto.goals));
  }
}
