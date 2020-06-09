import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:flutter/material.dart';

class CardBackground extends StatelessWidget {
  final Widget child;
  BorderRadius borderRadius =BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0),
              );
  CardBackground({@required this.child,this.borderRadius});
  @override
  Widget build(BuildContext context) {
    return Container(
      width:  MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height*0.40,
      decoration: BoxDecoration(
            color: greyColor0,
             borderRadius: borderRadius
          ),
      child: child,
    );
  }
}