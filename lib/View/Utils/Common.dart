import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class Common {
  static ScreenInit(context) {
    ScreenUtil.init(context,
        width: 1080, height: 2160, allowFontScaling: false);
  }

  static getSPfont(double xdFont) {
    return ScreenUtil().setSp(xdFont * 3);
  }

  static closeKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static message(String error, BuildContext context) {
    return Container(
      child: Text(error,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              fontSize: Common.getSPfont(15),
              color: whiteColor)),
    );
  }
}
