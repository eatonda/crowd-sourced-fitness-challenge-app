import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_gurus_challenger/models/hall_entry.dart';
import 'goal.dart';

class Challenge {
  String cid;
  String title;
  String type;
  String description;
  List<String> tags = [];
  String badgeUrl;
  String coverUrl;
  List<Goal> goals = [];
  List<HallEntry> hallOfFame = [];
  int numberOfRatings;
  int ratingTotal;

  Challenge(
      {this.cid = 'no cid',
      this.title = 'no title',
      this.type,
      this.description = 'no description',
      this.badgeUrl,
      this.coverUrl,
      this.numberOfRatings = 0,
      this.ratingTotal = 0});

  Challenge.fromFirebaseQueryDoc({QueryDocumentSnapshot challengeDoc}) {
    this.cid = challengeDoc.data()['cid'];
    this.title = challengeDoc.data()['title'];
    this.type = challengeDoc.data()['type'];
    this.description = challengeDoc.data()['description'];
    this.badgeUrl = challengeDoc.data()['badgeUrl'];
    this.coverUrl = challengeDoc.data()['coverUrl'];
    this.numberOfRatings = challengeDoc.data()['numberOfRatings'];
    this.ratingTotal = challengeDoc.data()['ratingTotal'];

    // Get Goals , note for backend efficency I will not populate goals with
    //subcollection query, if you want goals simply utlize the databaseService to
    // query the subcollections associated, and use the Goals.fromFirebaseDoc constructor
    // to add goals to instantiated challenge.goals member using list functions.
    //This is more efficient because the user only needs the goals of the
    //challengeDetail they wish to view. Same logic goes with hall of fame.
    dynamic docTags = challengeDoc.get('tags');

    docTags.forEach((element) {
      this.tags.add(element);
    });
  }

  void getTag(String s) {
    // Remove extra white space
    s = s.trimRight();

    List<String> newTags = s.split('#');

    //Account for empty first element for tags are lead by #
    newTags.removeAt(0);

    // Eliminate any duplicates if they exist
    removeDuplicates(newTags);

    newTags.forEach((element) {
      this.tags.add(element);
    });
  }

  void removeDuplicates(List<String> s) {
    int foundIndex;

    if (this.tags.isNotEmpty) {
      print("issue");
      s.forEach((element) {
        foundIndex = this.tags.indexOf(element);
        if (foundIndex != -1) {
          print('found duplicate');
          // Found duplicate remove from tags
          this.tags.removeAt(foundIndex);
        }
      });
    }
  }
}
