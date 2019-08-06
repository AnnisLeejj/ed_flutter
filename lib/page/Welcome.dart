import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constant/constant.dart';
import '../constant/dimens.dart';
import '../constant/mhttp.dart';
import '../utils/SpUtil.dart';
import '../utils/ToastUtil.dart';
import 'Login.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List<dynamic> mList = <dynamic>[];
  int checkedPosition = -1;
  bool isLoading = false;

  Widget _getLoadingView() {
    if (isLoading) {
      return Center(
        child: SizedBox(
          child: CircularProgressIndicator(
            strokeWidth: 5,
          ),
          width: 70,
          height: 70,
        ),
      );
    } else {
      return new ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: mList.length,
          itemBuilder: (context, position) {
            return getChild(context, position);
          });
    }
  }

  void _setLoadingView(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  Widget getChild(BuildContext context, int position) {
//    _key = new GlobalKey<ScaffoldState>();
    return Container(
      child: GestureDetector(
        onTap: () {
          setState(() {
            checkedPosition = position;
          });
        },
        child: Row(
          children: <Widget>[
            SizedBox(
              width: Dimens.marginWindow,
            ),
            Expanded(
              child: Text('${position + 1}. ${mList[position]['name']}'),
            ),
            Checkbox(
              activeColor: ColorDef.colorPrimary, //选中时的颜色
              onChanged: (bool checked) {
                setState(() {
                  checkedPosition = position;
                });
              },
              value: checkedPosition == position,
            )
          ],
        ),
      ),
    );
  }

  void _loadList() async {
    final url = ServerInfo.ip_host + ServerApis.getEnvironment;
    print(url);
    final response = await http.get(url);
    final jsonObject = json.decode(response.body);
    BaseResponse<List<dynamic>> baseResponse =
        new BaseResponse<List<dynamic>>.fromJson(jsonObject);
    setState(() {
      print(baseResponse);
      mList = baseResponse.data;
    });
  }

  clickListener() {
    if (isLoading) {
      return null;
    } else {
      return () {
        _toLogin();
      };
    }
  }

  void _toLogin() async {
    if (checkedPosition == -1) {
      showToast('请选择环境');
      return;
    }
    _setLoadingView(true);
    var checked = mList[checkedPosition];
    String host =
        "http://${checked['ip']}:${checked['port']}/${checked['code']}/";
    SpCommonUtil.getCommon().then((onValue) {
      onValue.setString(SpConstant.spHost, host);
      onValue.setString(SpConstant.spIp, checked['ip']);
      onValue.setString(SpConstant.spName, checked['name']);
      _getLogo();
    });
  }

  void _getLogo() async {
    await http
        .get(SpCommonUtil.getHost() + ServerApis.getLogo)
        .timeout(Duration(seconds: 10))
        .then((response) {
      final jsonObject = json.decode(response.body);
      var object = jsonObject['data'];
      SpCommonUtil.getCommon().then((onValue) {
        onValue.setString(SpConstant.spTopLogo, object['appTopLogo']['url']);
        onValue.setString(
            SpConstant.spBottomLogo, object['appBottomLogo']['url']);
      }).whenComplete(() {
        _setLoadingView(false);
        toLogin();
      });
    }).catchError(((e) {
      _setLoadingView(false);
      showToast("加载失败");
    }));
  }

  void toLogin() async {
    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new LoginPage(), maintainState: false),
    );
  }

  void _initSP() async {
    SpCommonUtil.getCommon();
  }

  @override
  void initState() {
    super.initState();
    _initSP();
    _loadList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
      padding: EdgeInsets.only(top: 60),
      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
              alignment: Alignment.center,
              image: AssetImage("assets/images/welcome_logo.png"),
              height: 200.0),
          Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                '欢迎进入',
                style: TextStyle(
                  fontSize: 35,
                ),
              )),
          Container(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                '请在列表中选择使用环境',
                style: TextStyle(
                  color: ColorDef.textGray,
                  fontSize: 16,
                ),
              )),
          Expanded(child: _getLoadingView()),
          Container(
            padding: EdgeInsets.fromLTRB(Dimens.marginWindow, 0,
                Dimens.marginWindow, Dimens.marginWindow),
            child: MaterialButton(
              padding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              minWidth: double.infinity,
              height: Dimens.buttonHeight,
              color: ColorDef.colorPrimary,
              textTheme: ButtonTextTheme.primary,
              child: new Text('进入'),
              disabledColor: Colors.black12,
              onPressed: clickListener(),
            ),
          )
        ],
      ),
    ));
  }
}
