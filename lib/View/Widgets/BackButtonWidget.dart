import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:crystal_classifier/View/Utils/appRoutes.dart';
import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: whiteColor,
            size: 30,
          ),
          onPressed: () {
            Common.closeKeyboard(context);
            AppRoutes.pop(context);
          }),
    );
  }
}
