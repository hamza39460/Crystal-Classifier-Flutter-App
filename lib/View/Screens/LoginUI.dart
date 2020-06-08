import 'package:crystal_classifier/Controller/States.dart';
import 'package:crystal_classifier/Controller/UserController.dart';
import 'package:crystal_classifier/View/Screens/NoWorkspaceUI.dart';
import 'package:crystal_classifier/View/Screens/SignupUI.dart';
import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:crystal_classifier/View/Utils/appRoutes.dart';
import 'package:crystal_classifier/View/Widgets/BackButtonWidget.dart';
import 'package:crystal_classifier/View/Widgets/Background.dart';
import 'package:crystal_classifier/View/Widgets/ButtonWidget.dart';
import 'package:crystal_classifier/View/Widgets/CardBackground.dart';
import 'package:crystal_classifier/View/Widgets/CircularProgressIndicatorWidget.dart';
import 'package:crystal_classifier/View/Widgets/GoogleButtonWidget.dart';
import 'package:crystal_classifier/View/Widgets/InputWidget.dart';
import 'package:crystal_classifier/View/Widgets/RoundButtonWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Common.ScreenInit(context);
    return Scaffold(
      body:ChangeNotifierProvider.value(
      value:UserController.init(),
      child: Consumer<UserController>(builder: (context,userController,child){
        print(userController.getUserAuthState());
        switch(userController.getUserAuthState()){
          case UserAuthState.Uninitialized:
          case UserAuthState.Unauthenticated:
          case UserAuthState.Authenticated:
          {
            return  NoWorkSpaceUI();
          }
          case UserAuthState.Error:
          case UserAuthState.Signup_in_process:
          default:
            return _bodyStack(context);
        }
      }),
      )
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
        BackButtonWidget(),
        Container(
          padding: const EdgeInsets.all(10.0),
          alignment: Alignment.topLeft,
          child: Text(
            'Login to your account',
            style: TextStyle(
                fontSize: Common.getSPfont(26),
                color: whiteColor,
                fontWeight: FontWeight.bold),
          ),
        ),
        _inputCard(context),
      ],
    ));
  }

  _inputCard(BuildContext context) {
    return CardBackground(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(top: 20.0),
        child: _LoginForm(),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  __LoginFormState createState() => __LoginFormState();
}

class __LoginFormState extends State<_LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email, password;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _showEmailInput(),
          _showPwdInput(),
          _showForgotPasswordInput(),
          (Provider.of<UserController>(context).getUserAuthState()==UserAuthState.Login_in_process)
          ? CircularProgressIndicatorWidget()
          :_showLoginBtn(),
          Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Or Google Account',
                style: TextStyle(fontSize: Common.getSPfont(15)),
              )),
          (Provider.of<UserController>(context).getUserAuthState()==UserAuthState.Login_in_process)
          ? CircularProgressIndicatorWidget()
          :_showGoogleLoginBtn(),
          _showSignupText(context),
        ],
        //_showLoginBtn()
      ),
    );
  }

  _showEmailInput() {
    return InputWidget(
      labelText: 'Email',
      hintText: 'Please enter your email',
      obscureText: false,
      keyBoardType: TextInputType.emailAddress,
      controller: _emailController,
      onSaved: (value) {  
        email=value.trim();
      },
      validationText: 'Please enter your email',
    );
  }

  _showPwdInput() {
    return InputWidget(
      labelText: 'Password',
      hintText: 'Please enter your password',
      obscureText: true,
      keyBoardType: TextInputType.visiblePassword,
      controller: _pwdController,
      maxLines: 1,
      validationText: 'Please enter password',
      onSaved: (value) { 
        password=value.trim();
       },
    );
  }

  _showForgotPasswordInput() {
    return Align(
      alignment: Alignment.topRight,
      child: FlatButton(
        child: Text(
          'Forgot Password?',
          style: TextStyle(
              color: mosqueColor1,
              fontWeight: FontWeight.bold,
              fontSize: Common.getSPfont(15)),
        ),
        onPressed: () => print('Forgot Password Clicked'),
      ),
    );
  }

  _showLoginBtn() {
    return RoundButtonWidget(
        icon: Icons.forward,
        iconColor: whiteColor,
        backgroundColor: mosqueColor1,
        onPress: _loginPressed);
  }

  _showGoogleLoginBtn() {
    return GoogleButtonWidget(
        backgroundColor: whiteColor, onPress: _googleloginPressed);
  }



  _showSignupText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:90),
      child: RichText(
        text: TextSpan(
            text: 'Don\'t have account?',
            style: TextStyle(color: blackColor, fontSize: Common.getSPfont(15)),
            children: [
              WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: InkWell(
                      child: Text(
                        'Signup',
                        style: TextStyle(
                            color: mosqueColor1, fontSize: Common.getSPfont(15),fontWeight: FontWeight.bold),
                      ),
                      onTap: (){
                        _signupPressed();
                      },
                    ),
                  )),
            ]),
      ),
    );
  }

    _loginPressed(BuildContext context) {
     print('Signup pressed');
      if(_validateAndSave()==true){
        Provider.of<UserController>(context,listen: false).loginWithEmailandPwd(email, password);

      }
      else
      print('not next');
  }

  _googleloginPressed(BuildContext context) {
    setState(() {
      print('Google login pressed');
    });
  }

  _signupPressed(){
    AppRoutes.replace(context, SignupUI());
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _pwdController.clear();
      _emailController.clear();
//      form.reset();
      return true;
    }
    return false;
  }
}