import 'dart:convert';

import 'package:amap_base/amap_base.dart';
import 'package:ed_flutter/constant/constant.dart';
import 'package:ed_flutter/utils/SpUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class Weather extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> with AutomaticKeepAliveClientMixin {
  final _aMapLocation = AMapLocation();
  Location _result;

  String environmentName = "环境";
  String dataStr = "data";

  @override
  void initState() {
    super.initState();
    getEnvironmentName();
    dataStr = DateFormat("M月d日  E").format(new DateTime.now());

    getLocal(context);
  }

  getEnvironmentName() async {
    SpCommonUtil.getCommon().then((sp) {
      String name = sp.getString(SpConstant.spName);
      setState(() {
        environmentName = name;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 49, 126, 245),
            Color.fromARGB(190, 49, 126, 245)
          ],
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                SizedBox(
                  child: Image(
                    image: AssetImage("assets/images/ic_title.png"),
                  ),
                  width: 20,
                  height: 20,
                ),
                Text(
                  environmentName,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                )
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Row(
                children: <Widget>[],
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  dataStr,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    width: 15,
                    height: 15,
                    image: AssetImage("assets/images/ic_location.png"),
                  ),
                  Text(
                    _result == null ? "     " : _result.district,
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
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
//          localStr = _result.district;
          getWeather(_result.city);
          print("print success:$_result");
        });
      }).catchError((e) {
        print("print catchError:$e");
      });
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('权限不足')));
    }
  }

  getWeather(String city) {
    city = city.replaceAll("市", "").replaceAll("省", "");
    post("http://apis.juhe.cn/simpleWeather/query",
            body: {"city": city, "key": "821923cb9b0117a31c4d4ce9f1904d26"})
        .then((r) {
          var decode = json.decode(r.body);
          print(r.body);
    });
  }

  @override
  void dispose() {
    _aMapLocation.stopLocate();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
