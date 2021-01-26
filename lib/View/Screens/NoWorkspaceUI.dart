import 'package:crystal_classifier/Controller/States.dart';
import 'package:crystal_classifier/Controller/WorkspaceController.dart';
import 'package:crystal_classifier/Model/WorkSpace.dart';
import 'package:crystal_classifier/View/Screens/CreateWorkspace_Sheet.dart';
import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:crystal_classifier/View/Utils/AppRoutes.dart';
import 'package:crystal_classifier/View/Widgets/AppTitle.dart';
import 'package:crystal_classifier/View/Widgets/Background.dart';
import 'package:crystal_classifier/View/Widgets/CircularProgressIndicatorWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoWorkSpaceUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Common.ScreenInit(context);
    return InkWell(
      child: Scaffold(
        body: _bodyStack(context),
      ),
      onTap: () {
        _onPress(context);
        //print('Get Started Clikced');
      },
    );
  }

  _bodyStack(BuildContext context) {
    return Stack(
      children: <Widget>[
        BackgroundWidget(),
        _bodyColumn(context),
      ],
    );
  }

  _bodyColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Center(child: AppTitle()),
        Center(
          child: Image.asset('assets/images/bookIcon.png'),
        ),
        ((Provider.of<WorkSpaceController>(context)
                        .getWorkspaceCurrentState() ==
                    WorkspaceState.Fetching_All_Workspaces) ||
                (Provider.of<WorkSpaceController>(context)
                        .getWorkspaceCurrentState() ==
                    WorkspaceState.Uninitialized))
            ? Container()
            //  CircularProgressIndicatorWidget(color: whiteColor,)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      'No Workspaces Found',
                      style: TextStyle(fontSize: Common.getSPfont(24)),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Touch any where to get started',
                      style: TextStyle(
                          fontSize: Common.getSPfont(18),
                          color: whiteColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
      ],
    );
  }

  _onPress(BuildContext context) {
    AppRoutes.bottomSheetOpen(context, CreateWorkSpaceUI());
  }
}
