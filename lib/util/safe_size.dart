import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class SafeSize {
  static double bottomBarHeight({double def = 34}) {
    return max(ScreenUtil().bottomBarHeight, def);
  }
}