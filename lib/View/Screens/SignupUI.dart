import 'dart:io';

import 'package:crystal_classifier/Controller/States.dart';
import 'package:crystal_classifier/Controller/UserController.dart';
import 'package:crystal_classifier/View/Screens/LoginUI.dart';
import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:crystal_classifier/View/Utils/appRoutes.dart';
import 'package:crystal_classifier/View/Widgets/BackButtonWidget.dart';
import 'package:crystal_classifier/View/Widgets/Background.dart';
import 'package:crystal_classifier/View/Widgets/CardBackground.dart';
import 'package:crystal_classifier/View/Widgets/CircularProgressIndicatorWidget.dart';
import 'package:crystal_classifier/View/Widgets/CustomSnackbar.dart';
import 'package:crystal_classifier/View/Widgets/GoogleButtonWidget.dart';
import 'package:crystal_classifier/View/Widgets/ImageOptionSheet.dart';
import 'package:crystal_classifier/View/Widgets/InputWidget.dart';
import 'package:crystal_classifier/View/Widgets/RoundButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'NoWorkspaceUI.dart';

class SignupUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Common.ScreenInit(context);
    return Scaffold(
        body: ChangeNotifierProvider.value(
      value: UserController.init(),
      child:
          Consumer<UserController>(builder: (context, userController, child) {
        print(userController.getUserAuthState());
        switch (userController.getUserAuthState()) {
          case UserAuthState.Authenticated:
            return NoWorkSpaceUI();
          case UserAuthState.Uninitialized:
          case UserAuthState.Unauthenticated:
          case UserAuthState.Error:
          case UserAuthState.Signup_in_process:
          default:
            return _bodyStack(context);
        }
      }),
    )
        //
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
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        BackButtonWidget(),
        Container(
          padding: const EdgeInsets.all(10.0),
          alignment: Alignment.topLeft,
          child: Text(
            'Create your account',
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  File image;
  bool imageIsFile = false;
  String name, email, password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _pwdNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    if (Provider.of<UserController>(context).getUserAuthState() ==
        UserAuthState.Error) {
      _nameController.clear();
      _pwdController.clear();
      _emailController.clear();
      setState(() {
        imageIsFile = false;
        image = null;
      });
    }
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(), //ClampingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          //shrinkWrap: true,
          //physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Center(child: _showImageInput()),
            _showNameInput(),
            _showEmailInput(),
            _showPwdInput(),
            (Provider.of<UserController>(context).getUserAuthState() ==
                    UserAuthState.Signup_in_process)
                ? CircularProgressIndicatorWidget()
                : _showLoginBtn(),
            Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Or Google Account',
                  style: TextStyle(fontSize: Common.getSPfont(15)),
                  textAlign: TextAlign.center,
                )),
            (Provider.of<UserController>(context).getUserAuthState() ==
                    UserAuthState.Signup_in_process)
                ? CircularProgressIndicatorWidget()
                : _showGoogleLoginBtn(),
            _showLoginText(context),
          ],
          //_showLoginBtn()
        ),
      ),
    );
  }

  _showNameInput() {
    return InputWidget(
      labelText: 'Name',
      hintText: 'Please enter your name',
      obscureText: false,
      keyBoardType: TextInputType.text,
      controller: _nameController,
      validationText: 'Please enter your name',
      textInputAction: TextInputAction.next,
      myNode: _nameNode,
      nextNode: _emailNode,
      onSaved: (value) {
        name = value.trim();
      },
    );
  }

  _showEmailInput() {
    return InputWidget(
      labelText: 'Email',
      hintText: 'Please enter your email',
      validationText: 'Please enter your email',
      obscureText: false,
      keyBoardType: TextInputType.emailAddress,
      controller: _emailController,
      textInputAction: TextInputAction.next,
      myNode: _emailNode,
      nextNode: _pwdNode,
      onSaved: (value) {
        email = value.trim();
      },
    );
  }

  _showPwdInput() {
    return InputWidget(
      labelText: 'Password',
      hintText: 'Please enter your password',
      validationText: 'Please enter the password',
      obscureText: true,
      keyBoardType: TextInputType.visiblePassword,
      controller: _pwdController,
      maxLines: 1,
      textInputAction: TextInputAction.done,
      myNode: _pwdNode,
      onSubmit: (dynamic) {
        _signupPressed(context);
      },
      onSaved: (value) {
        password = value.trim();
      },
    );
  }

  _showLoginBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: RoundButtonWidget(
          icon: Icons.forward,
          iconColor: whiteColor,
          backgroundColor: mosqueColor1,
          onPress: _signupPressed),
    );
  }

  _showGoogleLoginBtn() {
    return GoogleButtonWidget(
        backgroundColor: whiteColor, onPress: _googleloginPressed);
  }

  _showImageInput() {
    return Column(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: whiteColor,
          backgroundImage: (imageIsFile == true)
              ? FileImage(image)
              : AssetImage('assets/images/person_icon.png'),
          radius: 30,
        ),
        InkWell(
          child: Text(
            'Add',
            style: TextStyle(
              fontSize: Common.getSPfont(15),
              color: mosqueColor1,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
          onTap: () {
            _addImagePress();
          },
        ),
      ],
    );
  }

  _showLoginText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: RichText(
        text: TextSpan(
            text: 'Already have an account?',
            style: TextStyle(color: blackColor, fontSize: Common.getSPfont(15)),
            children: [
              WidgetSpan(
                  child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: InkWell(
                  child: RichText(
                    text: TextSpan(
                      text: 'Login here',
                      style: TextStyle(
                          color: mosqueColor1,
                          fontSize: Common.getSPfont(15),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {
                    _loginPressed(context);
                  },
                ),
              )),
            ]),
      ),
    );
  }

  _loginPressed(BuildContext context) {
    AppRoutes.replace(context, LoginUI());
  }

  _googleloginPressed(BuildContext context) {
    setState(() {
      print('Google login pressed');
    });
  }

  _signupPressed(BuildContext context) {
    print('Signup pressed');
    if (_validateAndSave() == true) {
      Provider.of<UserController>(context, listen: false)
          .signupWithEmailAndPwd(name, email, password, image);
    } else
      print('not next');
  }

  _addImagePress() {
    // setState(() {
    //   print('add image pressed');
    // });
    print('add image pressed');
    ImageSelectOptionSheet(context: context, handlerFunction: _getImageFile);
  }

  _getImageFile(ImageSource src) async {
    image = await ImagePicker.pickImage(source: src, imageQuality: 80);
    if (image != null) {
      setState(() {
        imageIsFile = true;
      });
    }
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate() && imageIsFile == true) {
      form.save();

//      form.reset();
      return true;
    } else if (imageIsFile == false) {
      CustomSnackbar().showError("Please Input your Image");
    }
    return false;
  }
}
