import 'dart:convert';

import 'package:ed_flutter/constant/constant.dart';
import 'package:ed_flutter/utils/SpUtil.dart';
import 'package:ed_flutter/utils/StringUtil.dart';
import 'package:ed_flutter/utils/ToastUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amap/location.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

//import 'package:flutter_amap/flutter_amap.dart';
import 'package:amap_location/amap_location.dart';
import 'package:simple_permissions/simple_permissions.dart';

class Weather extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WeatherState();
}

const String psLastWeather = "psLastWeather";

class _WeatherState extends State<Weather> with AutomaticKeepAliveClientMixin {
//  final _aMapLocation = AMapLocation();
  AMapLocation _result;

//  FlutterAmap amap = new FlutterAmap();
  String environmentName = "环境";
  String dataStr = "data";
  String weatherStr = "晴";
  String temperatureStr = "-";
  String windStr = "风向:~";

  Map weatherImg = {
    "晴": "assets/images/weather/common_weather_sun.png",
    "多云": "assets/images/weather/common_weather_cloudy_sky.png",
    "阴": "assets/images/weather/common_weather_cloudy.png",
    "雷阵雨": "assets/images/weather/common_weather_thunderstorm.png",
    "雨夹雪": "assets/images/weather/common_weather_rain_snow.png",
    "小雨": "assets/images/weather/common_weather_small_rain.png",
    "中雨": "assets/images/weather/common_weather_small_rain.png",
    "大雨": "assets/images/weather/common_weather_small_rain.png",
    "小雪": "assets/images/weather/common_weather_snow.png",
    "中雪": "assets/images/weather/common_weather_snow.png",
    "大雪": "assets/images/weather/common_weather_snow.png",
    "雾": "assets/images/weather/common_weather_wind.png",
    "龙卷风": "assets/images/weather/common_weather_waterspout.png"
  };

  @override
  void initState() {
    super.initState();
    getEnvironmentName();
    dataStr = DateFormat("M月d日  E").format(new DateTime.now());

    _checkPersmission(context);
  }

  getEnvironmentName() async {
    SpCommonUtil.getCommon().then((sp) {
      String name = sp.getString(SpConstant.spName);
      setState(() {
        environmentName = name;
      });
      String weatherJson = sp.getString(psLastWeather);
      if (!StringUtil.isEmpty(weatherJson)) {
        var decode = json.decode(weatherJson);
        if (decode != null) {
          setWeatherView(decode);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      width: double.infinity,
      height: 135,
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
            flex: 5,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    width: 35,
                    height: 35,
                    image: AssetImage(weatherImg[weatherStr]),
                  ),
                  Container(
                    width: 10,
                  ),
                  Text(
                    temperatureStr,
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    alignment: Alignment.topCenter,
                    child: Text(
                      "℃",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  Text(
                    weatherStr,
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  )
                ],
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  dataStr,
                  style: TextStyle(color: Colors.white, fontSize: 14),
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
//                    "Text",
                    _result == null ? "     " : _result.district,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  )
                ],
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: Text(
                  windStr,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _checkPersmission(BuildContext context) async {
    bool hasPermission =
    await SimplePermissions.checkPermission(Permission.WhenInUseLocation);
    print("定位权限:$hasPermission");
    if (!hasPermission) {
      PermissionStatus requestPermissionResult =
      await SimplePermissions.requestPermission(
          Permission.WhenInUseLocation);
      if (requestPermissionResult != PermissionStatus.authorized) {
        showToast("申请定位权限失败");
        return;
      }
    }
    getLocal(context);
  }

  void getLocal(BuildContext context) async {
    print("准备获取定位");
//    AMapLocationClient.getLocation(true).then((loc) {
//      print("获取到定位");
//      if (!mounted) return;
//      setState(() {
//        _result = loc;
//      });
//    });
    await AMapLocationClient.startup(new AMapLocationOption(
        desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
    AMapLocationClient.onLocationUpate.listen((AMapLocation loc) {
      print("获取到定位");
      if (!mounted) return;
      setState(() {
        _result = loc;
        getWeather(_result.city);
      });
      AMapLocationClient.stopLocation();
    });
    AMapLocationClient.startLocation();
  }

  getWeather(String city) {
    city = city.replaceAll("市", "").replaceAll("省", "");
    post("http://apis.juhe.cn/simpleWeather/query",
        body: {"city": city, "key": "821923cb9b0117a31c4d4ce9f1904d26"})
        .then((r) {
      var decode = json.decode(r.body);
      if (decode == null) {
        return;
      }
      if (decode["error_code"] != 0) {
        return;
      }
      var realtime = decode["result"]["realtime"];
      var city = decode["result"]["city"];
      if (realtime == null) {
        return;
      }
      SpCommonUtil.getCommon().then((sp) {
        sp.setString(psLastWeather, json.encode(realtime));
      });
      realtime["city"] = city;
      setWeatherView(realtime);
    });
  }

  setWeatherView(var realtime) {
    //city :"重庆",
    //  {
//      "temperature": "31",
//      "humidity": "59",
//      "info": "阴",
//      "wid": "02",
//      "direct": "西南风",
//      "power": "2级",
//      "aqi": "50"
//      },
//    print(realtime);
    setState(() {
      weatherStr = realtime["info"];
      temperatureStr = realtime["temperature"];
      windStr = "风向:${realtime["direct"]} ${realtime["power"]}";
    });
  }

  @override
  void dispose() {
//    _aMapLocation.stopLocate();
    //注意这里关闭
    AMapLocationClient.shutdown();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
