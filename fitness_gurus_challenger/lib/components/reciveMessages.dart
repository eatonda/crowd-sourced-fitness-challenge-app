import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_gurus_challenger/components/mycircleavatar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'mycircleavatar.dart';

class ReceivedMessagesWidget extends StatelessWidget {
  final DocumentSnapshot chatDataInfo;

  const ReceivedMessagesWidget({
    Key key,
    @required this.chatDataInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        children: <Widget>[
          MyCircleAvatar(
            imgUrl: chatDataInfo.data()['senderImg'],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                chatDataInfo.data()['senderName'],
                style: Theme.of(context).textTheme.caption,
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .6),
                decoration: BoxDecoration(
                  color: Color(0xfff9f9f9),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: chatDataInfo.data()['messageType'] == '0'
                    ? Container(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          chatDataInfo.data()['message'],
                          style: Theme.of(context).textTheme.bodyText2.apply(
                                color: Colors.black87,
                              ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(5.0),
                        width: MediaQuery.of(context).size.width / 2,
                        height: 180,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: chatDataInfo.data()["imageUrl"],
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF512B58)),
                              ),
                              width: 50.0,
                              height: 50.0,
                              padding: EdgeInsets.all(15.0),
                            ),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width / 2,
                            height: 150,
                          ),
                        ),
                      ),
              ),
            ],
          ),
          SizedBox(width: 10),
          Text(
            DateFormat().add_jm().format(DateTime.parse(
                chatDataInfo.data()['sentTime'].toDate().toString())),
            style:
                Theme.of(context).textTheme.bodyText1.apply(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
