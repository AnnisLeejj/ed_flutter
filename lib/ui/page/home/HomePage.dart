import 'dart:convert';

import 'package:amap_base/amap_base.dart';
import 'package:ed_flutter/constant/constant.dart';
import 'package:ed_flutter/constant/dimens.dart';
import 'package:ed_flutter/ui/view/Weather.dart';
import 'package:ed_flutter/utils/SpUtil.dart';
import 'package:ed_flutter/utils/StringUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> userResList = new List();

  @override
  void initState() {
    super.initState();
    loadPermission();
  }

  loadPermission() {
    String permissionJson = SpCommonUtil.getUserPermission();
    print("------------------------------1----------------------------------");
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
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).padding.top,
          color: ColorDef.colorPrimary,
        ),
        Weather(),
        Container(
          padding: EdgeInsets.all(Dimens.marginWindow),
          child: GridView.count(
            shrinkWrap: true,
            // Create a grid with 2 columns in portrait mode, or 3 columns in
            // landscape mode.
            crossAxisCount: 3,
            // Generate 100 widgets that display their index in the List.
            children: List.generate(userResList.length, (index) {
              return Center(
                child: Text(
                  'Item $index',
                  style: Theme.of(context).textTheme.headline,
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}
