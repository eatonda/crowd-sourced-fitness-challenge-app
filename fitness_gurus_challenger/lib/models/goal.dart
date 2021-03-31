import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  String gid;
  String title;
  String coverUrl;
  String description;
  String type;
  bool completed;

  Goal(
      {this.gid,
      this.title,
      this.coverUrl,
      this.description,
      this.type,
      this.completed = false});

  Goal.fromFirebaseDoc({QueryDocumentSnapshot goalDoc}) {
    this.gid = goalDoc.data()['gid'];
    this.title = goalDoc.data()['title'];
    this.type = goalDoc.data()['type'];
    this.coverUrl = goalDoc.data()['coverUrl'];
    this.description = goalDoc.data()['description'];
    this.completed = false;
  }
}
