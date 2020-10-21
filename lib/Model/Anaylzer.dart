import 'dart:io';

import 'package:crystal_classifier/Model/Result.dart';

class Analyzer {
  analyzeImage(File image) {
    try {
      //TODO call model to analyze the image
      Result result = Result(
          image: image,
          crystalClass: 'Crystal',
          accuracy: 89.5,
          dateTime: DateTime.now());
      return result;
    } catch (e) {
      throw e;
    }
  }

  _enhanceImage(File image) {
    //TODO
  }
}
