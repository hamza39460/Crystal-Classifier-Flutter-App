import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:crystal_classifier/Model/Result.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;
import 'package:tflite/tflite.dart';

class Analyzer {
  Result _result;
  analyzeImage(File image) async {
    try {
      String res = await Tflite.loadModel(
          model: "assets/tflite/model.tflite",
          labels: "assets/tflite/labels.txt",
          numThreads: 1, // defaults to 1
          isAsset:
              true, // defaults to true, set to false to load resources outside assets
          useGpuDelegate:
              false // defaults to false, set to true to use GPU delegate
          );
      var result = await _classifyImage(image);
      Tflite.close();
      _result = Result(
          image: image,
          crystalClass: result[0]["label"],
          accuracy: result[0]["confidence"],
          dateTime: _formatDate(DateTime.now()));
    } catch (e) {
      throw e;
    }
  }

  _classifyImage(File image) async {
    var imageBytes = (await rootBundle.load(image.path)).buffer;
    img.Image oriImage = img.decodeJpg(imageBytes.asUint8List());
    img.Image resizedImage = img.copyResize(oriImage, height: 599, width: 599);
    var recognitions = await Tflite.runModelOnBinary(
        binary: imageToByteListFloat32(resizedImage, 599, 0, 255), // required
        numResults: 6, // defaults to 5
        threshold: 0.05, // defaults to 0.1
        asynch: true // defaults to true
        );
    log('classification $recognitions');
    return recognitions;
  }

  _formatDate(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy – HH:mm').add_jm().format(dateTime);
  }

  getResult() => this._result;

  Uint8List imageToByteListFloat32(
      img.Image image, int inputSize, double mean, double std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  Uint8List imageToByteListUint8(img.Image image, int inputSize) {
    var convertedBytes = Uint8List(1 * inputSize * inputSize * 3);
    var buffer = Uint8List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = img.getRed(pixel);
        buffer[pixelIndex++] = img.getGreen(pixel);
        buffer[pixelIndex++] = img.getBlue(pixel);
      }
    }
    return convertedBytes.buffer.asUint8List();
  }
}
