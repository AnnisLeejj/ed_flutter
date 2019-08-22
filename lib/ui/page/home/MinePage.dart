import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ed_flutter/constant/constant.dart';
import 'package:ed_flutter/constant/dimens.dart';
import 'package:ed_flutter/ui/page/unlogin/Login.dart';
import 'package:ed_flutter/utils/SpUtil.dart';
import 'package:ed_flutter/utils/StringUtil.dart';
import 'package:ed_flutter/utils/ToastUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import 'mine/ChangePswPage.dart';
import 'mine/PersonalPage.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  String userAvatar;
  String userName;
  String versionCode = "";

  @override
  void initState() {
    super.initState();
    loadUserInfo();
    _loadVersion();
  }

  _loadVersion() {
    PackageInfo.fromPlatform().then((info) {
      setState(() {
        versionCode = info.version;

        if (StringUtil.isEmpty(versionCode)) {
          versionCode = "";
        }
      });
    });
  }

  loadUserInfo() {
    SpCommonUtil.getCommon().then((sp) {
      String jsonUser = SpCommonUtil.getLastUserInfo();
      print("User:$jsonUser");
      var decode = jsonDecode(jsonUser);
      setState(() {
        userAvatar = decode["avatar"];
        userName = decode["realName"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).padding.top,
          color: ColorDef.colorPrimary,
        ),
        GestureDetector(
          onTap: () async {
            final result = await Navigator.push<bool>(context,
                MaterialPageRoute(builder: (context) => PersonalPage()));
            if (result) {
              loadUserInfo();
            }
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(
                Dimens.marginWindowM,
                Dimens.marginWindowS,
                Dimens.marginWindowM,
                Dimens.marginWindowS),
            width: double.infinity,
            height: 105,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 49, 126, 245),
                  Color.fromARGB(190, 49, 126, 245)
                ],
              ),
            ),
            child: Stack(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 80,
                      height: 80,
                      child: ClipOval(child: getHeader()),
                    ),
                    Container(
                      width: 10,
                    ),
                    Text(
                      userName == null ? "" : userName,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Image(
                    image: AssetImage("assets/images/ic_more_white.png"),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              getChild("assets/images/ic_pass.png", "修改密码",
                  "assets/images/ic_more_gray.png", () {
                startNextPage(ChangePswPage());
              }),
              getChild("assets/images/ic_audio.png", "播报设置",
                  "assets/images/ic_more_gray.png", () {}),
              getChild("assets/images/ic_push.png", "推送设置",
                  "assets/images/ic_more_gray.png", () {}),
              getChild("assets/images/ic_update_blue.png", "数据更新",
                  "assets/images/ic_update_gray.png", () {}),
              getChild("assets/images/ic_version_name.png", "版本信息",
                  "assets/images/ic_more_gray.png", () {}),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(Dimens.marginWindowM),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            padding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            minWidth: double.infinity,
            height: Dimens.buttonHeight,
            color: ColorDef.buttonGray,
            textTheme: ButtonTextTheme.primary,
            child: new Text('退 出 登 录'),
            onPressed: () {
              logout();
            },
          ),
        )
      ],
    );
  }

  Widget getHeader() {
    if (StringUtil.isEmpty(userAvatar)) {
      return Image(
        width: 80,
        height: 80,
        image: AssetImage("assets/images/ic_avatar.png"),
      );
    } else {
      return CachedNetworkImage(
        height: 80,
        width: 80,
        imageUrl: userAvatar,
        fit: BoxFit.cover,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    }
  }

  Widget getChild(String ic, String title, String icRight, Function function) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        decoration: UnderlineTabIndicator(
          borderSide: BorderSide(width: 1, color: ColorDef.gray),
        ),
        height: 70,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(Dimens.marginWindowM, Dimens.marginWindowS,
            Dimens.marginWindowM, Dimens.marginWindowS),
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Image(
                        width: 15,
                        height: 15,
                        image: AssetImage(ic),
                      ),
                      Container(
                        width: 10,
                      ),
                      Text(title),
                    ],
                  ),
                ),
                Text(
                  getSubTitle(title),
                  style: TextStyle(color: ColorDef.textGray),
                ),
                Container(
                  width: 10,
                ),
                Image(
                  width: 13,
                  height: 13,
                  image: AssetImage(icRight),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getSubTitle(String title) {
    if (title == "版本信息") {
      return versionCode;
    } else {
      return "";
    }
  }

  logout() {
    SpCommonUtil.getCommon().then((sp) {
      SpCommonUtil.saveIsSignIn(false);
      stopService();
      Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(builder: (context) => new LoginPage()),
          ModalRoute.withName("/main"));
    });
  }

  startNextPage(Widget widget) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => widget, maintainState: false));
  }

  stopService() {}
}
