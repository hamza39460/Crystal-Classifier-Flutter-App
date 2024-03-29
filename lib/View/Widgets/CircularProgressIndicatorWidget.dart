import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:flutter/material.dart';

class CircularProgressIndicatorWidget extends StatelessWidget {
  Color color = mosqueColor1;
  CircularProgressIndicatorWidget({this.color});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 4,
        valueColor: new AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
