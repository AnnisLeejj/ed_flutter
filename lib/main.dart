import 'package:ed_flutter/constant/constant.dart';
import 'package:ed_flutter/ui/page/Login.dart';
import 'package:ed_flutter/ui/page/MainPage.dart';
import 'package:ed_flutter/ui/page/SelectorEvironment.dart';
import 'package:ed_flutter/ui/page/SplashPage.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

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
