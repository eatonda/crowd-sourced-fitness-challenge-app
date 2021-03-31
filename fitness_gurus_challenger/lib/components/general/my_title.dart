import 'package:flutter/material.dart';

class MyTitle extends StatelessWidget {
  final title;

  MyTitle({@required this.title});

  @override
  Widget build(BuildContext context) {
    final _topSpacing = MediaQuery.of(context).size.width * .025;
    final _bottomSpacing = MediaQuery.of(context).size.width * .1;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: _topSpacing,
          ),
          Text(
            "Fitness Gurus Challenge",
            style: TextStyle(
                fontFamily: 'Bangers', fontSize: 24, color: Colors.redAccent),
          ),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          SizedBox(
            height: _bottomSpacing,
          ),
        ],
      ),
    );
  }
}
