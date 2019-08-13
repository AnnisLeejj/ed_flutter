import 'package:ed_flutter/utils/SpUtil.dart';
import 'package:ed_flutter/utils/StringUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Login.dart';
import 'MainPage.dart';
import 'SelectorEvironment.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void _initSP() async {
    SpCommonUtil.getCommon().then((sp) {
      judge();
    });
  }

  void judge() async {
    String host = SpCommonUtil.getHost();
    if (!StringUtil.isEmpty(host)) {
      ///已经选择了环境
      if (SpCommonUtil.getIsSignIn() == true) {
        Navigator.pushAndRemoveUntil(
            context,
            new MaterialPageRoute(builder: (context) => new MainPage()),
            ModalRoute.withName("/splash"));
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            new MaterialPageRoute(builder: (context) => new LoginPage()),
            ModalRoute.withName("/splash"));
      }
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(
              builder: (context) => new SelectorEnvironmentPage(
                    fromLogin: false,
                  )),
          ModalRoute.withName("/splash"));
    }
  }

  @override
  void initState() {
    super.initState();
    _initSP();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Image(
          width: double.infinity,
          height: double.infinity,
          image: AssetImage("assets/images/app_login_bg.png"),
          fit: BoxFit.fill,
        ),
        Image(
            alignment: Alignment.center,
            image: AssetImage("assets/images/welcome_logo.png"),
            height: 200.0),
      ],
    ));
  }
}
