import 'package:crystal_classifier/View/Screens/AllWorkspacesUI.dart';
import 'package:crystal_classifier/View/Screens/CreateWorkspace_Sheet.dart';
import 'package:crystal_classifier/View/Screens/UserProfileUI.dart';
import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:crystal_classifier/View/Utils/appRoutes.dart';
import 'package:crystal_classifier/View/Widgets/BottomNavigationBarWidget.dart';
import 'package:flutter/material.dart';

class HomeUI extends StatefulWidget {
  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  Widget _currentView = AllWorkSpacesUI();
  @override
  Widget build(BuildContext context) {
    Common.ScreenInit(context);
    
    return Scaffold(
      body: _currentViewFunction(),
      bottomNavigationBar: BottomNavBarWidget(
        callBack: (int i) {
          print('bottom nav bar callback:$i');
          if(i==0){
            setState(() {
              _currentView=AllWorkSpacesUI();
            });
          }
          if(i==2){
            setState(() {
              _currentView=UserProfileUI();
            });
          }
        },
      ),
      floatingActionButton: Visibility(
        visible:  (_currentView is AllWorkSpacesUI)?true:false,
              child: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: mosqueColor1,
          onPressed: () {
            (_currentView is AllWorkSpacesUI) ? _addWorkspacePress(context):DoNothingAction();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _addWorkspacePress(BuildContext context) {
    AppRoutes.bottomSheetOpen(context, CreateWorkSpaceUI());
  }

  _currentViewFunction(){
    return _currentView;
  }
}