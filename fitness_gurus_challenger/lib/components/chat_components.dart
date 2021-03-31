import 'package:flutter/material.dart';

Color myGreen = Color(0xff4bb17b);
enum MessageType { sent, received }

List<Map<String, dynamic>> friendsList = [
  {
    'imgUrl':
        'https://cdn.pixabay.com/photo/2019/11/06/17/26/gear-4606749_960_720.jpg',
    'username': 'Runner',
    'lastMsg': 'Hi, would you like to be part of a group workout?',
    'seen': true,
    'hasUnSeenMsgs': false,
    'unseenCount': 0,
    'lastMsgTime': '18:44',
    'isOnline': false
  },
  {
    'imgUrl':
        'https://cdn.pixabay.com/photo/2019/11/06/17/26/gear-4606749_960_720.jpg',
    'username': 'Boxer',
    'lastMsg': 'Hi, would you like to be part of a group workout?',
    'seen': false,
    'hasUnSeenMsgs': false,
    'unseenCount': 0,
    'lastMsgTime': '15 mins ago',
    'isOnline': false
  },
  {
    'imgUrl':
        'https://cdn.pixabay.com/photo/2019/11/05/08/52/adler-4603104_960_720.jpg',
    'username': 'Weightlifter',
    'lastMsg': 'Hi, would you like to be part of a group workout?',
    'seen': false,
    'hasUnSeenMsgs': true,
    'unseenCount': 3,
    'lastMsgTime': '2 hours ago',
    'isOnline': false
  },
  {
    'imgUrl':
        'https://cdn.pixabay.com/photo/2015/02/04/08/03/baby-623417_960_720.jpg',
    'username': 'Powerlifter',
    'lastMsg': 'Hi, would you like to be part of a group workout?',
    'seen': true,
    'hasUnSeenMsgs': true,
    'unseenCount': 2,
    'lastMsgTime': '12 hours ago',
    'isOnline': false
  },
  {
    'imgUrl':
        'https://cdn.pixabay.com/photo/2019/11/06/17/26/gear-4606749_960_720.jpg',
    'username': 'Canoe Guy',
    'lastMsg': 'Hi, would you like to be part of a group workout?',
    'seen': false,
    'hasUnSeenMsgs': true,
    'unseenCount': 4,
    'lastMsgTime': 'Nov 2',
    'isOnline': false
  },
  {
    'imgUrl':
        'https://cdn.pixabay.com/photo/2015/01/08/18/29/entrepreneur-593358_960_720.jpg',
    'username': 'Cross Country Runner',
    'lastMsg': 'Hi, would you like to be part of a group workout?',
    'seen': false,
    'hasUnSeenMsgs': false,
    'unseenCount': 0,
    'lastMsgTime': 'Nov 6',
    'isOnline': false
  },
  {
    'imgUrl':
        'https://cdn.pixabay.com/photo/2015/01/08/18/29/entrepreneur-593358_960_720.jpg',
    'username': 'Crossfit Guy',
    'lastMsg': 'Hi, would you like to be part of a group workout?',
    'seen': false,
    'hasUnSeenMsgs': true,
    'unseenCount': 3,
    'lastMsgTime': 'Nov 8',
    'isOnline': false
  }
];

List<Map<String, dynamic>> messages = [
  {
    'status': MessageType.received,
    'contactImgUrl':
        'https://cdn.pixabay.com/photo/2015/01/08/18/29/entrepreneur-593358_960_720.jpg',
    'contactName': 'Brian',
    'message': 'Hey, I heard you broke the record on this pull-up challenge!',
    'time': '08:43 AM'
  },
  {
    'status': MessageType.sent,
    'message': 'Yes, I did 50 consecutive pullups, Im so proud!',
    'time': '08:45 AM'
  },
  {
    'status': MessageType.sent,
    'message': 'Whats your workout plan? Can I workout with you next time?',
    'time': '08:45 AM'
  },
  {
    'status': MessageType.received,
    'contactImgUrl':
        'https://cdn.pixabay.com/photo/2015/01/08/18/29/entrepreneur-593358_960_720.jpg',
    'contactName': 'Client',
    'message': 'Sure man, Ill show you what I do.',
    'time': '08:47 AM'
  },
  {
    'status': MessageType.sent,
    'message': 'Sweet, looking forward to getting jacked.',
    'time': '08:45 AM'
  },
];
