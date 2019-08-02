import 'package:flutter/material.dart';

class ColorDef {
  static final Color colorPrimary = Color(0xff307BF4);
  static final Color colorPrimaryDark = Color(0xff303F9F);
  static final Color colorAccent = Color(0xffFF4081);

  static final Color textGray = Color(0xff505050);
}

class ServerInfo {
  static final String ip_host = "http://113.204.36.171:9020/";
  static final String ip_port_project = ip_host + "edong-app/";
}

class ServerApis {
  static final String getEnvironment = "cmct-pub/public/query";
  static final String getLogo = "app/basicData/sysConfig";
}

class SpConstant {
  static final String spIp = 'spIp';
  static final String spHost = 'spHost';
  static final String spName = 'spName';
  static final String spTopLogo = 'spTopLogo';
  static final String spBottomLogo = 'spBottomLogo';
}
