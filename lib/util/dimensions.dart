import 'package:get/get.dart';

class Dimensions {
  static double fontSizeExtraSmall = Get.context!.width >= 1300 ? 15 : 13;
  static double fontSizeSmall = Get.context!.width >= 1300 ? 17 : 15;
  static double fontSizeDefault = Get.context!.width >= 1300 ? 19 : 17;
  static double fontSizeLarge = Get.context!.width >= 1300 ? 21 : 19;
  static double fontSizeExtraLarge = Get.context!.width >= 1300 ? 24 : 23;
  static double fontSizeOverLarge = Get.context!.width >= 1300 ? 29 : 27;

  static const double paddingSizeExtraSmall = 5.0;
  static const double paddingSizeSmall = 10.0;
  static const double paddingSizeDefault = 15.0;
  static const double paddingSizeLarge = 20.0;
  static const double paddingSizeExtraLarge = 25.0;
  static const double paddingSizeOverLarge = 30.0;

  static const double radiusSmall = 5.0;
  static const double radiusDefault = 10.0;
  static const double radiusLarge = 15.0;
  static const double radiusExtraLarge = 20.0;

  static const double webMaxWidth = 1170;
  static const int messageInputLength = 250;
}
