import 'package:flutter/material.dart';

class CustomerButton extends StatelessWidget {
  CustomerButton(
      {@required this.onPressed,
      this.text,
      this.focusColor,
      this.disbaleColor});

  final GestureTapCallback onPressed;
  final Text text;
  final Color focusColor, disbaleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      height: MediaQuery.of(context).size.height / 16,
      // ignore: deprecated_member_use
      child: RaisedButton(
        focusColor: focusColor,
        disabledColor: disbaleColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          // side: BorderSide(
          //   color: button1,
          // )
        ),
        color: Color(0xff335078),
        textColor: Colors.white,
        //padding: EdgeInsets.all(8.0),
        onPressed: onPressed,
        child: text,
      ),
    );
  }
}
