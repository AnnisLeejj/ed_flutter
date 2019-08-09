import 'dart:convert';

import 'package:amap_base/amap_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final _aMapLocation = AMapLocation();
  Location _result;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MaterialButton(
          child: Text("获取定位"),
          onPressed: () {
            getLocal(context);
          },
        ),
        new Text("${_result == null ? "-null-" : json.encode(_result)}"),
      ],
    );
  }

  getLocal(BuildContext context) async {
    final options = LocationClientOptions(
      isOnceLocation: true,
      locatingWithReGeocode: true,
    );

    if (await Permissions().requestPermission()) {
      await _aMapLocation.init();

      _aMapLocation.getLocation(options).then((localtion) {
        setState(() {
          _result = localtion;
        });
      }).catchError((e) {
        print("print catchError:$e");
      });
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('权限不足')));
    }
  }

  @override
  void dispose() {
    _aMapLocation.stopLocate();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
