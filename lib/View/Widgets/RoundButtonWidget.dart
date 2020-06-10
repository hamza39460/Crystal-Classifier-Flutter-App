import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:flutter/material.dart';

class RoundButtonWidget extends StatelessWidget {
  IconData icon;
  Color backgroundColor = whiteColor;
  Color iconColor = mosqueColor1;
  Function onPress;
  RoundButtonWidget({@required this.icon,@required this.iconColor,@required this.backgroundColor,@required this.onPress});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Material(
        color: transparentColor,
        child: Ink(
          decoration:
              ShapeDecoration(shape: CircleBorder(), color: backgroundColor),
          child: IconButton(
              icon: Icon(
                icon,
                color: iconColor,
                size: 30,
              ),
              onPressed: () {
                Common.closeKeyboard(context);
                onPress(context);
                //AppRoutes.pop(context);
              }),
        ),
      ),
    );
  }
}
