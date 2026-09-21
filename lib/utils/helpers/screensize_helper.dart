import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ScreenSize { small, medium, large }

const double smBreakpoint = 640;
const double mdBreakpoint = 768;
const double lgBreakpoint = 1024;

ScreenSize getScreenSize() {
  double width = ScreenUtil().screenWidth;

  if (width < smBreakpoint) {
    return ScreenSize.small;
  } else if (width < mdBreakpoint) {
    return ScreenSize.medium;
  } else {
    return ScreenSize.large;
  }
}
