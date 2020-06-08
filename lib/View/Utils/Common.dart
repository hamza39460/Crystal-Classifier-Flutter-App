import 'package:flutter_screenutil/screenutil.dart';

class Common{
   static ScreenInit(context) {
    ScreenUtil.init(context,
        width: 1080, height: 2160, allowFontScaling: false);
  }
  static getSPfont(double xdFont){
    return ScreenUtil().setSp(xdFont*3);
  }
}