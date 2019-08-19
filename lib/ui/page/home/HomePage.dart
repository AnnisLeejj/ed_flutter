import 'dart:convert';

import 'package:ed_flutter/constant/constant.dart';
import 'package:ed_flutter/constant/dimens.dart';
import 'package:ed_flutter/ui/view/Weather.dart';
import 'package:ed_flutter/utils/SpUtil.dart';
import 'package:ed_flutter/utils/StringUtil.dart';
import 'package:ed_flutter/utils/ToastUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> userResList = new List();
  final double childSize = 100;
  final double iconSize = 65;
  Map menus = {
    "app_bt_daily": "assets/images/menu/icon_day.png",
    "app_bt_night": "assets/images/menu/icon_night.png",
    "app_bt_decision": "assets/images/menu/icon_decision.png",
    "app_bt_maintain": "assets/images/menu/icon_maintain.png",
    "app_bt_fixed": "assets/images/menu/icon_fixed.png",
    "app_bt_structure_pick": "assets/images/menu/ic_structure_local.png",
    "app_bt_accept": "assets/images/menu/icon_accept.png",
    "app_bt_often": "assets/images/menu/icon_often.png",
    "app_bt_elec": "assets/images/menu/icon_elec.png",
    "app_bt_pile": "assets/images/menu/ic_pile_local.png",
    "app_bt_elec_maintain": "assets/images/menu/ic_elec_maintain.png",
    "app_bt_emergency_event": "assets/images/menu/ic_elec_urgency.png",
    "app_bt_security_check": "assets/images/menu/ic_security.png",
    "app_bt_disease_manager": "assets/images/menu/ic_disease.png",
  };

  @override
  void initState() {
    super.initState();
    loadPermission();
  }

  loadPermission() {
    String permissionJson = SpCommonUtil.getUserPermission();
    if (StringUtil.isEmpty(permissionJson)) {
      return;
    }
    var permission = jsonDecode(permissionJson);
    if (permission != null) {
      var userRes = permission["resourceTree"];
      if (userRes != null) {
        for (var item in userRes) {
          if (item["routeUrl"] == "app_page_main") {
            setState(() {
              userResList = item["children"];
              print("权限个数:${userResList.length}");
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int crossCount = width ~/ (childSize + 10);
    double childAspectRatio = (width / crossCount) / (childSize + 10);
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).padding.top,
          color: ColorDef.colorPrimary,
        ),
        Weather(),
        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(
                Dimens.marginWindowS, 0, Dimens.marginWindowS, 0),
            child: GridView.count(
              crossAxisCount: crossCount,
              childAspectRatio: childAspectRatio,
              children: List.generate(userResList.length, (index) {
                return getChild(index);
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget getChild(int index) {
    var item = userResList[index];
    if (item == null) {
      return null;
    }
    String routeUrl = item["routeUrl"];
    String imgUrl = menus["$routeUrl"];
    if (StringUtil.isEmpty(imgUrl)) {
      imgUrl = menus["app_bt_daily"];
    }
    return Center(
      child: GestureDetector(
        onTap: () {
          itemClick(routeUrl);
        },
        child: Container(
          height: childSize,
          width: childSize,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                height: iconSize,
                width: iconSize,
                image: AssetImage(imgUrl),
              ),
              Text(
                item["name"],
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  itemClick(String routeUrl) {
    showToast("路径:$routeUrl");
  }
}
