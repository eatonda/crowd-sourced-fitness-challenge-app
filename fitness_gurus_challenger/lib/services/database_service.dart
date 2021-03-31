/*
  File Name = database_service.dart 
  Description: This class abstracts firebase database functionality. 

  Citation(s):
    1. "Cloud Firestore"
      https://firebase.flutter.dev/docs/firestore/usage/
      Assisted with overall structure of interacting, querying, and using 
      firebase. 
*/

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness_gurus_challenger/models/app_user.dart';
import 'package:fitness_gurus_challenger/models/favorite_dto.dart';
import 'package:fitness_gurus_challenger/models/hall_entry.dart';
import 'package:fitness_gurus_challenger/models/search_parameters.dart';
import 'package:fitness_gurus_challenger/models/trophy.dart';

import '../models/app_user.dart';
import '../models/challenge.dart';
import '../models/goal.dart';

class DataBaseService {
  final _firestoreInstance = FirebaseFirestore.instance;

  // Gets instance of user document snapshot
  Future<DocumentSnapshot> getUserDocumentSnapshot(String uid) async =>
      await _firestoreInstance.collection('users').doc(uid).get();

  // Returns a AppUser DTO of the user in 'users'
  Future<AppUser> getUserFromFromDatabase(String uid) async {
    print('safjklksadj');
    AppUser user = AppUser(uid: uid);
    DocumentSnapshot documentSnapshot = await getUserDocumentSnapshot(uid);

    if (documentSnapshot.exists) {
      user.firstName = documentSnapshot.data()["firstName"];
      user.lastName = documentSnapshot.data()["lastName"];
      user.profileImageUrl = documentSnapshot.data()["profileImageUrl"];
      user.darkThemeFlag = documentSnapshot.data()["darkThemeFlag"];
      user.bio = documentSnapshot.data()["bio"];

      // Get favorites and add to AppUser

      List favorites = documentSnapshot.get('favorites');

      if (favorites.length > 1) {
        print('getting favorites DATABASE');
        for (int i = 1; i < favorites.length; i++) {
          user.favorites.add(FavoriteDTO(
              cid: favorites[i]['cid'],
              coverUrl: favorites[i]['coverUrl'],
              title: favorites[i]['title']));
        }
      } else {
        print('favorites exist');
      }

      return user;
    } else {
      print('no user doc!');
      return null; // Signal no user in database
    }
  }

