import 'package:crystal_classifier/View/Screens/CreateWorkspace_Sheet.dart';
import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:crystal_classifier/View/Utils/appRoutes.dart';
import 'package:crystal_classifier/View/Widgets/AppTitle.dart';
import 'package:crystal_classifier/View/Widgets/Background.dart';
import 'package:flutter/material.dart';

class NoWorkSpaceUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Common.ScreenInit(context);
    return InkWell(
          child: Scaffold(
        body: _bodyStack(context),
      ),
      onTap: (){
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
        Center(child:AppTitle()),
        Center(child: Image.asset('assets/images/bookIcon.png'),),
        Center(child: Text('Did not made any Workspace yet!',style: TextStyle(fontSize: Common.getSPfont(24)),),),
        Center(child: Text('Touch any where to get started',style: TextStyle(fontSize: Common.getSPfont(18),color: whiteColor,fontWeight: FontWeight.bold),),),
        
      ],
    );
  }

  _onPress(BuildContext context){
    AppRoutes.bottomSheetOpen(context, CreateWorkSpaceUI());
  }
}
