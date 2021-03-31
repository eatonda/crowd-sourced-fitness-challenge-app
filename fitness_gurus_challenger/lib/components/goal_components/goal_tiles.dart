import 'package:fitness_gurus_challenger/models/goal.dart';
import 'package:fitness_gurus_challenger/models/goal_detail_arg.dart';
import 'package:fitness_gurus_challenger/services/navigation_service.dart';
import 'package:flutter/material.dart';

class GoalTiles extends StatelessWidget {
  final List<Goal> goalsList;
  final navigationService = NavigationService();

  GoalTiles({@required this.goalsList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: goalsList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(goalsList[index].title),
            trailing: Text("Type: ${goalsList[index].type}"),
            onTap: () => navigationService.navigateToGoalDetailScreen(
                context, GoalDetailArg(goal: goalsList[index])),
          );
        });
  }
}