  // Chat Serivces
  Future<void> createChatRoom(String chatRoomId, chatRoomInfo) async {
    await _firestoreInstance
        .collection("chatRooms")
        .doc(chatRoomId)
        .set(chatRoomInfo)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> addUserToChatRoom(String chatRoomId, chatRoomInfo) async {
    await _firestoreInstance
        .collection("chatRooms")
        .doc(chatRoomId)
        .update(chatRoomInfo)
        .catchError((e) {
      print(e);
    });
  }

  // End chat services

  // Get stream of the user doc for StreamProvider
  Stream<DocumentSnapshot> getUsersStream(String uid) {
    return _firestoreInstance.collection('users').doc(uid).snapshots();
  }

  // Returns flag for dark theme from user collection in cloud firestore
  Future<bool> getUserDarkThemeFlag(String uid) async {
    DocumentSnapshot documentSnapshot = await getUserDocumentSnapshot(uid);

    // Update user model object
    if (documentSnapshot.exists) {
      return documentSnapshot.data()["darkThemeFlag"];
    } else {
      print("getUserDarkThemeFlag: error user does not exists!");
      return false;
    }
  }

  Future<void> updateDarkThemeFlag(AppUser user) async {
    final userRef = _firestoreInstance.collection('users').doc(user.uid);

    if (userRef != null) {
      await userRef.update({"darkThemeFlag": user.darkThemeFlag});
    }
  }

  // Add user to Database setting document id to uid.
  void addUserToDatabase(AppUser user) async {
    if (await isNewUser(user.uid)) {
      // Add user to database if not already created
      print('New User! Adding to DB');
      _firestoreInstance
          .collection('users')
          .doc(user.uid)
          .set({
            'firstName': user.firstName,
            'lastName': user.lastName,
            'profileImageUrl': user.profileImageUrl,
            'uid': user.uid,
            'darkThemeFlag': user.darkThemeFlag,
            'bio': user.bio,
            'favorites': [{}]
          })
          .then((value) => print("user added to collection users"))
          .catchError((error) => print(error));
    } else {
      print('Not a new user! NOT going to add to DB');
    }
  }

  Future<void> updateUserInDatabase(AppUser previous, AppUser dto) async {
    // Get the keys that are different than before
    List<String> keys = previous.getKeysThatDifferFromUpdateInfoForm(dto);

    // Create map with keys
    Map dtoMap = dto.toMap();
    List<MapEntry<String, dynamic>> entries = [];
    keys.forEach((element) {
      entries.add(MapEntry<String, dynamic>(element, dtoMap[element]));
    });

    Map<String, dynamic> toUpload = Map.fromEntries(entries);

    // Update only the values that changed
    final userRef = _firestoreInstance.collection('users').doc(dto.uid);

    if (userRef != null) {
      await userRef.update(toUpload);
      await updateUserInCompletedChallenges(previous, dto);
    }

    print(toUpload);
  }

  // Update the denormalized data at completedChallenges
  Future<void> updateUserInCompletedChallenges(
      AppUser previous, AppUser dto) async {
    // Create map
    // Get the keys that are different than before
    List<String> keys = previous.getKeysThatDifferFromUpdateInfoForm(dto);

    // Create map with keys
    Map dtoMap = dto.toMap();
    List<MapEntry<String, dynamic>> entries = [];
    keys.forEach((element) {
      if (element == 'firstName' || element == 'lastName') {
        entries.add(MapEntry<String, dynamic>(
            'userName', '${dtoMap['firstName']} ${dtoMap['lastName']}'));
      } else if (element == 'profileImageUrl') {
        entries.add(
            MapEntry<String, dynamic>('userProfileImageUrl', dtoMap[element]));
      }
    });

    Map<String, dynamic> toUpload = Map.fromEntries(entries);

    QuerySnapshot completedChallenges = await _firestoreInstance
        .collection('completedChallenges')
        .where('uid', isEqualTo: dto.uid)
        .get();
    DocumentReference doc;

    for (int i = 0; i < completedChallenges.docs.length; i++) {
      doc = _firestoreInstance
          .collection('completedChallenges')
          .doc(completedChallenges.docs[i].id);
      doc.update(toUpload);
    }
  }

  // Search to see if user exists
  Future<bool> isNewUser(String uid) async {
    bool flag = true;

    QuerySnapshot querySnapshot = await _firestoreInstance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      flag = false;
    }

    return flag;
  }

  // Add challenge to Database.
  void addChallengeToDatabase(Challenge challenge) async {
    DocumentReference doc =
        await _firestoreInstance.collection('challenges').add({
      'badgeUrl': challenge.badgeUrl,
      'coverUrl': challenge.coverUrl,
      'description': challenge.description,
      'numberOfRatings': challenge.numberOfRatings,
      'ratingTotal': challenge.ratingTotal,
      'tags': challenge.tags,
      'title': challenge.title,
      'type': challenge.type
    });

    // Update cid parameter
    challenge.cid = doc.id;

    await _firestoreInstance
        .collection('challenges')
        .doc(challenge.cid)
        .set({'cid': challenge.cid}, SetOptions(merge: true))
        .then((value) => print('Updated cid with ${challenge.cid}'))
        .catchError((error) => print('Problem setting cid: $error'));

    // Add Goals as sub-collecton
    int i = 0;
    challenge.goals.forEach((element) {
      addGoalsToDatabase(element, challenge.cid, i);
      i++;
    });
  }

  // Add goals as a subcollecton to challenge
  void addGoalsToDatabase(Goal goal, String cid, int index) async {
    // Add goal with random id generated by firebase
    DocumentReference doc = await _firestoreInstance
        .collection('challenges')
        .doc(cid)
        .collection('goals')
        .add({
      'description': goal.description,
      'coverUrl': goal.coverUrl,
      'title': goal.title,
      'type': goal.type,
      'index': index
    });

    // Update gid
    goal.gid = doc.id;

    await _firestoreInstance
        .collection('challenges')
        .doc(cid)
        .collection('goals')
        .doc(goal.gid)
        .set({'gid': goal.gid}, SetOptions(merge: true));
  }

  // Get list of badge urls
  Future<List<String>> getUrlsOfBadges() async {
    List<String> urls = [];
    String s;

    var res = await FirebaseStorage.instance.ref('badges/').listAll();

    for (int i = 0; i < res.items.length; i++) {
      s = await res.items[i].getDownloadURL();
      urls.add(s);
    }

    return urls;
  }

