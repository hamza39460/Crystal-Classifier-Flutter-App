import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crystal_classifier/Controller/FirebaseController.dart';
import 'package:crystal_classifier/Controller/UserController.dart';
import 'package:crystal_classifier/Model/Result.dart';
import 'package:crystal_classifier/Model/UserDescriptor.dart';
import 'package:crystal_classifier/Model/WorkspaceDescriptor.dart';

class Workspace {
  List<WorkspaceDescriptor> _workspaceList;
  static final FirebaseController _firebaseController =
      FirebaseController.init();

  Workspace.init();

  createWorkspace(
      String name, String description, String dateCreated, String email) async {
    WorkspaceDescriptor descriptor =
        WorkspaceDescriptor.init(name, description, dateCreated);
    bool response =
        await _firebaseController.createWorkSpace(descriptor, email);
    if (response == true) {
      _workspaceList.add(descriptor);
    }
    return response;
  }

  updateWorkspace(WorkspaceDescriptor workspaceDescriptor, String email) async {
    return await _firebaseController.updateWorkspace(workspaceDescriptor);
  }

  fetchAllWorkspaces(String email) async {
    _workspaceList = List<WorkspaceDescriptor>();
    bool response =
        await _firebaseController.fetchAllWorkspaces(_workspaceList);
    print('workspaceList0 ${_workspaceList.length}');
    return response;
  }

  deleteWorkspace(WorkspaceDescriptor workspaceDescriptor, String email) async {
    bool response =
        await _firebaseController.deleteWorkspace(workspaceDescriptor);
    if (response == true) _workspaceList.remove(workspaceDescriptor);
    return response;
  }

  getWorkSpaceList() => _workspaceList;
}
