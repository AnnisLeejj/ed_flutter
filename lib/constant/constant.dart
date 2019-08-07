import 'package:ed_flutter/utils/SpUtil.dart';
import 'package:flutter/material.dart';

class ColorDef {
  static final Color colorPrimary = Color(0xff307BF4);
  static final Color colorPrimaryDark = Color(0xff303F9F);
  static final Color colorAccent = Color(0xffFF4081);

  static final Color textGray = Color(0xff505050);
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
  static final String getEnvironment = "cmct-pub/public/query";
  static final String getLogo = "app/basicData/sysConfig";
  static final String getCode = "app/sms/sendVcode";
  static final String getVcodeToken = "app/sysUser/getVcodeToken";
  static final String modifyPwdWithVcodeToken = "app/sysUser/modifyPwdWithVcodeToken";
}

class SpConstant {
  static final String spIp = 'spIp';
  static final String spHost = 'spHost';
  static final String spName = 'spName';
  static final String spTopLogo = 'spTopLogo';
  static final String spBottomLogo = 'spBottomLogo';
}