  // Delete user document, used when user deletes account
  Future<void> deleteUserFromUsers(String uid) async {
    try {
      await _firestoreInstance.collection('users').doc(uid).delete();
    } catch (error) {
      print("Error deleting user from users!\n $error");
    }

    print('User deleted form users');
  }

  // Get random default image based on excercise type i.e strength
  Future<String> getRandomDefaultImage(String type) async {
    //map type to specific folder in storage
    final map = {
      "Cardio Anaerobic (Speed and Power)": "cardio",
      "Cardio Aerobic(Endurance)": "cardio",
      "Strength": "strength",
      "Cross-Training": "crossTraining",
      "Flexibility": "flexibility"
    };

    String imageUrl;

    if (map.containsKey(type)) {
      print('key exists');
      try {
        final res = await FirebaseStorage.instance
            .ref('defaultImages/${map[type]}/')
            .listAll();

        if (res.items.isNotEmpty) {
          print('res not empty');
          // Get random image, index [0, res.items.length]
          imageUrl = await res.items[Random().nextInt(res.items.length)]
              .getDownloadURL();
        }
      } catch (error) {
        print('Error attaining default image path, type was: $type');
      }
    }

    print('Random default path attained: $imageUrl');

    return imageUrl;
  }

  // Get Completed Challenges
  Future<List<HallEntry>> getCompletedChallenges(String uid) async {
    List<HallEntry> completedChallenges = [];

    try {
      final snapshot = await _firestoreInstance
          .collection('completedChallenges')
          .where('uid', isEqualTo: uid)
          .get();

      snapshot.docs.forEach((element) {
        completedChallenges.add(HallEntry(
            badgeUrl: element.data()['badgeUrl'],
            cid: element.data()['cid'],
            coverUrl: element.data()['coverUrl'],
            title: element.data()['title'],
            uid: element.data()['uid'],
            userName: element.data()['userName'],
            userProfileImageUrl: element.data()['userProfileImageUrl']));
      });
    } catch (error) {
      print('Error in getHallOfFame: $error');
    }

    return completedChallenges;
  }

  // Delete user's completed challenges
  Future<void> deleteUserCompletedChallenges(String uid) async {
    try {
      // Get all challenges a user completed
      final snapshot = await _firestoreInstance
          .collection('completedChallenges')
          .where('uid', isEqualTo: uid)
          .get();

      snapshot.docs.forEach((element) {
        element.reference.delete();
      });
    } catch (error) {
      print(error);
    }
  }

  // Get Hall of Fame
  Future<List<HallEntry>> getHallOfFame(String cid) async {
    List<HallEntry> hallOfFame = [];

    try {
      final snapshot = await _firestoreInstance
          .collection('completedChallenges')
          .where('cid', isEqualTo: cid)
          .get();

      snapshot.docs.forEach((element) {
        hallOfFame.add(HallEntry(
            badgeUrl: element.data()['badgeUrl'],
            cid: element.data()['cid'],
            coverUrl: element.data()['coverUrl'],
            title: element.data()['title'],
            uid: element.data()['uid'],
            userName: element.data()['userName'],
            userProfileImageUrl: element.data()['userProfileImageUrl']));
      });
    } catch (error) {
      print('Error in getHallOfFame: $error');
    }

    return hallOfFame;
  }

  // Get list of badge urls a user has earned
  Future<List<Trophy>> getUserBadges(String uid) async {
    List<Trophy> trophies = [];

    try {
      final snapshot = await _firestoreInstance
          .collection('completedChallenges')
          .where('uid', isEqualTo: uid)
          .get();

      snapshot.docs.forEach((element) {
        trophies.add(Trophy(
          badgeUrl: element.data()['badgeUrl'],
          cid: element.data()['cid'],
          title: element.data()['title'],
        ));
      });
    } catch (error) {
      print('Error getting user badges $error');
    }

    return trophies;
  }

  // getDefaultProfileImage
  Future getDefaultProfileImage() async {
    String url;
    try {
      final res = await FirebaseStorage.instance
          .ref('defaultImages/userProfile/')
          .listAll();

      if (res.items.isNotEmpty) {
        print('res not empty');
        url = await res.items[0].getDownloadURL();

        return url;
      }
    } catch (error) {
      print('Error attaining default image path, $error');
    }
  }

