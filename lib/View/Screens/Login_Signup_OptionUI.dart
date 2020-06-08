import 'package:crystal_classifier/View/Screens/LoginUI.dart';
import 'package:crystal_classifier/View/Screens/SignupUI.dart';
import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:crystal_classifier/View/Utils/appRoutes.dart';
import 'package:crystal_classifier/View/Widgets/AppTitle.dart';
import 'package:crystal_classifier/View/Widgets/Background.dart';
import 'package:crystal_classifier/View/Widgets/ButtonWidget.dart';
import 'package:crystal_classifier/View/Widgets/CardBackground.dart';
import 'package:flutter/material.dart';

class LoginSignupOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Common.ScreenInit(context);
    return Scaffold(
      body: _bodyStack(context),
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
    return SingleChildScrollView(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          AppLogo(),
          Center(child: AppTitle()),
          _inputCard(context),
        ],
      ),
    );
  }

  _inputCard(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.only(top:20),
      child: CardBackground(
        child: Column(
          children: <Widget>[
            Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 20, 20),
                alignment: Alignment.topLeft,
                child: Text(
                  'Welcome to Crystal Classifier!',
                  style: TextStyle(
                      fontSize: Common.getSPfont(24),
                      fontWeight: FontWeight.bold),
                )),
              Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 8, 0),
                    alignment: Alignment.topLeft,
                    child: Text(
                        'This is the first version of Crystal Classifier.\nPlease sign in or create an account below.',
                        style: TextStyle(fontSize:Common.getSPfont(17)))),
              _showLoginButton(),
              _showSignupButton()
          ],
        ),
      ),
    );
  }

  Widget _showLoginButton() {
    return ButtonWidget(
      text: Text(
        'Login',
        style: TextStyle(
            fontSize: Common.getSPfont(21), fontWeight: FontWeight.bold, color: mosqueColor1),
        textAlign: TextAlign.center,
      ),
      backgroundColor: whiteColor,
      shadowColor: mosqueColor0,
      onPress: _onLoginPress,
    );
  }

  Widget _showSignupButton() {
    return ButtonWidget(
      text: Text(
        'Signup',
        style: TextStyle(
            fontSize: Common.getSPfont(21), fontWeight: FontWeight.bold, color:whiteColor),
        textAlign: TextAlign.center,
      ),
      backgroundColor: mosqueColor1,
      shadowColor: whiteColor,
      onPress: _onSignupPress,
    );
  }

  _onLoginPress(BuildContext context){
    AppRoutes.push(context, LoginUI());
  }

  _onSignupPress(BuildContext context){
    AppRoutes.push(context, SignupUI());
  }
}


class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: _logo(context),
    );
  }

  Widget _logo(BuildContext context) {
    return Image.asset(
      "assets/images/logo.png",
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width * 0.50,
    );
  }
}