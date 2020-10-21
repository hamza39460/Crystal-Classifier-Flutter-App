import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';

class Result {
  File _image;
  String _class;
  double _accuracy;
  DateTime _dateTime;
  String _imageFirebasePath;
  Result(
      {@required File image,
      @required String crystalClass,
      @required double accuracy,
      @required DateTime dateTime})
      : _image = image,
        _class = crystalClass,
        _accuracy = accuracy,
        _dateTime = dateTime;
  Result.two(
      {@required String image,
      @required String crystalClass,
      @required double accuracy,
      @required DateTime dateTime})
      : _imageFirebasePath = image,
        _class = crystalClass,
        _accuracy = accuracy,
        _dateTime = dateTime;

  setImageFirebasePath(String firebasePath) {
    this._imageFirebasePath = firebasePath;
  }

  File getImage() => _image;
  String getImagePath() => _imageFirebasePath;
  Map<String, dynamic> toJson() {
    return {
      'Image Path': this._imageFirebasePath,
      'Class': this._class,
      'Accuracy': this._accuracy,
      'DateTime': this._dateTime,
    };
  }

  static fromJson(Map<String, dynamic> json) {
    return Result.two(
        image: json['Image Path'],
        crystalClass: json['Class'],
        accuracy: json['Accuracy'],
        dateTime: json['DateTime'].toDate());
  }

  getClass() => _class;

  getDate() => _dateTime.toIso8601String();

  getAccuracy() => _accuracy;
}
