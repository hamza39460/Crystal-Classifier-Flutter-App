import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:flutter/material.dart';

class GoogleButtonWidget extends StatelessWidget {
  Color backgroundColor = whiteColor;
  Function onPress;
  GoogleButtonWidget({@required this.backgroundColor,@required this.onPress});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Material(
        color: transparentColor,
        child: Ink(
          decoration:
          ShapeDecoration(shape: CircleBorder(), color: whiteColor),
              
          child:InkWell(
                      child: CircleAvatar(
              backgroundImage:AssetImage('assets/images/google_light.png'),
              radius: 20,
              backgroundColor: whiteColor,
            ),
            onTap: (){
              onPress(context);
            },
          ),
            
          )
              ),
        );
  }
}