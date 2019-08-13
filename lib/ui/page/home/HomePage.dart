import 'dart:convert';

import 'package:amap_base/amap_base.dart';
import 'package:ed_flutter/constant/constant.dart';
import 'package:ed_flutter/ui/view/Weather.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).padding.top,
          color: ColorDef.colorPrimary,
        ),
        Weather(),
        MaterialButton(
          child: Text("获取定位"),
          onPressed: () {},
        ),

      ],
    );
  }
}
