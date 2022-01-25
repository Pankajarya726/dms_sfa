import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';

class AppRating {
  static InAppReview inAppReview = InAppReview.instance;

  static Future requestReview() async {
    debugPrint("requestReview--->");
    debugPrint("requestReview--->${await inAppReview.isAvailable()}");
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  static Future openStoreListing() async {
    debugPrint("openStoreListing--->");
    inAppReview.openStoreListing(appStoreId: 'com.vvapps.dms', microsoftStoreId: 'com.vvapps.dms');
  }
}
