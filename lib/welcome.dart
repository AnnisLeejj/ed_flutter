import 'package:flutter/material.dart';

import 'constant/constant.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
      padding: EdgeInsets.only(top: 60),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
              alignment: Alignment.center,
              image: AssetImage("assets/images/welcome_logo.png"),
              height: 200.0),
          new Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                '欢迎进入',
                style: TextStyle(
                  fontSize: 35,
                ),
              )),
          new Container(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                '请在列表中选择使用环境',
                style: TextStyle(
                  color: ColorDef.textGray,
                  fontSize: 16,
                ),
              )),
          new Expanded(
              child: new Row(
            children: <Widget>[
              Expanded(
                  child: new Container(
                alignment: Alignment.center,
                color: Colors.black38,
                child: new Text("這裡是logo"),
              ))
            ],
          )),
        ],
      ),
    ));
  }
}
