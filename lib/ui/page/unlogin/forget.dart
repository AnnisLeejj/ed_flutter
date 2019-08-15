import 'dart:async';
import 'dart:convert';

import 'package:ed_flutter/constant/constant.dart';
import 'package:ed_flutter/constant/dimens.dart';
import 'package:ed_flutter/utils/SpUtil.dart';
import 'package:ed_flutter/utils/StringUtil.dart';
import 'package:ed_flutter/utils/ToastUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'ResetPassword.dart';

class Forget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  final phoneController = TextEditingController();
  final codeController = TextEditingController();

  bool canGet = true;
  bool havGot = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: Text("忘记密码"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(
            Dimens.marginWindowBig, 10, Dimens.marginWindowBig, 0),
        child: Column(
          children: <Widget>[
            Container(
              height: 10,
            ),
            TextFormField(
              decoration: new InputDecoration(
                hintText: "请输入手机号",
              ),
              keyboardType: TextInputType.number,
              controller: phoneController,
            ),
            Container(
              height: 10,
            ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: new InputDecoration(
                    hintText: "请输入验证码",
                  ),
                  keyboardType: TextInputType.number,
                  controller: codeController,
                ),
                Container(
                  alignment: FractionalOffset(1.0, 0),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                    color: ColorDef.colorPrimary,
                    textTheme: ButtonTextTheme.primary,
                    child: new Text(getText()),
                    disabledColor: Colors.black12,
                    onPressed: getCode(),
                  ),
                )
              ],
            ),
            Container(
              height: 20,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              minWidth: double.infinity,
              height: Dimens.buttonHeight,
              color: ColorDef.colorPrimary,
              textTheme: ButtonTextTheme.primary,
              child: new Text('下 一 步'),
              disabledColor: Colors.black12,
              onPressed: next(),
            ),
            Container(
              height: 10,
            ),
            new Align(
              alignment: new FractionalOffset(0.5, 0.10),
              child:
                  new Image.network('http://up.qqjia.com/z/25/tu32710_10.jpg'),
            ),
          ],
        ),
      ),
    );
  }

  getText() {
    if (canGet)
      return havGot ? "重新获取验证码" : '获取验证码';
    else {
      return '已发送${_countdownTime}s';
    }
  }

  getCode() {
    if (canGet) {
      havGot = true;
      return () {
        final phone = phoneController.text;
        if (!StringUtil.isPhoneNumber(phone)) {
          showToast("请输入正确的手机号");
          return;
        }

        startTimer();
        http.post(ServerInfo.getBaseHost() + ServerApis.getCode,
            body: {"phone": phone}).then((response) {
          if (response.statusCode != 200) {
            setState(() {
              canGet = true;
            });
            showToast(response == null
                ? "发送失败，请重试"
                : json.decode(response.body)["message"]);
          }
        });
      };
    } else {
      return null;
    }
  }

  Timer _timer;
  int _countdownTime = 0;

  startTimer() {
    setState(() {
      canGet = false;
    });
    setState(() {
      _countdownTime = 60;
    });
    const oneSec = const Duration(seconds: 1);

    var callback = (timer) => {
          setState(() {
            if (_countdownTime < 1) {
              canGet = true;
              _timer?.cancel();
            } else {
              _countdownTime = _countdownTime - 1;
            }
          })
        };

    _timer = Timer.periodic(oneSec, callback);
  }

  next() {
    return () {
      String phone = phoneController.text;
      String code = codeController.text;
      if (!StringUtil.isPhoneNumber(phone)) {
        showToast("请输入正确的手机号");
        return;
      }
      if (code == null || code.length == 0) {
        showToast("请输入验证码");
        return;
      }
      http
          .get(SpCommonUtil.getHost() +
              ServerApis.getVcodeToken +
              "?phone=$phone&&vcode=$code")
          .then((response) {
        if (response.statusCode == 200) {
          print(response.body);
          String codeToken = json.decode(response.body)["data"];

          if (StringUtil.isEmpty(codeToken)) {
            showToast("验证码错误");
            return;
          }

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      new ResetPassword(phone: phone, token: codeToken)));
        }
      });
    };
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }
}
