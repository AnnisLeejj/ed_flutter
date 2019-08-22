import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:core' as prefix0;

import 'package:ed_flutter/constant/constant.dart';
import 'package:ed_flutter/ui/page/MainPage.dart';
import 'package:ed_flutter/ui/page/unlogin/Login.dart';
import 'package:ed_flutter/ui/page/unlogin/SelectorEvironment.dart';
import 'package:ed_flutter/ui/page/unlogin/SplashPage.dart';
import 'package:flutter/material.dart';

//void main() => runApp(MyApp());
void main() {
  void collectLog(String line) {
    //收集日志
//    print("collectLog:$line");
  }

  void reportErrorAndLog(FlutterErrorDetails details) {
    //上报错误和日志逻辑
    print("reportErrorAndLog:${details.exceptionAsString()}");
  }

  FlutterErrorDetails makeDetails(Object obj, StackTrace stack) {
    // 构建错误信息
    return FlutterErrorDetails(
        exception: Exception(obj.toString() + ":" + stack.toString()));
  }

  FlutterError.onError = (FlutterErrorDetails details) {
    reportErrorAndLog(details);
  };

  runZoned(
        () => runApp(MyApp()),
    zoneSpecification: ZoneSpecification(
      print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
        collectLog(line); // 收集日志
      },
    ),
    onError: (Object obj, StackTrace stack) {
      var details = makeDetails(obj, stack);
      reportErrorAndLog(details);
    },
  );
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/splash": (BuildContext context) => SplashPage(),
        "/login": (BuildContext context) => LoginPage(),
        "/welcome": (BuildContext context) =>
            SelectorEnvironmentPage(fromLogin: false),
        "/main": (BuildContext context) => MainPage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: ColorDef.colorPrimary),
      home: SplashPage(),
    );
  }
}
