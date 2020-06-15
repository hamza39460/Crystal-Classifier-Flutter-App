import 'package:crystal_classifier/Controller/States.dart';
import 'package:crystal_classifier/Controller/UserController.dart';
import 'package:crystal_classifier/Model/WorkSpace.dart';
import 'package:crystal_classifier/Model/WorkspaceDescriptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class WorkSpaceController extends ChangeNotifier {
  static final WorkSpaceController _selfInstance =WorkSpaceController._internal();
  static final Workspace _workspace = Workspace.init();
  WorkspaceState workspaceCurrentState = WorkspaceState.Uninitialized;
  WorkSpaceController._internal(){
    /** 
     * @Author: hamza 
     * @Date: 2020-05-12 22:43:26 
     * @Desc: Internal Constructor for UserController Class 
     */
  }
  
  factory WorkSpaceController.init(){
    return _selfInstance;
  }

  createWorkSpace(String name, String description) async {
    bool response = await _workspace.createWorkspace(name, description, getTodaysDate(),UserController.init().getUserDetails()['Email']);
    if(response  == true){
       
    }
    else{

    }
  }

  changeCurrentWorkSpace(String name){

  }

  fetchAllWorkspaces() async {
    workspaceCurrentState = WorkspaceState.Fetching_All_Workspaces;
    notifyListeners();
    bool response = await _workspace.fetchAllWorkspaces(UserController.init().getUserDetails()['Email']);
    if(response=true){
      if(getWorkSpaceList().length==0)
          {
          workspaceCurrentState =  WorkspaceState.No_Workspace_found;
          }
      else 
          workspaceCurrentState = WorkspaceState.ALl_Workspaces_Fetched;
      notifyListeners();
    }
    else{
      workspaceCurrentState = WorkspaceState.Error;
      notifyListeners();
    }
  }

  List<WorkspaceDescriptor>getWorkSpaceList(){
    return _workspace.getWorkSpaceList();
  }

  deleteWorkSpace(String name){

  }

  updateWorkSpaceDetails(String name, String description){

  }

  generateReport(){

  }

  addResult(){

  }
  
  getAllResults(){

  }

  getTodaysDate(){
    DateTime today = DateTime.now();
    String formatDate = DateFormat('d-MMM-yyyy').format(today);
    return formatDate;
  }

  getWorkspaceCurrentState()=>workspaceCurrentState;
}