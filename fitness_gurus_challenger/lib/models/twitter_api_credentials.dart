/*
  File Name: twitter_api_credentials.dart  
  Description: This class abstracts a twitter api credential for bundle loading. 
*/

class TwitterAPICredentials {
  final String consumerKey;
  final String consumerSecret;

  TwitterAPICredentials({this.consumerKey, this.consumerSecret});

  factory TwitterAPICredentials.fromJson(Map<String, dynamic> jsonMap) {
    return TwitterAPICredentials(
        consumerKey: jsonMap["twitter_consumer_key"],
        consumerSecret: jsonMap["twitter_consumer_secret"]);
  }
}
