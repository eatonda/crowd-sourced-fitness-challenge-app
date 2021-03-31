class SearchParameters {
  String cid;
  String uid;
  String title;
  String type;
  List<String> tags = [];

  SearchParameters({this.title, this.type, this.cid, this.uid});

  // Returns a list of member names that have been assigned values
  List<String> get keys {
    List<String> keys = [];

    if (title != null) {
      keys.add('title');
    }

    if (type != null) {
      keys.add('type');
    }

    if (tags.isNotEmpty) {
      keys.add('tags');
    }

    if (cid != null) {
      keys.add('cid');
    }

    if (uid != null) {
      keys.add('uid');
    }

    return keys;
  }

  bool isEmpty() {
    if (title == null && type == null && tags.isEmpty)
      return true;
    else
      return false;
  }
}
