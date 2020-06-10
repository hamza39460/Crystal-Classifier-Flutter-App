import 'package:crystal_classifier/Controller/UserController.dart';
import 'package:crystal_classifier/View/Screens/CreateWorkspace_Sheet.dart';
import 'package:crystal_classifier/View/Screens/UserProfileUI.dart';
import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:crystal_classifier/View/Utils/appRoutes.dart';
import 'package:crystal_classifier/View/Widgets/AppTitle.dart';
import 'package:crystal_classifier/View/Widgets/Background.dart';
import 'package:crystal_classifier/View/Widgets/BottomNavigationBarWidget.dart';
import 'package:flutter/material.dart';

import '../Utils/appRoutes.dart';
import 'WorkspaceUI.dart';




class AllWorkSpacesUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body:_bodyStack(context),
    );
    // Common.ScreenInit(context);
    // return Scaffold(
    //   body: _bodyStack(context),
    //   bottomNavigationBar: BottomNavBarWidget(
    //     callBack: (int i) {
    //       print('bottom nav bar callback:$i');
    //       if(i==2){
    //         AppRoutes.push(context, UserProfileUI());
    //       }
    //     },
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     child: Icon(Icons.add),
    //     backgroundColor: mosqueColor1,
    //     onPressed: () {
    //       _addWorkspacePress(context);
    //     },
    //   ),
    //   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    // );
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
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: AppTitle(),
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 14.0, top: 20),
                  child: Text(
                    'All Workspaces',
                    style: TextStyle(
                        fontSize: Common.getSPfont(26),
                        fontWeight: FontWeight.bold,
                        color: whiteColor),
                  ),
                )),
            _WorkspaceList(),
            // Align(
            //   alignment: Alignment.bottomRight,
            //               child: FlatButton(
            //     child: Text('LOGOUT',style: TextStyle(color: whiteColor),),
            //     onPressed: (){
            //       UserController.init().signOut();
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  void _addWorkspacePress(BuildContext context) {
    AppRoutes.bottomSheetOpen(context, CreateWorkSpaceUI());
  }
}

class _WorkspaceList extends StatelessWidget {
  final _workspacesName = [
    'ABC',
    'DEF',
    'GHI',
    'JKL',
    'MNO',
    'PQR',
    'STU',
    'VWX'
  ];
  final _dateCreated = [
    '02 May, 2020',
    '02 May, 2020',
    '02 May, 2020',
    '02 May, 2020',
    '02 May, 2020',
    '02 May, 2020',
    '02 May, 2020',
    '02 May, 2020'
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        physics: ClampingScrollPhysics(),
        itemCount: _workspacesName.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
                      child: Card(
              child: ListTile(
                title: Text(
                  _workspacesName[index],
                  style: TextStyle(
                      fontSize: Common.getSPfont(18), color: blackColor),
                ),
                subtitle: Text('Created on:${_dateCreated[index]}',
                    style: TextStyle(
                        fontSize: Common.getSPfont(15), color: greyColor1)),
                trailing: Icon(Icons.navigate_next),
              ),
            ),
            onTap: ()=>AppRoutes.push(context, WorkspaceUI())
          );
        },
      ),
    );
  }
}
