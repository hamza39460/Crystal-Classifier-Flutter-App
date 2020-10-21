import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  Text text;
  List<Color> gradientColor;
  Function onPress;
  bool isWhite;
  ButtonWidget(
      {@required this.text,
      @required this.onPress,
      this.gradientColor,
      this.isWhite = false});
  @override
  Widget build(BuildContext context) {
    this.gradientColor ??=
        isWhite ? [whiteColor, greyColor1] : [mosqueColor2, mosqueColor1];
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      //height: MediaQuery.of(context).size.height * 0.10,
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 8),
      child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: text,
            ),
          ),
          onPressed: () {
            Common.closeKeyboard(context);
            onPress(context);
          }),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: this.gradientColor,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.3, 0.9],
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: (shadowColor != null) ? shadowColor : whiteColor,
        //     blurRadius: (shadowColor != null) ? 10 : 0,
        //     spreadRadius: 0,
        //     offset: (shadowColor != null) ? Offset(0.0, 5.0) : Offset(0, 0),
        //   ),
        //],
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
