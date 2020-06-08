import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: mosqueColor1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30,0,0),
          child: Image.asset('assets/images/bgImage.png',
          width: MediaQuery.of(context).size.width,
          ),
          
        ),
      ],
    );
  }
}