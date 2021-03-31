/*
  File Name: api_credentials.dart 
  Description: This class is to abstract getting api credentials so that 
    developer api keys and credentials remain confidential.
  
  Citation(s):
    1. Sócrates Díaz Severino, "Storing your secret keys in Flutter"
      https://medium.com/@sokrato/storing-your-secret-keys-in-flutter-c0b9af1c0f69
      Assisted with structure of get methods for abstracting api credentials. 
*/

import 'dart:convert' show json;
import 'package:fitness_gurus_challenger/models/twitter_api_credentials.dart';
import 'package:flutter/services.dart' show rootBundle;

class APICredentials {
  static const String _API_CREDENTIAL_PATH = "assets/secret/api_keys.json";

  // Twitter api credentials
  Future get twitterConsumerKey {
    return rootBundle.loadStructuredData<TwitterAPICredentials>(
        _API_CREDENTIAL_PATH,
        (jsonStr) async =>
            TwitterAPICredentials.fromJson(json.decode(jsonStr)));
  }
}
