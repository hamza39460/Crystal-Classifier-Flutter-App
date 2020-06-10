import 'package:cache_image/cache_image.dart';
import 'package:crystal_classifier/Controller/States.dart';
import 'package:crystal_classifier/Controller/UserController.dart';
import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:crystal_classifier/View/Widgets/AppTitle.dart';
import 'package:crystal_classifier/View/Widgets/Background.dart';
import 'package:crystal_classifier/View/Widgets/ButtonWidget.dart';
import 'package:crystal_classifier/View/Widgets/CardBackground.dart';
import 'package:crystal_classifier/View/Widgets/CircularProgressIndicatorWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Common.ScreenInit(context);
    //return _bodyStack(context);
    return Scaffold(
      body: _bodyStack(context),
    );
  }

  _bodyStack(BuildContext context) {
    return Stack(
      children: [
        BackgroundWidget(),
        _bodyColumn(context),
      ],
    );
  }

  _bodyColumn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(child: AppTitle()),
            _showPersonalInfoCard(context),
            _showButtons(context)
          ],
        ),
      ),
    );
  }

  _showPersonalInfoCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
      child: CardBackground(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: ChangeNotifierProvider.value(
            value: UserController.init(),
            child: Consumer<UserController>(
                builder: (context, userController, child) {
              print(userController.getUserDataState());
              switch (userController.getUserDataState()) {
                case UserDataState.Uninitialized:
                case UserDataState.Error:
                case UserDataState.Fetching_User_Data:
                  return CircularProgressIndicatorWidget();
                case UserDataState.Fetched_User_Data:
                  return _personalInfo(userController, context);
              }
            }),
          )
          //elevation: 2,

          //     child: ListTile(
          // leading: _showImageInput(),
          // title: Text('${user.getUserDetails()['Name']}',style: TextStyle(fontSize: Common.getSPfont(20),color: blackColor),),
          // subtitle:Text('${user.getUserDetails()['Email']}',style: TextStyle(fontSize: Common.getSPfont(15),color: blackColor),),
          // trailing: Icon(Icons.edit),
          //     ),
          ),
    );
  }

  _personalInfo(UserController user, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _showImage(),
          Padding(
            padding: const EdgeInsets.only(right: 20),
          ),
          Column(
            children: [
              Text(
                '${user.getUserDetails()['Name']}',
                style: TextStyle(
                    fontSize: Common.getSPfont(20), color: blackColor),
                textAlign: TextAlign.left,
              ),
              Text(
                '${user.getUserDetails()['Email']}',
                style: TextStyle(
                    fontSize: Common.getSPfont(15), color: blackColor),
              ),
              // Divider(height: 50,color: Colors.red,thickness: 20),
              _showEditButton(context)
            ],
          )
        ],
      ),
    );
  }

  _showImage() {
    return Column(
      children: <Widget>[
        // CircleAvatar(
        //   backgroundColor: whiteColor,
        //   backgroundImage: CacheImage(UserController.init().getUserDetails()['Image']),
        //   radius: 60,
        // ),
        // ClipOval(
        //     child: Image(
        //   gaplessPlayback: true,
        //   image: CacheImage(UserController.init().getUserDetails()['Image']),
        //   fit: BoxFit.,
        //   width: 80,
        //   height: 80,
        // )),
        new Container(
            width: 100,
            height: 100,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: CacheImage(UserController.init().getUserDetails()['Image'])
                        )))
        // InkWell(
        //   child: Text(
        //     'Add',
        //     style: TextStyle(
        //         fontSize: Common.getSPfont(15),
        //         color: mosqueColor1,
        //         fontWeight: FontWeight.bold,
        //         decoration: TextDecoration.underline,
        //         ),
        //   ),
        //   onTap: (){
        //     _addImagePress();
        //   },
        // ),
      ],
    );
  }

  _showEditButton(BuildContext context) {
    return FlatButton(
        onPressed: () {
          _editProfilePressed();
        },
        child: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 13),
        ));
  }

  _editProfilePressed() {
    debugPrint('Edit');
  }

  _showButtons(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _showTermConditionButton(context),
            _showLogoutButton(context),
          ],
        ));
  }

  _showTermConditionButton(BuildContext context) {
    return ButtonWidget(
      backgroundColor: greyColor0,
      onPress: _termsConditionsPressed,
      shadowColor: null,
      text: Text(
        'Terms and Conditions',
        style: TextStyle(
            fontSize: Common.getSPfont(18), fontWeight: FontWeight.bold),
      ),
    );
  }

  _showLogoutButton(BuildContext context) {
    return ButtonWidget(
      backgroundColor: greyColor0,
      onPress: _logoutPressed,
      shadowColor: null,
      text: Text(
        'Logout',
        style: TextStyle(
            fontSize: Common.getSPfont(18), fontWeight: FontWeight.bold),
      ),
    );
  }

  _termsConditionsPressed(BuildContext context) {
    debugPrint('Terms and Conditions');
  }

  _logoutPressed(BuildContext context) {
    debugPrint('Logout Pressed');
  }
}
