/*
  File Name: badge.dart 
  Description: Model used to abstract badges
*/

class Badge {
  int badgeID;
  String description;
  int mediaID;
  int groupID;

  Badge({
    this.badgeID,
    this.description,
    this.mediaID,
    this.groupID,
  });
}
