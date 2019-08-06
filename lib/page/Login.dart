import 'package:cached_network_image/cached_network_image.dart';
import 'package:ed_flutter/constant/constant.dart';
import 'package:ed_flutter/constant/dimens.dart';
import 'package:ed_flutter/constant/style.dart';
import 'package:ed_flutter/utils/SpUtil.dart';
import 'package:ed_flutter/utils/ToastUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    print("SpCommonUtil.prefsCommon:${SpCommonUtil.prefsCommon == null}");
    final top = SpCommonUtil.prefsCommon.getString(SpConstant.spTopLogo);
    final bottom = SpCommonUtil.prefsCommon.getString(SpConstant.spBottomLogo);
    print("logo top:     $top");
    print("logo bottom:  $bottom");
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
          padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
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
                padding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                minWidth: double.infinity,
                height: Dimens.buttonHeight,
                color: ColorDef.colorPrimary,
                textTheme: ButtonTextTheme.primary,
                child: new Text('登 录'),
                disabledColor: Colors.black12,
                onPressed: clickListener(),
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
    return () {
      showToast("密码:${pswController.text}");
    };
  }

  forgot() {
    showToast("忘记密码");
  }

  change() {
    showToast("切换环境");
  }
}
