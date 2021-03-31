/*
  File Name: app_user.dart 
  Description: Model used to abstract user info from firebase
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_gurus_challenger/models/favorite_dto.dart';
import 'package:flutter/material.dart';

class AppUser {
  String uid;
  String firstName;
  String lastName;
  String profileImageUrl;
  bool darkThemeFlag;
  String bio;
  List<FavoriteDTO> favorites = [];

  AppUser(
      {@required this.uid,
      this.firstName = "firstName",
      this.lastName = "lastName",
      this.profileImageUrl =
          "https://firebasestorage.googleapis.com/v0/b/fitness-gurus-challenger.appspot.com/o/defaultImages%2FuserProfile%2Fblank-profile-picture-973460_1280.png?alt=media&token=d4bc1771-ec47-4617-a8d8-5430b7f0fe4f",
      this.darkThemeFlag = false,
      this.bio = "Add a bio"});

  bool userFormInfoEquivalent(AppUser other) {
    if (this.bio == other.bio &&
        this.firstName == other.firstName &&
        this.lastName == other.lastName &&
        this.profileImageUrl == other.profileImageUrl) {
      return true;
    } else {
      return false;
    }
  }

  AppUser clone() {
    AppUser c = AppUser(
      uid: this.uid,
      firstName: this.firstName,
      lastName: this.lastName,
      profileImageUrl: this.profileImageUrl,
      darkThemeFlag: this.darkThemeFlag,
      bio: this.bio,
    );

    c.favorites = this.favorites;

    return c;
  }

  List<String> getKeysThatDifferFromUpdateInfoForm(AppUser other) {
    List<String> keys = [];

    if (this.firstName != other.firstName) {
      keys.add('firstName');
    }

    if (this.lastName != other.lastName) {
      keys.add('lastName');
    }

    if (this.profileImageUrl != other.profileImageUrl) {
      keys.add('profileImageUrl');
    }

    if (this.bio != other.bio) {
      keys.add('bio');
    }

    return keys;
  }

  Map<String, dynamic> toMap() {
    List<MapEntry<String, dynamic>> entries = [];

    entries.add(MapEntry('uid', this.uid));
    entries.add(MapEntry('firstName', this.firstName));
    entries.add(MapEntry('lastName', this.lastName));
    entries.add(MapEntry('profileImageUrl', this.profileImageUrl));
    entries.add(MapEntry('darkThemeFlag', this.darkThemeFlag));
    entries.add(MapEntry('bio', this.bio));
    entries.add(MapEntry('favorites', this.favorites));

    return Map.fromEntries(entries);
  }

  AppUser.fromFirebaseDoc(DocumentSnapshot doc) {
    if (doc != null) {
      // print('making app user');
      //print(doc.data());

      this.uid = doc.data()['uid'];
      this.bio = doc.data()['bio'];
      this.darkThemeFlag = doc.data()['darkThemeFlag'];
      this.firstName = doc.data()['firstName'];
      this.lastName = doc.data()['lastName'];
      this.profileImageUrl = doc.data()['profileImageUrl'];

      // Get favorites and add to AppUser
      // print('getting favorites');

      List favoritesDoc = doc.get('favorites');

      // Skip initial blank entry
      if (favoritesDoc.length > 1) {
        // print(favoritesDoc.length);
        for (int i = 1; i < favoritesDoc.length; i++) {
          this.favorites.add(FavoriteDTO(
              cid: favoritesDoc[i]['cid'],
              coverUrl: favoritesDoc[i]['coverUrl'],
              title: favoritesDoc[i]['title']));

          // print(favorites.length);
        }
      } else {
        favorites = [];
      }
    } else {
      this.uid = 'temp';
      this.bio = 'temp';
      this.darkThemeFlag = false;
      this.favorites = [];
      this.firstName = 'temp';
      this.lastName = 'temp';
      this.profileImageUrl =
          "https://firebasestorage.googleapis.com/v0/b/fitness-gurus-challenger.appspot.com/o/defaultImages%2FuserProfile%2Fblank-profile-picture-973460_1280.png?alt=media&token=d4bc1771-ec47-4617-a8d8-5430b7f0fe4f";
    }
  }

  bool isFavorite(String cid) {
    // print('is favorite ${favorites.length}');
    for (int i = 0; i < favorites.length; i++) {
      if (favorites[i].cid == cid) {
        // print('match');
        return true;
      }
    }

    return false;
  }
}
