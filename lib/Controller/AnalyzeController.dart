import 'dart:developer';
import 'dart:io';

import 'package:crystal_classifier/Model/Anaylzer.dart';
import 'package:crystal_classifier/Model/Result.dart';

class AnalyzeController {
  static final _selfInstace = AnalyzeController._internal();
  AnalyzeController._internal();
  
  static final _analyzer = Analyzer();

  factory AnalyzeController.init() {
    return _selfInstace;
  }

  analyze(File image) async {
    try {
      await _analyzer.analyzeImage(image);
      return true;
    } catch (e) {
      log('analyzing error $e');
      return false;
    }
  }


  getResult() => _analyzer.getResult();
}
