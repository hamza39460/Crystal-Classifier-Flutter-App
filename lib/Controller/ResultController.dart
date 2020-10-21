import 'dart:async';

import 'package:crystal_classifier/Controller/FirebaseController.dart';
import 'package:crystal_classifier/Model/Result.dart';
import 'package:crystal_classifier/Model/UserDescriptor.dart';
import 'package:crystal_classifier/Model/WorkspaceDescriptor.dart';

enum ResultState {
  Fetching,
  Fetched,
  NoData,
}

class ResultController {
  StreamController<ResultState> _streamController = StreamController();
  static final FirebaseController _firebaseController =
      FirebaseController.init();
  StreamController getStreamController() => _streamController;

  List<Result> _results;
  getAllResults(
      WorkspaceDescriptor workspaceDescriptor, String userEmail) async {
    _streamController.add(ResultState.Fetching);
    try {
      _results = await _firebaseController.getAllResults(
          workspaceDescriptor, userEmail);
      if (_results.isEmpty) {
        return _streamController.add(ResultState.NoData);
      } else if (_results.isNotEmpty)
        return _streamController.add(ResultState.Fetched);
    } on Exception catch (e) {
      return _streamController.addError("Error Occured $e");
    }
  }

  addResult(Result result, UserDescriptor userDescriptor,
      WorkspaceDescriptor workspaceDescriptor) async {
    return await _firebaseController.addResultToFirebase(
        result, userDescriptor, workspaceDescriptor);
  }

  List<Result> getResultList() => _results;
}
