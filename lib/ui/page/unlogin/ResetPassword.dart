import 'dart:convert';

import 'package:ed_flutter/constant/constant.dart';
import 'package:ed_flutter/constant/dimens.dart';
import 'package:ed_flutter/constant/mhttp.dart';
import 'package:ed_flutter/utils/SpUtil.dart';
import 'package:ed_flutter/utils/StringUtil.dart';
import 'package:ed_flutter/utils/ToastUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class ResetPassword extends StatelessWidget {
  String phone;
  String token;

  ResetPassword({@required this.phone, @required this.token});

  TextEditingController pswController = TextEditingController();
  TextEditingController pswController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置密码"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(
            Dimens.marginWindowB, 10, Dimens.marginWindowB, 0),
        child: Column(
          children: <Widget>[
            Container(
              height: 10,
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
              height: 10,
            ),
            TextFormField(
              controller: pswController2,
              obscureText: true,
              decoration: new InputDecoration(
                hintText: "请确认密码",
              ),
              keyboardType: TextInputType.url,
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
              child: new Text('确 认'),
              disabledColor: Colors.black12,
              onPressed: sure(context),
            ),
          ],
        ),
      ),
    );
  }

  sure(BuildContext context) {
    return () {
      String psw1 = pswController.text;
      String psw2 = pswController2.text;
      if (StringUtil.isEmpty(psw1)) {
        showToast("请输入密码");
        return;
      }
      if (StringUtil.isEmpty(psw2)) {
        showToast("请确认密码");
        return;
      }
      if (psw1 != psw2) {
        showToast("密码不一致");
        return;
      }

      http.post(SpCommonUtil.getHost() + ServerApis.modifyPwdWithVcodeToken,
          body: {
            "vcodeToken": token,
            "phone": phone,
            "newPwd": StringUtil.generateMd5(psw1)
          }).then((r) {
        print(r.body);
        if (r.statusCode == 200) {
          BaseResponse response = BaseResponse.fromJson(json.decode(r.body));
          if (response == null) {
            showToast("修改失败,请重试");
          } else {
            if (response.isSuccess()) {
              showToast("修改成功");
              Navigator.pop(context);
            } else {
              showToast(response.message);
            }
          }
        } else {
          showToast("修改失败,请重试");
        }
      });
    };
  }
}
