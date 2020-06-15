import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crystal_classifier/Controller/FirebaseController.dart';
import 'package:crystal_classifier/Controller/UserController.dart';
import 'package:crystal_classifier/Model/WorkspaceDescriptor.dart';

class Workspace {
  List<WorkspaceDescriptor> workspaceList;
  static final FirebaseController _firebaseController =  FirebaseController.init();

  Workspace.init();

  createWorkspace(String name, String description, String dateCreated,String email) async {
    WorkspaceDescriptor descriptor = WorkspaceDescriptor.init(name, description, dateCreated);
    bool response = await _firebaseController.createWorkSpace(descriptor,email);
    return response;
  }

  fetchAllWorkspaces(String email)async{
    workspaceList = List<WorkspaceDescriptor>();
    bool response = await _firebaseController.fetchAllWorkspaces(workspaceList,email);
    print('workspaceList ${workspaceList.length}');
    return response;
  }

  getWorkSpaceList()=>workspaceList;

}