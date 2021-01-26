import 'dart:developer';

import 'package:crystal_classifier/Model/Result.dart';
import 'package:crystal_classifier/Model/WorkspaceDescriptor.dart';
import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:crystal_classifier/View/Widgets/AppTitle.dart';
import 'package:crystal_classifier/View/Widgets/BackButtonWidget.dart';
import 'package:crystal_classifier/View/Widgets/Background.dart';
import 'package:crystal_classifier/View/Widgets/ButtonWidget.dart';
import 'package:flutter/material.dart';

class ResultUI extends StatelessWidget {
  final WorkspaceDescriptor workspaceDescriptor;
  final Result result;
  ResultUI({this.workspaceDescriptor, this.result});
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
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: Row(
              children: [
                BackButtonWidget(),
                AppTitle(),
              ],
            )),
            _showWorkspaceName(context),
            _showImge(context),
            _showResultsData("Classified at", result.getDate()),
            _showResultsData("Classified as", result.getClass()),
            _showResultsData("Confidence", result.getAccuracy()),
            _showDeleteButton(context),
          ],
        ),
      ),
    );
  }

  Widget _showWorkspaceName(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14.0, top: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        workspaceDescriptor.getName(),
        style: TextStyle(
            fontSize: Common.getSPfont(26),
            fontWeight: FontWeight.bold,
            color: whiteColor),
      ),
    );
  }

  Widget _showImge(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.50,
      width: MediaQuery.of(context).size.width * 0.99,
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Image.network(
        result.getImagePath(),
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget _showResultsData(String label, dynamic data) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label:",
              style: TextStyle(
                  fontSize: Common.getSPfont(18),
                  fontWeight: FontWeight.bold,
                  color: whiteColor)),
          Text("$data",
              style: TextStyle(
                  fontSize: Common.getSPfont(18),
                  fontWeight: FontWeight.bold,
                  color: whiteColor)),
        ],
      ),
    );
  }

  Widget _showDeleteButton(BuildContext context) {
    return ButtonWidget(
      text: Text(
        'Delete',
        style: TextStyle(
            fontSize: Common.getSPfont(21),
            fontWeight: FontWeight.bold,
            color: blackColor),
        textAlign: TextAlign.center,
      ),
      isWhite: true,
      onPress: _onDeleteButton,
    );
  }

  _onDeleteButton(BuildContext context) {
    log('delete pressed');
  }
}
