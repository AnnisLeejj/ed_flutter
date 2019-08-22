import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ed_flutter/constant/dimens.dart';
import 'package:ed_flutter/utils/SpUtil.dart';
import 'package:ed_flutter/utils/StringUtil.dart';
import 'package:ed_flutter/utils/ToastUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

class PersonalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PersonalState();
  }
}

class PersonalState extends State<PersonalPage> {
  File selectedHeader;

  dynamic info;

  @override
  void initState() {
    super.initState();
    SpCommonUtil.getCommon().then((sp) {
      String jsonUser = SpCommonUtil.getLastUserInfo();
      print("User:$jsonUser");
      setState(() {
        info = jsonDecode(jsonUser);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                popPage(context);
              },
              child: Text(
                selectedHeader == null ? "返回" : "保存",
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
        ],
        centerTitle: true,
        title: Text("个人中心"),
      ),
      body: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              selectHeader();
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  Dimens.marginWindowM, 0, Dimens.marginWindowM, 0),
              alignment: Alignment.centerLeft,
              width: double.infinity,
              height: 60,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "头像",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ClipOval(child: getHeader()),
                        Container(
                          width: Dimens.marginWindowS,
                        ),
                        Image(
                          width: 10,
                          height: 10,
                          image: AssetImage("assets/images/ic_more_gray.png"),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            color: Color.fromARGB(255, 244, 244, 244),
            height: Dimens.marginWindowS,
          ),
          getChild("账号", info == null ? "" : info["username"]),
          getChild("姓名", info == null ? "" : info["realName"]),
          getChild("角色", info == null ? "" : info["roleNames"]),
          getChild("所属单位", info == null ? "" : info["username"]),
          getChild("所属部门", info == null ? "" : info["deptName"]),
          getChild("邮箱", info == null ? "" : info["email"]),
          getChild("职务", info == null ? "" : info["job"]),
        ],
      ),
    );
  }

  Widget getHeader() {
    String userAvatar;
    if (selectedHeader == null) {
      if (info != null) {
        userAvatar = info["avatar"];
      }
      if (StringUtil.isEmpty(userAvatar)) {
        return Image(
          width: 55,
          height: 55,
          image: AssetImage("assets/images/ic_avatar.png"),
        );
      } else {
        return CachedNetworkImage(
          height: 55,
          width: 55,
          imageUrl: userAvatar,
          fit: BoxFit.cover,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        );
      }
    } else {
      return Image.file(
        selectedHeader,
        height: 55,
        fit: BoxFit.cover,
        width: 55,
      );
    }
  }

  Widget getChild(String title, String content) {
    if (content == null) {
      content = "";
    }
    return Container(
      padding:
          EdgeInsets.fromLTRB(Dimens.marginWindowM, 0, Dimens.marginWindowM, 0),
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: 60,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 150, 150, 150),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future selectHeader() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedHeader = image;
    });
  }

  popPage(BuildContext context) {
    if (selectedHeader != null) {
      _upload(context, selectedHeader);
    } else {
      Navigator.pop(context, false);
    }
  }

  _upload(BuildContext context, File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(SpCommonUtil.getHost() + "upload/file");

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    request.files.add(multipartFile);
    var response = await request.send();
    if (response.statusCode == 200) {
      showToast("修改成功!");
      response.stream.transform(utf8.decoder).listen((value) {
        print("response:$value");
        var decode = jsonDecode(value);
        String url = decode["data"]["url"];
        info["avatar"] = url;
        print("User:${jsonEncode(info)}");
        SpCommonUtil.saveLastUserInfo(jsonEncode(info));
        Navigator.pop(context, true);
      });
    } else {
      showToast("提交失败!");
    }
  }
}
