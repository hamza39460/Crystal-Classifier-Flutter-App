import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Widgets/Background.dart';
import 'package:crystal_classifier/View/Widgets/CircularProgressIndicatorWidget.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BackgroundWidget(),
        Center(child: CircularProgressIndicatorWidget(color: whiteColor,))
      ],
    );
  }
}