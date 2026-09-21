import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SizeConfig {
//NOTE : Device Sizes
  static double deviceWidth = Get.width;
  static double deviceHeight = Get.height;

//NOTE: Spacer
  static double spacerExtraSmall = 8.w;
  static double spacerSmall = 16.w;
  static double spacerReguler = 24.w;
  static double spacerMedium = 32.w;
  static double spacerLarge = 40.w;
  static double spacerExtraLarge = 64.w;

//NOTE: Padding
  static double paddingReguler = 24.w;
}

double get deviceWidth => SizeConfig.deviceWidth;
double get deviceHeight => SizeConfig.deviceHeight;
double get spacerExtraSmall => SizeConfig.spacerExtraSmall;
double get spacerSmall => SizeConfig.spacerSmall;
double get spacerReguler => SizeConfig.spacerReguler;
double get spacerMedium => SizeConfig.spacerMedium;
double get spacerLarge => SizeConfig.spacerLarge;
double get spacerExtraLarge => SizeConfig.spacerExtraLarge;
double get paddingReguler => SizeConfig.paddingReguler;