  // getListOfChallenges by query. not subcollection goals not added
  // use method getGoals for challenge to do to get goal info
  // Challenge.goals = databaseService.getGoals(String cid)
  Future<List<Challenge>> getListOfChallenges(
      SearchParameters parameters) async {
    List<Challenge> results = [];
    QuerySnapshot snapshot;
    final challengesRef = _firestoreInstance.collection('challenges');

    for (int i = 0; i < parameters.keys.length; i++) {
      if (parameters.keys[i] == 'tags') {
        // Array search
        // See if any challenge doc have any of the tags. This is like 'OR'
        snapshot = await challengesRef
            .where('tags', arrayContainsAny: parameters.tags)
            .get();

        snapshot.docs.forEach((element) {
          results.add(Challenge.fromFirebaseQueryDoc(challengeDoc: element));
        });
      }

      // Other parameters must be search one by one
      if (parameters.keys[i] == 'title') {
        snapshot = await challengesRef
            .where('title', isEqualTo: parameters.title)
            .get();

        snapshot.docs.forEach((element) {
          results.add(Challenge.fromFirebaseQueryDoc(challengeDoc: element));
        });
      }

      if (parameters.keys[i] == 'type') {
        snapshot =
            await challengesRef.where('type', isEqualTo: parameters.type).get();

        snapshot.docs.forEach((element) {
          results.add(Challenge.fromFirebaseQueryDoc(challengeDoc: element));
        });
      }

      if (parameters.keys[i] == 'cid') {
        snapshot =
            await challengesRef.where('cid', isEqualTo: parameters.cid).get();

        snapshot.docs.forEach((element) {
          results.add(Challenge.fromFirebaseQueryDoc(challengeDoc: element));
        });
      }
    }

    if (parameters.keys.contains('uid')) {
      //Inefficient
      // print(parameters.uid);
      var challengeHistoryRef = await _firestoreInstance
          .collection('users')
          .doc(parameters.uid)
          .collection('challengeHistory')
          .get();

      challengeHistoryRef.docs.forEach((element) async {
        results.add(Challenge.fromFirebaseQueryDoc(challengeDoc: element));
      });
    }

    return results;
  }

  //This query gets you the list of goals associated with a challenge and updates
  // the challenge.goals parameter.
  // This is separated from getListChallenges for data base read optimization.
  // i.e only query when user views challengeDetailScreen
  Future<void> getGoals({Challenge challenge, String uid}) async {
    // print(challenge.type);

    // Because Challenges and goals do not change we can just check
    // to see if the challenge.goals member is empty. If so, get the challenges
    // from the database, else do nothing
    if (challenge.goals.isEmpty) {
      final goalsRef = await _firestoreInstance
          .collection('challenges')
          .doc(challenge.cid)
          .collection('goals')
          .orderBy('index')
          .get();

      print(goalsRef.docs.length);

      goalsRef.docs.forEach((element) {
        print(element);
        challenge.goals.add(Goal.fromFirebaseDoc(goalDoc: element));
        print(challenge.goals.length);
      });
    }
    //Mark the completed goals
    if (uid != null) {
      final userRef = await _firestoreInstance
          .collection('users')
          .doc(uid)
          .collection('challengeHistory')
          .doc(challenge.cid)
          .collection('completedGoals')
          .get();

      if (userRef.docs.length > 0) {
        // If the user has completed challenges for that particular challenge update goals
        userRef.docs.forEach((element) {
          for (int i = 0; i < challenge.goals.length; i++) {
            if (element.id == challenge.goals[i].gid) {
              challenge.goals[i].completed = true;
            }
          }
        });
      }
    }
  }

  // Updates users challengeHistory/completedGoals/ to store goal completed.
  Future<void> completeGoal(
      {Goal goal, AppUser appUser, Challenge challenge}) async {
    try {
      // Arrays have limitations in firebase. If I used one, I would have to first
      // query if it exists then perform a write to either create one or append it.
      // thus 2 operations per goal, the below implentation allows 1 single operation
      // per goal. Plus it is easy to get a list of all docs in collection for
      // querying to see if a goal is completed for rendering purposes and for
      // goal complete
      print('completeGoal: challenge cid: ${challenge.cid}');
      // Add challenge info first for easy reference.

      await _firestoreInstance
          .collection('users')
          .doc(appUser.uid)
          .collection('challengeHistory')
          .doc(challenge.cid)
          .set({
        'badgeUrl': challenge.badgeUrl,
        'coverUrl': challenge.coverUrl,
        'description': challenge.description,
        'numberOfRatings': challenge.numberOfRatings,
        'ratingTotal': challenge.ratingTotal,
        'tags': challenge.tags,
        'title': challenge.title,
        'type': challenge.type,
        'cid': challenge.cid
      });

      await _firestoreInstance
          .collection('users')
          .doc(appUser.uid)
          .collection('challengeHistory')
          .doc(challenge.cid)
          .collection('completedGoals')
          .doc(goal.gid)
          .set({'totalNumberOfGoalsInChallenge': challenge.goals.length});

      // Check to see if challenge is now complete
      final snapshot = await _firestoreInstance
          .collection('users')
          .doc(appUser.uid)
          .collection('challengeHistory')
          .doc(challenge.cid)
          .collection('completedGoals')
          .get();

      if (snapshot.docs.length == challenge.goals.length) {
        // Challenge is now completed
        await addToCompletedChallenges(challenge, appUser);
      }
      // Update challenge.goal
      challenge.goals.forEach((element) {
        if (element.gid == goal.gid) {
          element.completed = true;
        }
      });
    } catch (error) {
      print('Error completeGoal: $error');
    }
  }

