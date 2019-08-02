import 'package:ed_flutter/constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpCommonUtil {
  static SharedPreferences prefsCommon;

  static Future<SharedPreferences> getCommon() async {
    if (prefsCommon == null) {
      prefsCommon = await SharedPreferences.getInstance();
      return prefsCommon;
    } else {
      return prefsCommon;
    }
  }

  static String getHost() {
    return prefsCommon.getString(SpConstant.spHost);
  }
}
