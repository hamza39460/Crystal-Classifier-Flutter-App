import 'dart:developer';

import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Widgets/CircularProgressIndicatorWidget.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CircularWidgetDialog {
  BuildContext context;
  static ProgressDialog pr;
  showLoadingDialog(BuildContext context, {String message = "Loading"}) {
    this.context = context;
    pr = ProgressDialog(context);
    log('showing now');
    pr.style(
      message: message,
      borderRadius: 10.0,
      backgroundColor: whiteColor,
      progressWidget: CircularProgressIndicatorWidget(),
    );
    log('showing');
    pr.show();
  }

  hideLoadingDialog() async {
    pr = ProgressDialog(this.context);

    log('shoing ${pr.isShowing()}');
    bool re = await pr.hide();
    log('hifin $re');
  }
}
