import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:crystal_classifier/View/Widgets/ButtonWidget.dart';
import 'package:crystal_classifier/View/Widgets/CardBackground.dart';
import 'package:crystal_classifier/View/Widgets/InputWidget.dart';
import 'package:flutter/material.dart';

class CreateWorkSpaceUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CardBackground(
        child: Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: _WorkSpaceForm(),
    ));
  }
}

class _WorkSpaceForm extends StatefulWidget {
  @override
  __WorkSpaceFormState createState() => __WorkSpaceFormState();
}

class __WorkSpaceFormState extends State<_WorkSpaceForm> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
                  child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Create new workspace',
                    style: TextStyle(
                        fontSize: Common.getSPfont(26),
                        color: blackColor,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  IconButton(icon: Icon(Icons.close,), onPressed: (){
                    Navigator.of(context).pop();
                  })
                ],
              ),
              _showTitleInput(),
              _showDescInput(),
              _showCreateButton(),
            ],
          ),
        ),
      ),
    );
  }

  _showTitleInput() {
    return InputWidget(
      labelText: 'Title',
      hintText: 'Please enter title of Workspace',
      obscureText: false,
      keyBoardType: TextInputType.emailAddress,
      controller: _titleController,
    );
  }

  _showDescInput() {
    return InputWidget(
      labelText: 'Description',
      hintText: 'Max 500 Words',
      obscureText: false,
      keyBoardType: TextInputType.text,
      controller: _descController,
      maxLines: 10,
      maxLength: 500,

    );
  }

  Widget _showCreateButton() {
    return ButtonWidget(
      text: Text(
        'Signup',
        style: TextStyle(
            fontSize: Common.getSPfont(21), fontWeight: FontWeight.bold, color:whiteColor),
        textAlign: TextAlign.center,
      ),
      backgroundColor: mosqueColor1,
      shadowColor: whiteColor,
      onPress: _onCreatePress,
    );
  }

  _onCreatePress(BuildContext context){
    //Navigator.of(context).pop();
    debugPrint('Create Workspace pressed');
  }
}
