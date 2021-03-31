import 'package:flutter/material.dart';
import 'package:fitness_gurus_challenger/services/navigation_service.dart';
import 'package:fitness_gurus_challenger/components/general/main_app_bar_.dart';

// ignore: must_be_immutable
class ChallengeCompletion extends StatelessWidget {
  static const routeName = 'ChallengeCompletion';
  final navigationService = NavigationService();

  var challenges = [
    'challenge 1',
    'challenge 2',
    'challenge 3',
    'challenge 4',
    'challenge 5',
    'challenge 6',
  ];

  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      home: Scaffold(
        appBar: MainAppBar(),
        body: displayChallenges(),
      ),
    );
  }

  GridView displayChallenges() {
    return GridView.count(
      crossAxisCount: 2,
      // Generate 6 widgets that display their index in the List.
      children: List.generate(6, (index) {
        return Center(
          child: Text(challenges.elementAt(index)),
        );
      }),
    );
  }
}
