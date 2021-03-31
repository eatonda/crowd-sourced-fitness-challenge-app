import 'challenge.dart';

class HallArg {
  Challenge challenge;
  bool isHallOfFame;
  bool isCompletedChallenges;
  bool isMyChallenges;

  HallArg(
      {this.challenge,
      this.isCompletedChallenges = false,
      this.isHallOfFame = false,
      this.isMyChallenges = false});
}
