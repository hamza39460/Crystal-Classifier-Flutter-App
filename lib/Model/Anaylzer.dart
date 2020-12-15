import 'dart:io';

import 'package:crystal_classifier/Model/Result.dart';
import 'package:intl/intl.dart';

class Analyzer {
  Result _result;
  analyzeImage(File image) {
    try {
      //TODO call model to analyze the image
      _result = Result(
          image: image,
          crystalClass: 'Crystal',
          accuracy: 89.5,
          dateTime: _formatDate(DateTime.now()));
    } catch (e) {
      throw e;
    }
  }

  _classifyImage() {
    //TODO
  }
  _formatDate(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy – HH:mm').add_jm().format(dateTime);
  }

  getResult() => this._result;
}
