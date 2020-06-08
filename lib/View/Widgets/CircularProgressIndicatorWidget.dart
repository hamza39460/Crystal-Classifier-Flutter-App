import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:flutter/material.dart';

class CircularProgressIndicatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: 4,
      valueColor: new AlwaysStoppedAnimation<Color>(mosqueColor1),
    );
  }
}