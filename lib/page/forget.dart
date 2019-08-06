import 'package:ed_flutter/constant/dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Forget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  final phoneController = TextEditingController()

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
          children: <Widget>[TextFormField(
            decoration: new InputDecoration(
              hintText: "请输入手机号",
            ),
            keyboardType: TextInputType.number,
            controller: phoneController,
          ),
            Stack(
              children: <Widget>[
                TextFormField(
                  decoration: new InputDecoration(
                    hintText: "请输入验证码",
                  ),
                  keyboardType: TextInputType.number,
                  controller: phoneController,
                ),
                Container(
                  child: Text("获取验证码", style: TextStyle(color: Colors.white),),
                  decoration: BoxDecoration(border: new Border.all(
                      color: Color(0xFFFFFF00), width: 0.5),
                    // 边色与边宽度
                    color: Color(0xFF9E9E9E),
                    // 底色
                    //        shape: BoxShape.circle, // 圆形，使用圆形时不可以使用borderRadius
                    shape: BoxShape.rectangle,
                    // 默认值也是矩形
                    borderRadius: new BorderRadius.circular((20.0)), // 圆角度
                  ),),
                new Align(
                  alignment: new FractionalOffset(0.0, 0.0),
                  child: new Image.network(
                      'http://up.qqjia.com/z/25/tu32710_10.jpg'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
