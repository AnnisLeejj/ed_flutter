import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ed_flutter/constant/constant.dart';
import 'package:ed_flutter/constant/dimens.dart';
import 'package:ed_flutter/constant/style.dart';
import 'package:ed_flutter/utils/HttpUtil.dart';
import 'package:ed_flutter/utils/SpUtil.dart';
import 'package:ed_flutter/utils/StringUtil.dart';
import 'package:ed_flutter/utils/ToastUtil.dart';
import 'package:ed_flutter/utils/mHttp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../MainPage.dart';
import 'SelectorEvironment.dart';
import 'forget.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginContainerState();
}

class LoginContainerState extends State<LoginPage> {
  final phoneController = TextEditingController();
  final pswController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
          child: Stack(
        children: <Widget>[
          Image(
            width: double.infinity,
            height: double.infinity,
            image: AssetImage("assets/images/app_login_bg.png"),
            fit: BoxFit.fill,
          ),
          _getLoginContent()
        ],
      )),
    );
  }

  Widget _getLoginContent() {
    final top = SpCommonUtil.prefsCommon.getString(SpConstant.spTopLogo);
    final bottom = SpCommonUtil.prefsCommon.getString(SpConstant.spBottomLogo);
    return Column(
      children: <Widget>[
        Container(
          height: 250,
          padding: EdgeInsets.fromLTRB(30.0, 100.0, 30.0, 10.0),
          child: Center(
            child: CachedNetworkImage(
              imageUrl: top,
              placeholder: (context, url) => SizedBox(
                child: new CircularProgressIndicator(),
                width: 20,
                height: 20,
              ),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          ),
        ),
        Expanded(
            child: Container(
          padding: EdgeInsets.fromLTRB(45, 0, 45, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                height: 40,
              ),
              TextFormField(
                decoration: new InputDecoration(
                  hintText: "请输入手机号",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11)
                ],
                controller: phoneController,
              ),
              Container(
                height: 20,
              ),
              TextFormField(
                controller: pswController,
                obscureText: true,
                decoration: new InputDecoration(
                  hintText: "请输入密码",
                ),
                keyboardType: TextInputType.url,
              ),
              Container(
                height: 30,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                padding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                minWidth: double.infinity,
                height: Dimens.buttonHeight,
                color: ColorDef.colorPrimary,
                textTheme: ButtonTextTheme.primary,
                child: new Text('登 录'),
                disabledColor: Colors.black12,
                onPressed: clickListener,
              ),
              Container(
                height: 20,
              ),
              GestureDetector(
                child: Text(
                  "忘记密码?",
                  style: textStyle.apply(color: Colors.grey),
                ),
                onTap: forgot,
              ),
              Container(
                height: 15,
              ),
              GestureDetector(
                child: Text(
                  "切换环境",
                  style:
                      textStyle.apply(color: Color.fromARGB(255, 255, 125, 71)),
                ),
                onTap: change,
              ),
            ],
          ),
        )),
        Container(
          padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
          child: CachedNetworkImage(
            imageUrl: bottom,
            placeholder: (context, url) => new CircularProgressIndicator(),
            errorWidget: (context, url, error) => new Icon(Icons.error),
          ),
        )
      ],
    );
  }

  clickListener() {
    String phone = phoneController.text;
    if (StringUtil.isEmpty(phone)) {
      showToast("请输入手机号");
      return;
    }
    String psw = pswController.text;
    if (StringUtil.isEmpty(phone)) {
      showToast("请输入密码");
      return;
    }
    String url = SpCommonUtil.getHost() + ServerApis.login;
    http.post(url, body: {
      "username": phone,
      "password": StringUtil.generateMd5(psw)
    }).then((r) {
      if (HttpUtil.isSuccessAndShowErrorMsg(r)) {
        var mJson = json.decode(r.body);
        var data = mJson["data"];
        //组装数据并保存
        SpCommonUtil.saveToken(data["token"]);
        getUserInfo(data["userId"]);
      }
    }).catchError((e) {
      showToast("登录失败");
    });
  }

  getUserInfo(String userId) {
    String url = SpCommonUtil.getHost() + ServerApis.getUser + "$userId";
    http.get(url).then((r) {
      if (HttpUtil.isSuccessAndShowErrorMsg(r)) {
        var mJson = json.decode(r.body);
        print(r.body);
        var data = mJson["data"];
        String userInfo = json.encode(data);
        SpCommonUtil.saveLastUserInfo(userInfo);
        SpCommonUtil.saveLastUserName(data["realName"]);
        getUserPermission(userId);
        SpCommonUtil.saveLastUserID(userId);
      }
    }).catchError((e) {
      showToast("获取用户信息失败");
    });
  }

  getUserPermission(String userId) {
    String url = SpCommonUtil.getHost() +
        ServerApis.getUserPermission +
        "?userId=$userId&platformType=2";
    print("getUserPermission:$url");
    //继续获取用户权限
    tokenGet(url).then((r) {
      print("getUserPermission:${r.body}");
      if (HttpUtil.isSuccessAndShowErrorMsg(r)) {
        var mJson = json.decode(r.body);
        var data = mJson["data"];
        SpCommonUtil.saveIsSignIn(true);
        SpCommonUtil.saveUserPermission(json.encode(data));
        Navigator.pushAndRemoveUntil(
            context,
            new MaterialPageRoute(builder: (context) => new MainPage()),
            ModalRoute.withName("/login"));
      }
    }).catchError((e) {
      showToast("获取用户信息失败");
      print(e);
    });
  }

  forgot() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new Forget(), maintainState: false));
  }

  change() {
    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new SelectorEnvironmentPage(fromLogin: true),
          maintainState: false),
    );
  }
}
