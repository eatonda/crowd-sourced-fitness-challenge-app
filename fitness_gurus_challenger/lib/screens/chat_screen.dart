import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness_gurus_challenger/components/Colors.dart';
import 'package:fitness_gurus_challenger/components/general/main_app_bar_.dart';
import 'package:fitness_gurus_challenger/components/reciveMessages.dart';
import 'package:fitness_gurus_challenger/components/sentMessages.dart';
import 'package:fitness_gurus_challenger/services/authentication_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = 'chat_screen';
  final String chatRoomId;

  const ChatScreen({Key key, @required this.chatRoomId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //bool _showBottom = false;

  final AuthenticationService authenticationService = AuthenticationService();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getChatRoomInfo();
    getMyInfo();
  }

  Future getMyInfo() async {
    final QuerySnapshot verifyQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: userId)
        .get();
    final List<DocumentSnapshot> _userDataObj = verifyQuery.docs;
    String name = _userDataObj[0].data()['firstName'] +
        " " +
        _userDataObj[0].data()['lastName'];
    String photoUrl = _userDataObj[0].data()['profileImageUrl'];
    setState(() {
      myName = name;
      myPhotoUrl = photoUrl;
    });
    print(myName);
    print(myPhotoUrl);
  }

  getChatRoomInfo() async {
    setState(() {
      userId = _firebaseAuth.currentUser.uid;
    });
    print("$userId");
  }

  String userId;
  String myName;
  String myPhotoUrl;

  // double _width, _height;
  @override
  Widget build(BuildContext context) {
    // _width = MediaQuery.of(context).size.width;
    // _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: MainAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("chatRooms")
                        .doc(widget.chatRoomId)
                        .collection("chats")
                        .orderBy("sentTime", descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Platform.isIOS
                              ? CupertinoActivityIndicator()
                              : CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.data.docs.length < 1) {
                          return Center(
                            child: Text("No Chat Found!"),
                          );
                        } else {
                          return ListView.builder(
                            padding: const EdgeInsets.all(15),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot _chatDataInfo =
                                  snapshot.data.docs[index];
                              print(
                                  "Send by: ${_chatDataInfo.data()["sendBy"]}");
                              if (_chatDataInfo.data()["sendBy"] == userId) {
                                return SentMessageWidget(
                                  chatDataInfo: _chatDataInfo,
                                );
                              } else {
                                return ReceivedMessagesWidget(
                                  chatDataInfo: _chatDataInfo,
                                );
                              }
                            },
                          );
                        }
                      }
                    },
                  ),
                ),
                InputMesssageWiget(
                  chatRoomId: widget.chatRoomId,
                  myName: myName,
                  myPhotoUrl: myPhotoUrl,
                  myUserId: userId,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<IconData> icons = [
  Icons.image,
  Icons.camera,
  Icons.file_upload,
  Icons.folder,
  Icons.gif
];

class InputMesssageWiget extends StatefulWidget {
  final String chatRoomId, myUserId, myName, myPhotoUrl;

  const InputMesssageWiget({
    Key key,
    @required this.chatRoomId,
    @required this.myName,
    @required this.myPhotoUrl,
    @required this.myUserId,
  }) : super(key: key);
  @override
  _InputMesssageWigetState createState() => _InputMesssageWigetState();
}

class _InputMesssageWigetState extends State<InputMesssageWiget> {
  TextEditingController _textChatController = TextEditingController();
  Future sendTextMessage(String text) async {
    Map<String, dynamic> chatMap = {
      "message": text,
      "messageType": "0",
      "sendBy": widget.myUserId,
      "senderImg": widget.myPhotoUrl,
      "senderName": widget.myName,
      "sentTime": DateTime.now(),
    };

    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(widget.chatRoomId)
        .collection("chats")
        .add(chatMap)
        .then((value) {
      setState(() {
        _textChatController.text = '';
      });
      print("Text Message has sent!");
    }).catchError((e) {
      print(e);
    });
  }

  bool _isTyping = false;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      height: 61,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35.0),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.attach_file,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      pickChatImage();
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textChatController,
                      style: TextStyle(color: basicCOlor),
                      onChanged: (val) {
                        if (_textChatController.text.length != 0) {
                          setState(() {
                            _isTyping = true;
                          });
                        } else {
                          setState(() {
                            _isTyping = false;
                          });
                        }
                      },
                      decoration: InputDecoration(
                          hintText: "Type Something...",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                    icon: _isUploading
                        ? Container(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(basicCOlor),
                            ),
                          )
                        : Icon(Icons.send,
                            color: _isTyping ? basicCOlor : Colors.grey),
                    onPressed: _isUploading
                        ? null
                        : () {
                            print("pressd");

                            if (_textChatController.text.length != 0) {
                              print("ok");
                              sendTextMessage(_textChatController.text);
                            } else {
                              print("No");
                            }
                          },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 15),
        ],
      ),
    );
  }

  final picker = ImagePicker();
  File _selectedImage;

  void pickChatImage() async {
    try {
      PickedFile image = await picker.getImage(source: ImageSource.gallery);
      setState(() {
        _selectedImage = File(image.path);
      });

      if (_selectedImage != null) {
        setState(() {
          _isUploading = true;
        });

        Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child("chatsImages")
            .child(
                "${widget.myUserId}+${DateTime.now().millisecondsSinceEpoch.toString()}.jpg");

        final TaskSnapshot task =
            await firebaseStorageRef.putFile(_selectedImage);

        var _photoUrl = await task.ref.getDownloadURL();

        Map<String, dynamic> chatMap = {
          "imageUrl": _photoUrl,
          "messageType": "1",
          "sendBy": widget.myUserId,
          "senderImg": widget.myPhotoUrl,
          "senderName": widget.myName,
          "sentTime": DateTime.now(),
        };

        FirebaseFirestore.instance
            .collection("chatRooms")
            .doc(widget.chatRoomId)
            .collection("chats")
            .add(chatMap)
            .then((value) {
          print("Image has sent!");
          setState(() {
            _isUploading = false;
          });
        }).catchError((e) {
          print(e);
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
