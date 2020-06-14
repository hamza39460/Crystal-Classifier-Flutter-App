import 'package:crystal_classifier/Controller/States.dart';
import 'package:crystal_classifier/Controller/WorkspaceController.dart';
import 'package:crystal_classifier/View/Screens/AllWorkspacesUI.dart';
import 'package:crystal_classifier/View/Screens/LoadingScreen.dart';
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
          print("Workspace state ${workSpaceController.getWorkspaceCurrentState()}");
          switch(workSpaceController.getWorkspaceCurrentState()){
            case WorkspaceState.Uninitialized:
            case WorkspaceState.Fetching_All_Workspaces:
                return LoadingScreen();
            case WorkspaceState.No_Workspace_found:
            case WorkspaceState.ALl_Workspaces_Fetched:
            case WorkspaceState.Error:
                return AllWorkSpacesUI();
          }
        }),
      ),
    );
  }
}