import 'dart:developer';
import 'dart:io';

import 'package:crystal_classifier/Controller/States.dart';
import 'package:crystal_classifier/Controller/UserController.dart';
import 'package:crystal_classifier/Model/User.dart';
import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:crystal_classifier/View/Widgets/AppTitle.dart';
import 'package:crystal_classifier/View/Widgets/BackButtonWidget.dart';
import 'package:crystal_classifier/View/Widgets/Background.dart';
import 'package:crystal_classifier/View/Widgets/ButtonWidget.dart';
import 'package:crystal_classifier/View/Widgets/CardBackground.dart';
import 'package:crystal_classifier/View/Widgets/CircularProgressIndicatorWidget.dart';
import 'package:crystal_classifier/View/Widgets/ImageOptionSheet.dart';
import 'package:crystal_classifier/View/Widgets/InputWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  String name, email, password;
  File image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _pwdNode = FocusNode();
  @override
  void initState() {
    _emailController.text = UserController.init().getUserDetails()['Email'];
    _nameController.text = UserController.init().getUserDetails()["Name"];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider.value(
      value: UserController.init(),
      child:
          Consumer<UserController>(builder: (context, userController, child) {
        print(userController.getUserDataState());
        switch (userController.getUpdateUserDateState()) {
          case UpdateUserDataStatus.Uninitialized:
          case UpdateUserDataStatus.Error:
          case UpdateUserDataStatus.Updated:
          case UpdateUserDataStatus.Updating:
            return _bodyStack(context);
        }
      }),
    ));
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
      child: ListView(
        shrinkWrap: true,
        //mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          BackButtonWidget(),
          Container(
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.topLeft,
            child: Text(
              'Update your Profile Details',
              style: TextStyle(
                  fontSize: Common.getSPfont(26),
                  color: whiteColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          _inputCard(context),
        ],
      ),
    );
  }

  _inputCard(BuildContext context) {
    return CardBackground(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(top: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _showImageInput(),
              _showNameInput(),
              _showEmailInput(),
              _showPwdInput(),
              (Provider.of<UserController>(context).getUpdateUserDateState() ==
                      UpdateUserDataStatus.Updating)
                  ? CircularProgressIndicatorWidget()
                  : _showUpdateButton(context),
            ],
          ),
        ),
      ),
    );
  }

  _showImageInput() {
    return Column(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: whiteColor,
          backgroundImage: (image == null)
              ? NetworkImage(UserController.init().getUserDetails()['Image'])
              : FileImage(image),
          radius: 30,
        ),
        InkWell(
          child: Text(
            'Edit',
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
      hintText: 'Please enter your Password to update your Info',
      obscureText: true,
      maxLines: 1,
      keyBoardType: TextInputType.text,
      controller: _pwdController,
      validationText: 'Please enter your Password',
      textInputAction: TextInputAction.next,
      myNode: _pwdNode,
      onSaved: (value) {
        password = value.trim();
      },
    );
  }

  _showUpdateButton(BuildContext context) {
    return ButtonWidget(
      isWhite: true,
      onPress: _updatePressed,
      text: Text(
        'Update',
        style: TextStyle(
            fontSize: Common.getSPfont(18), fontWeight: FontWeight.bold),
      ),
    );
  }

  _addImagePress() {
    // setState(() {
    //   print('add image pressed');
    // });
    print('add image pressed');
    ImageSelectOptionSheet(context: context, handlerFunction: _getImageFile);
  }

  _getImageFile(ImageSource src) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile =
        await imagePicker.getImage(source: src, imageQuality: 80);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {});
    }
  }

  _updatePressed(BuildContext context) {
    print('Update pressed');
    if (_validateAndSave() == true) {
      Provider.of<UserController>(context, listen: false)
          .updateUserDetails(email, name, image, password);
    } else
      print('not next');
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
