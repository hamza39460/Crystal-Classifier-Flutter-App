import 'dart:async';
import 'dart:developer';

import 'package:crystal_classifier/Controller/States.dart';
import 'package:crystal_classifier/Controller/UserController.dart';
import 'package:crystal_classifier/Model/Result.dart';
import 'package:crystal_classifier/Model/UserDescriptor.dart';
import 'package:crystal_classifier/Model/WorkSpace.dart';
import 'package:crystal_classifier/Model/WorkspaceDescriptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class WorkSpaceController extends ChangeNotifier {
  static final WorkSpaceController _selfInstance =
      WorkSpaceController._internal();
  static final Workspace _workspace = Workspace.init();
  WorkspaceState _workspaceCurrentState = WorkspaceState.Uninitialized;
  WorkSpaceController._internal() {
    /** 
     * @Author: hamza 
     * @Date: 2020-05-12 22:43:26 
     * @Desc: Internal Constructor for UserController Class 
     */
  }

  factory WorkSpaceController.init() {
    return _selfInstance;
  }

  createWorkSpace(String name, String description) async {
    _workspaceCurrentState = WorkspaceState.Fetching_All_Workspaces;
    notifyListeners();
    bool response = await _workspace.createWorkspace(name, description,
        getTodaysDate(), UserController.init().getUserDetails()['Email']);
    if (response == true) {
      _workspaceCurrentState = WorkspaceState.ALl_Workspaces_Fetched;
      notifyListeners();
    } else {
      _workspaceCurrentState = WorkspaceState.Error;
      notifyListeners();
    }
  }

  fetchAllWorkspaces() async {
    _workspaceCurrentState = WorkspaceState.Fetching_All_Workspaces;
    notifyListeners();
    bool response = await _workspace
        .fetchAllWorkspaces(UserController.init().getUserDetails()['Email']);
    if (response == true) {
      log('workspace ${getWorkSpaceList().length}');
      if (getWorkSpaceList().length == 0) {
        _workspaceCurrentState = WorkspaceState.No_Workspace_found;
      } else
        _workspaceCurrentState = WorkspaceState.ALl_Workspaces_Fetched;
      notifyListeners();
    } else {
      _workspaceCurrentState = WorkspaceState.Error;
      notifyListeners();
    }
  }

  List<WorkspaceDescriptor> getWorkSpaceList() {
    return _workspace.getWorkSpaceList();
  }

  deleteWorkSpace(WorkspaceDescriptor workspaceDescriptor) async {
    bool response = await _workspace.deleteWorkspace(
        workspaceDescriptor, UserController.init().getUserDetails()['Email']);
    if (response == true) {
      if (getWorkSpaceList().length == 0) {
        _workspaceCurrentState = WorkspaceState.No_Workspace_found;
        notifyListeners();
      }
    }
    return response;
  }

  updateWorkSpaceDetails(WorkspaceDescriptor workspaceDescriptor, String name,
      String description) async {
    workspaceDescriptor.setName(name);
    workspaceDescriptor.setDescription(description);
    return await _workspace.updateWorkspace(
        workspaceDescriptor, UserController.init().getUserDetails()['Email']);
  }

  generateReport() {}

  getTodaysDate() {
    DateTime today = DateTime.now();
    String formatDate = DateFormat('MMM d, yyyy').format(today);
    return formatDate;
  }

  setWorkspaceState(WorkspaceState workspaceState) {
    this._workspaceCurrentState = workspaceState;
  }

  setWorkspaceStateAndNotify(WorkspaceState workspaceState) {
    this._workspaceCurrentState = workspaceState;
    notifyListeners();
  }

  getWorkspaceCurrentState() => _workspaceCurrentState;
}
