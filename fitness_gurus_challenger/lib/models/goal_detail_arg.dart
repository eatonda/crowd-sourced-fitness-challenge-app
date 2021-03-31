import 'package:fitness_gurus_challenger/models/challenge.dart';

import 'goal.dart';

class GoalDetailArg {
  Goal goal;
  bool isLive;
  Challenge challenge;

  GoalDetailArg({this.goal, this.isLive = false, this.challenge});
}
