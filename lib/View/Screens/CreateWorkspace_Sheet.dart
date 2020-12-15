import 'dart:developer';

import 'package:crystal_classifier/Controller/WorkspaceController.dart';
import 'package:crystal_classifier/Model/WorkspaceDescriptor.dart';
import 'package:crystal_classifier/View/Screens/HomeUI.dart';
import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:crystal_classifier/View/Widgets/ButtonWidget.dart';
import 'package:crystal_classifier/View/Widgets/CardBackground.dart';
import 'package:crystal_classifier/View/Widgets/InputWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Utils/appRoutes.dart';
import 'AllWorkspacesUI.dart';

class CreateWorkSpaceUI extends StatelessWidget {
  WorkspaceDescriptor workspaceDescriptor;
  CreateWorkSpaceUI({this.workspaceDescriptor});
  @override
  Widget build(BuildContext context) {
    return CardBackground(
        child: Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: _WorkSpaceForm(
        workspaceDescriptor: this.workspaceDescriptor,
      ),
    ));
  }
}

class _WorkSpaceForm extends StatefulWidget {
  WorkspaceDescriptor workspaceDescriptor;
  _WorkSpaceForm({this.workspaceDescriptor});
  @override
  __WorkSpaceFormState createState() => __WorkSpaceFormState();
}

class __WorkSpaceFormState extends State<_WorkSpaceForm> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _titleNode = FocusNode();
  final FocusNode _descNode = FocusNode();
  String _title;
  String _description;
  bool _isNew = true;
  @override
  void initState() {
    if (widget.workspaceDescriptor != null) {
      log('av');
      _isNew = false;
      _titleController.text = widget.workspaceDescriptor.getName();
      _descController.text = widget.workspaceDescriptor.getDescription();
    }
    super.initState();
  }

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
                  IconButton(
                      icon: Icon(
                        Icons.close,
                      ),
                      onPressed: () {
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
      validationText: 'Please enter title',
      obscureText: false,
      myNode: _titleNode,
      nextNode: _descNode,
      keyBoardType: TextInputType.text,
      controller: _titleController,
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        _title = value;
      },
    );
  }

  _showDescInput() {
    return InputWidget(
      labelText: 'Description',
      hintText: 'Max 500 Words',
      validationText: 'Please enter Description',
      obscureText: false,
      keyBoardType: TextInputType.text,
      controller: _descController,
      myNode: _descNode,
      textInputAction: TextInputAction.done,
      onSubmit: (dynamic) {
        _onCreatePress(context);
      },
      onSaved: (value) {
        _description = value;
      },
      maxLines: 10,
      maxLength: 500,
    );
  }

  Widget _showCreateButton() {
    return ButtonWidget(
      text: Text(
        (_isNew == true) ? 'Create Workspace' : 'Update Workspace Details',
        style: TextStyle(
            fontSize: Common.getSPfont(21),
            fontWeight: FontWeight.bold,
            color: whiteColor),
        textAlign: TextAlign.center,
      ),
      onPress: _onCreatePress,
    );
  }

  _onCreatePress(BuildContext context) {
    debugPrint('Create Workspace pressed');
    FormState _current = _formKey.currentState;
    if (_current.validate()) {
      _current.save();
      if (_isNew == true) {
        WorkSpaceController.init().createWorkSpace(_title, _description);
        AppRoutes.pop(context);
        //TODO DONT USE APPROUTES
        AppRoutes.makeFirst(context, HomeUI());
      } else {
        WorkSpaceController.init().updateWorkSpaceDetails(
            widget.workspaceDescriptor, _title, _description);
        AppRoutes.pop(context);
      }
    }
  }
}
