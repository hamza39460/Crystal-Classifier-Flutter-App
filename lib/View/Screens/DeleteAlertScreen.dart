import 'package:crystal_classifier/Controller/WorkspaceController.dart';
import 'package:crystal_classifier/Model/WorkspaceDescriptor.dart';
import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:crystal_classifier/View/Utils/AppRoutes.dart';
import 'package:crystal_classifier/View/Widgets/ButtonWidget.dart';
import 'package:crystal_classifier/View/Widgets/CardBackground.dart';
import 'package:flutter/material.dart';

class DeleteAlertScreen extends StatelessWidget {
  WorkspaceDescriptor workspaceDescriptor;
  DeleteAlertScreen({this.workspaceDescriptor});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CardBackground(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          //color: whiteColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/alert_image.png"),
              ),
              _text()
            ],
          ),
        ),
        _showConfirmButton(),
        _showCancelButton()
      ],
    );
  }

  _text() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          'Are you sure to delete this workspace?\n(This action is irreversible)',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Common.getSPfont(16),
          ),
        ),
      ),
    );
  }

  Widget _showConfirmButton() {
    return ButtonWidget(
      text: Text(
        'Confirm',
        style: TextStyle(
            fontSize: Common.getSPfont(21),
            fontWeight: FontWeight.bold,
            color: whiteColor),
        textAlign: TextAlign.center,
      ),
      onPress: _onConfrimPressed,
    );
  }

  Widget _showCancelButton() {
    return ButtonWidget(
      text: Text(
        'Cancel',
        style: TextStyle(
            fontSize: Common.getSPfont(21),
            fontWeight: FontWeight.bold,
            color: whiteColor),
        textAlign: TextAlign.center,
      ),
      onPress: _onCancelPressed,
    );
  }

  _onConfrimPressed(BuildContext context) async {
    bool response =
        await WorkSpaceController.init().deleteWorkSpace(workspaceDescriptor);
    if (response == true) {
      AppRoutes.pop(context);
      AppRoutes.pop(context);
    }
  }

  _onCancelPressed(BuildContext context) {
    AppRoutes.pop(context);
  }
}
