import 'dart:io';

import 'package:crystal_classifier/Controller/States.dart';
import 'package:crystal_classifier/Controller/UserController.dart';
import 'package:crystal_classifier/Controller/WorkspaceController.dart';
import 'package:crystal_classifier/View/Screens/AllWorkspacesUI.dart';
import 'package:crystal_classifier/View/Screens/LoadingScreen.dart';
import 'package:crystal_classifier/View/Screens/NoWorkspaceUI.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Common.ScreenInit(context);
    return Scaffold(
      body: ChangeNotifierProvider.value(
        value: WorkSpaceController.init(),
        child: Consumer<WorkSpaceController>(builder: (context,workSpaceController,child){
          debugPrint("Workspace state ${workSpaceController.getWorkspaceCurrentState()}");
          debugPrint("Data state ${Provider.of<UserController>(context).getUserDataState()}");
          switch(workSpaceController.getWorkspaceCurrentState()){
            case WorkspaceState.Uninitialized:
              {
                if(Provider.of<UserController>(context).getUserDataState()==UserDataState.Fetched_User_Data)
                   WorkSpaceController.init().fetchAllWorkspaces();
                return LoadingScreen();
              }
            case WorkspaceState.Fetching_All_Workspaces:
              return LoadingScreen();
              //return LoadingScreen();
            case WorkspaceState.No_Workspace_found:
            case WorkspaceState.Error:
            {
                return NoWorkSpaceUI();
            }
            case WorkspaceState.ALl_Workspaces_Fetched:
                return AllWorkSpacesUI();
          }
        }),
      ),
    );
  }
}