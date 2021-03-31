import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_gurus_challenger/components/general/main_app_bar_.dart';
import 'package:fitness_gurus_challenger/models/app_user.dart';
import 'package:fitness_gurus_challenger/models/goal.dart';
import 'package:fitness_gurus_challenger/models/goal_detail_arg.dart';
import 'package:fitness_gurus_challenger/models/hall_arg.dart';
import 'package:fitness_gurus_challenger/services/database_service.dart';
import 'package:fitness_gurus_challenger/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/general/my_title.dart';
import '../models/challenge.dart';
import 'chat_screen.dart';

// ignore: must_be_immutable
class FitnessTracker extends StatefulWidget {
  static const routeName = 'fitness_tracker_screen';

  @override
  _FitnessTrackerState createState() => _FitnessTrackerState();
}

class _FitnessTrackerState extends State<FitnessTracker> {
  final double titleSize = 22;
  final _databaseService = DataBaseService();

  final _navigationService = NavigationService();

  bool isChecked;

  @override
  Widget build(BuildContext context) {
    Challenge dto = ModalRoute.of(context).settings.arguments;
    AppUser appUser =
        AppUser.fromFirebaseDoc(Provider.of<DocumentSnapshot>(context));

    // print(appUser.favorites.length);

    return Scaffold(
      appBar: MainAppBar(),
      body: FutureBuilder(
          future: _databaseService.getGoals(challenge: dto, uid: appUser.uid),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print("done");
              return getTrackerListView(dto, context, appUser);
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  List<Widget> getList() {
    List<Widget> temp = [];
    for (var q = 1; q <= 2; q++) {
      temp.add(TextButton(child: new Text("Location A"), onPressed: null));
    }
    return temp;
  }

  Widget getTrackerListView(
      Challenge dto, BuildContext context, AppUser appUser) {
    // final _spacing = MediaQuery.of(context).size.height / 60;
    final _spacing = MediaQuery.of(context).size.width * .1;
    final widths = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.center,
        child: Column(
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          MyTitle(title: "${dto.title}"),
          MediaQuery.of(context).orientation == Orientation.portrait
              ? SizedBox(
                  width: widths * 0.15,
                )
              : SizedBox(
                  width: widths * 0.30,
                ),
          appUser.isFavorite(dto.cid) == true
              ? IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  onPressed: () =>
                      _databaseService.removeFromFavorites(appUser.uid, dto),
                )
              : IconButton(
                  icon: Icon(Icons.favorite_border_outlined),
                  onPressed: () =>
                      _databaseService.addToFavorites(appUser.uid, dto),
                ),
        ]),
        Container(
          height: 190.0,
          width: SizeConfig._screenWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color(0xff000000),
              image: DecorationImage(
                  image: new NetworkImage(dto.coverUrl), fit: BoxFit.fill)),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: widths / 2.4,
                child: ElevatedButton(
                  child: Text('Chat'),
                  onPressed: () => _checkChatRoom(dto.cid, context),
                  // _navigationService.navigateToChatScreen(context),
                )),
            Container(
                width: widths / 2.4,
                child: ElevatedButton(
                    child: Text('Hall of Fame'),
                    onPressed: () =>
                        _navigationService.navigateToHallOfFameScreen(context,
                            HallArg(challenge: dto, isHallOfFame: true)))),
          ],
        ),
        SizedBox(
          height: _spacing,
        ),
        SizedBox(
          width: widths / 1.1,
          child: Container(
            child: Column(
              children: [
                Text("Type: ", style: TextStyle(fontSize: 22)),
                Text("${dto.type}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        SizedBox(
          height: _spacing,
        ),
        Container(
          child: badgeRow(dto),
        ),
        SizedBox(
          height: _spacing,
        ),
        Container(
          width: widths / 1.1,
          child: description(dto),
        ),
        SizedBox(
          height: _spacing,
        ),
        Text(
          'Goals:',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 22),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: ListView.separated(
            itemCount: dto.goals.length,
            itemBuilder: (context, index) {
              return listTileFromGoal(dto.goals[index], context, dto);
            },
            separatorBuilder: (context, index) => Divider(),
            shrinkWrap: true,
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    ));
  }

  Widget badgeRow(Challenge dto) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('Badge:', style: TextStyle(fontSize: titleSize)),
      Image.network(dto.badgeUrl),
    ]);
  }

  Widget description(Challenge dto) {
    return Column(children: [
      Text("Description: ", style: TextStyle(fontSize: titleSize)),
      Text(dto.description,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )),
    ]);
  }

  Widget listTileFromGoal(
      Goal goal, BuildContext context, Challenge challenge) {
    if (goal.completed) {
      return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            goal.coverUrl,
          ),
        ),
        title: Text(
          goal.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Checkbox(
          value: goal.completed,
          onChanged: null,
        ),
        onTap: () async {
          await _navigationService.navigateToGoalDetailScreen(context,
              GoalDetailArg(goal: goal, isLive: true, challenge: challenge));
          setState(() {});
        },
        tileColor: Colors.green,
      );
    } else {
      return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            goal.coverUrl,
          ),
        ),
        title: Text(
          goal.title,
        ),
        trailing: Checkbox(
          value: goal.completed,
          onChanged: null,
        ),
        onTap: () async {
          await _navigationService.navigateToGoalDetailScreen(context,
              GoalDetailArg(goal: goal, isLive: true, challenge: challenge));
          setState(() {});
        },
        tileColor: Colors.redAccent,
      );
    }
  }

  void _checkChatRoom(String challengeId, BuildContext context) async {
    String userId = FirebaseAuth.instance.currentUser.uid;

    print("$userId");

    try {
      final QuerySnapshot verifyQuery = await FirebaseFirestore.instance
          .collection('chatRooms')
          .where('chatRoomId', isEqualTo: challengeId)
          .get();
      final List<DocumentSnapshot> queryChatRoom = verifyQuery.docs;

      if (queryChatRoom.length != 0) {
        print("Chat Room is available!");
        if (queryChatRoom[0].data()['users'].contains(userId)) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatScreen(chatRoomId: challengeId)));
        } else {
          print("Joined Room!");

          Map<String, dynamic> chatRoomMap = {
            "users": FieldValue.arrayUnion([userId]),
            "chatRoomId": challengeId,
          };

          await DataBaseService()
              .addUserToChatRoom(challengeId, chatRoomMap)
              .then((value) async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(chatRoomId: challengeId)));
          });
        }
      } else {
        Map<String, dynamic> chatRoomMap = {
          "users": [userId],
          "chatRoomId": challengeId,
        };

        await DataBaseService()
            .createChatRoom(challengeId, chatRoomMap)
            .then((value) async {
          print("Created Room!");

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatScreen(chatRoomId: challengeId)));
        });
      }
    } catch (e) {
      print(e);
    }
  }
}

class SizeConfig {
  static double _screenWidth;
  static double _screenHeight;
  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;

  static double textMultiplier;
  static double imageSizeMultiplier;
  static double heightMultiplier;
  static double widthMultiplier;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;

    textMultiplier = _blockSizeVertical;
    imageSizeMultiplier = _blockSizeHorizontal;
    heightMultiplier = _blockSizeVertical;
    widthMultiplier = _blockSizeHorizontal;

    print(_blockSizeHorizontal);
    print(_blockSizeVertical);
  }
}
