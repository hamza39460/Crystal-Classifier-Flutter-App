import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Crystal Classifier',style: TextStyle(fontSize: Common.getSPfont(35),color: mosqueColor0,fontFamily:'Righteous'),)
    );
  }
}