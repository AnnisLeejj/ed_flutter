import 'package:ed_flutter/constant/constant.dart';
import 'package:flutter/material.dart';

import 'page/Welcome.dart';

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
        "/welcome": (BuildContext context) => WelcomePage(fromLogin: false,),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: ColorDef.colorPrimary),
      home: WelcomePage(fromLogin: false,),
    );
  }
}
