import 'package:ed_flutter/utils/SpUtil.dart';
import 'package:flutter/material.dart';

class ColorDef {
  static final Color colorPrimary = Color(0xff307BF4);
  static final Color colorPrimaryDark = Color(0xff303F9F);
  static final Color colorAccent = Color(0xffFF4081);

  static final Color textGray = Color(0xff505050);
  static final Color buttonGray = Color(0xFF6F839D);
  static final Color gray = Color(0xFFE1E5EE);
}

class ServerInfo {
//  static final String ip_host = "http://120.77.203.62:8999/";//正式
//  static final String ip_host = "http://120.78.170.2:8999/";//演示
  static final String ip_host = "http://113.204.36.171:9020/"; //本地外网
  static final String ip_port_project = ip_host + "edong-app/";

  static String getBaseHost() {
    return SpCommonUtil.getHost();
  }
}

class ServerApis {
  // ignore: non_constant_identifier_names
  static final String TOKEN_HEADER = "edong-token";
  static final String getEnvironment = "cmct-pub/public/query";
  static final String getLogo = "app/basicData/sysConfig";
  static final String getCode = "app/sms/sendVcode";
  static final String getVcodeToken = "app/sysUser/getVcodeToken";
  static final String modifyPwdWithVcodeToken =
      "app/sysUser/modifyPwdWithVcodeToken";
  static final String login = "app/auth/login";
  static final String changePwd = "app/sysUser/modifyPwd/";
  static final String getUser =
      "app/sysUser/list/"; // "app/sysUser/list/{userId}";
  static final String getUserPermission = "app/auth/permission";
}

class SpConstant {
  ///基础环境
  static final String spIp = 'spIp';
  static final String spHost = 'spHost';
  static final String spName = 'spName';
  static final String spTopLogo = 'spTopLogo';
  static final String spBottomLogo = 'spBottomLogo';

  ///用户信息
  static final String spUserUserInfo = 'spUserUserInfo';
  static final String spUserId = 'spUserId';
  static final String spUserName = 'spUserName';
  static final String spToken = 'spToken';
  static final String spIsSignIn = 'spIsSignIn';
  static final String spUserPermission = 'spUserPermission';
}
