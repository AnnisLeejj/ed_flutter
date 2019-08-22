import 'package:ed_flutter/constant/constant.dart';
import 'package:ed_flutter/constant/dimens.dart';
import 'package:ed_flutter/utils/HttpUtil.dart';
import 'package:ed_flutter/utils/SpUtil.dart';
import 'package:ed_flutter/utils/StringUtil.dart';
import 'package:ed_flutter/utils/ToastUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangePswPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChangePswPageState();
}

class _ChangePswPageState extends State<ChangePswPage> {
  TextEditingController _controllerOld = TextEditingController();
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("修改密码"),
        centerTitle: true,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                _change();
              },
              child: Text(
                "保存",
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            decoration: UnderlineTabIndicator(
              borderSide: BorderSide(width: 0.5, color: ColorDef.gray),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: Dimens.marginWindowM,
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    "原密码",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                  width: Dimens.marginWindowB,
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "请输入原密码", border: InputBorder.none),
                    controller: _controllerOld,
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: UnderlineTabIndicator(
              borderSide: BorderSide(width: 0.5, color: ColorDef.gray),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: Dimens.marginWindowM,
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    "新密码",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                  width: Dimens.marginWindowB,
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "请输入新密码", border: InputBorder.none),
                    controller: _controller1,
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: UnderlineTabIndicator(
              borderSide: BorderSide(width: 0.5, color: ColorDef.gray),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: Dimens.marginWindowM,
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    "确认密码",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                  width: Dimens.marginWindowB,
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "请确认密码", border: InputBorder.none),
                    controller: _controller2,
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _change() {
    var old = _controllerOld.text;
    if (StringUtil.isEmpty(old)) {
      showToast("请输入原密码");
      return;
    }
    if (StringUtil.isEmpty(_controller1.text)) {
      showToast("请输入新密码");
      return;
    }
    if (StringUtil.isEmpty(_controller2.text)) {
      showToast("请确认密码");
      return;
    }
    if (_controller1.text != _controller2.text) {
      showToast("新密码不一致");
      return;
    }

//    @POST("app/sysUser/modifyPwd/{userId}")
//    Flowable<BaseResponse<String>> modifyPwd(@Path("userId") String userId, @Query("oldPwd") String oldPwd, @Query("newPwd") String newPwd);
    String id  = SpCommonUtil.getLastUserID();
    String url = ServerInfo.getBaseHost() +
        ServerApis.changePwd ;
    showToast("$id");
//    http.post(url, body: {"oldPwd": old, "newPwd": _controller2.text}).then(
//        (r) {
//      print(r.body);
//      showToast("2222");
//      if (HttpUtil.isSuccessAndShowErrorMsg(r)) {
//        showToast(HttpUtil.getMessage(r));
//        Navigator.pop(context);
//      }
//    }).catchError((e) {
//      showToast("请求失败!");
//    });
  }
}
