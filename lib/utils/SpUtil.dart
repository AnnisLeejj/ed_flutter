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

  static void saveLastUserInfo(String userInfo) {
    prefsCommon.setString(SpConstant.spUserUserInfo, userInfo);
  }

  static String getLastUserInfo() {
    return prefsCommon.getString(SpConstant.spUserUserInfo);
  }

  static void saveLastUserID(String userId) {
    prefsCommon.setString(SpConstant.spUserId, userId);
  }

  static String getLastUserID() {
    return prefsCommon.getString(SpConstant.spUserId);
  }
  static void saveLastUserName(String userName) {
    prefsCommon.setString(SpConstant.spUserName, userName);
  }

  static String getLastUserName() {
    return prefsCommon.getString(SpConstant.spUserName);
  }

  static void saveToken(String token) {
    prefsCommon.setString(SpConstant.spToken, token);
  }

  static String getToken() {
    return prefsCommon.getString(SpConstant.spToken);
  }
  static void saveIsSignIn(bool isSignIn) {
    prefsCommon.setBool(SpConstant.spIsSignIn, isSignIn);
  }

  static bool getIsSignIn() {
     return prefsCommon.getBool(SpConstant.spIsSignIn);
  }

  static void saveUserPermission(String permissionJson) {
    prefsCommon.setString(SpConstant.spUserPermission, permissionJson);
  }

  static String getUserPermission() {
    return prefsCommon.getString(SpConstant.spUserPermission);
  }

  ///用户信息(需要加入用户ID 存储)

}
