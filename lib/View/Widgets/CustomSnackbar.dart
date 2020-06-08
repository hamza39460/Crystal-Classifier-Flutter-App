import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar{
  String text;
  static final CustomSnackbar _selfInstance = CustomSnackbar._internal();
  CustomSnackbar._internal();
  factory CustomSnackbar(){
    return _selfInstance;
  }

  showError(String text){
    showSnackbar('Error', text, Colors.white, Colors.red);
  }
  showSuccess(String text){
    showSnackbar('Done', text, Colors.white, Colors.green);
  }
  showSnackbar(String title,String message, Color textColor, Color bgColor){
    Get.snackbar(title, message,isDismissible: true,duration: (Duration(seconds: 3)),colorText: textColor,backgroundColor: bgColor,snackStyle: SnackStyle.GROUNDED,snackPosition:SnackPosition.BOTTOM   );
  }
}