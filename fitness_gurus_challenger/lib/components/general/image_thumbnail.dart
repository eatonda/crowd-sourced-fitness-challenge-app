import 'package:flutter/material.dart';

class ImageThumbnail extends StatelessWidget {
  final imageUrl;

  ImageThumbnail({@required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Selected image:'),
        SizedBox(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
          width: 50.0,
          height: 50.0,
        ),
      ],
    ));
  }
}