  // Updates users challengeHistory/completedGoals/ to delete goal completed.
  Future<void> undueCompletion(
      {Goal goal, AppUser appUser, Challenge challenge}) async {
    // Delete goal doc
    final ref = await _firestoreInstance
        .collection('users')
        .doc(appUser.uid)
        .collection('challengeHistory')
        .doc(challenge.cid)
        .collection('completedGoals')
        .get();

    print(ref.docs.length);

    // Check edge case of that this is the last goal associated
    if (ref.docs.length == 1) {
      // Delete the goal specifically
      await _firestoreInstance
          .collection('users')
          .doc(appUser.uid)
          .collection('challengeHistory')
          .doc(challenge.cid)
          .collection('completedGoals')
          .doc(goal.gid)
          .delete();

      // Then delete parent doc
      await _firestoreInstance
          .collection('users')
          .doc(appUser.uid)
          .collection('challengeHistory')
          .doc(challenge.cid)
          .delete();
    } else {
      // Delete the goal specifically
      await _firestoreInstance
          .collection('users')
          .doc(appUser.uid)
          .collection('challengeHistory')
          .doc(challenge.cid)
          .collection('completedGoals')
          .doc(goal.gid)
          .delete();
    }

    // Challenges are permenant thus a removal of a completed goal means the user
    // no longer has completed the challenge.
    try {
      await removeCompletedChallenge(challenge, appUser);
    } catch (error) {
      print(error);
    }

    // Update challenge
    challenge.goals.forEach((element) {
      if (element.gid == goal.gid) {
        element.completed = false;
      }
    });
  }

  // adds entry to the completedChallenges with the id user + cid
  Future<void> addToCompletedChallenges(
      Challenge challenge, AppUser appUser) async {
    try {
      await _firestoreInstance
          .collection('completedChallenges')
          .doc("${appUser.uid}${challenge.cid}")
          .set({
        'badgeUrl': challenge.badgeUrl,
        'cid': challenge.cid,
        'coverUrl': challenge.coverUrl,
        'title': challenge.title,
        'uid': appUser.uid,
        'userName': "${appUser.firstName} ${appUser.lastName}",
        'userProfileImageUrl': appUser.profileImageUrl
      });
    } catch (error) {
      print(error);
    }
  }

  // removes entry from completedChallenges with the id user + cid
  Future<void> removeCompletedChallenge(
      Challenge challenge, AppUser appUser) async {
    try {
      await _firestoreInstance
          .collection('completedChallenges')
          .doc("${appUser.uid}${challenge.cid}")
          .delete();
    } catch (error) {
      print(error);
    }
  }

  // Adds challenge cid to favorites
  Future<void> addToFavorites(String uid, Challenge challenge) async {
    final userRef = _firestoreInstance.collection('users').doc(uid);

    try {
      userRef.update({
        'favorites': FieldValue.arrayUnion([
          {
            'cid': challenge.cid,
            'coverUrl': challenge.coverUrl,
            'title': challenge.title,
          }
        ])
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> removeFromFavorites(String uid, Challenge challenge) async {
    final userRef = _firestoreInstance.collection('users').doc(uid);

    print('removing favorite');
    try {
      userRef.update({
        'favorites': FieldValue.arrayRemove([
          {
            'cid': challenge.cid,
            'coverUrl': challenge.coverUrl,
            'title': challenge.title,
          }
        ])
      });
    } catch (error) {
      print(error);
    }
  }
}
