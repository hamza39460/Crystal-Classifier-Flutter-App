import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:flutter/material.dart';

class RoundButtonWidget extends StatelessWidget {
  IconData icon;
  Color backgroundColor;
  Color iconColor;
  Function onPress;
  bool isWhite;
  List<Color> gradientColor;
  RoundButtonWidget(
      {@required this.icon,
      @required this.iconColor,
      @required this.onPress,
      this.gradientColor,
      this.isWhite = false});
  @override
  Widget build(BuildContext context) {
    this.gradientColor ??=
        isWhite ? [whiteColor, greyColor1] : [mosqueColor2, mosqueColor1];
    return Container(
      alignment: Alignment.center,
      child: Material(
        color: transparentColor,
        child: Ink(
          decoration: ShapeDecoration(
            shape: CircleBorder(),
            gradient: LinearGradient(
              colors: this.gradientColor,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.3, 0.9],
            ),
          ),
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
