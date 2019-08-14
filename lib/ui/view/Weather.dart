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
  String weatherStr = "晴";
  String temperatureStr = "20";
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
                    padding: EdgeInsets.only(top: 23),
                    alignment: Alignment.topCenter,
                    child: Text(
                      "℃",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  Text(
                    weatherStr,
                    style: TextStyle(color: Colors.white, fontSize: 25),
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
                  style: TextStyle(color: Colors.white, fontSize: 15),
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
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  )
                ],
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: Text(
                  windStr,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
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
      if (decode == null) {
        return;
      }
      if (decode["error_code"] != 0) {
        return;
      }
      var realtime = decode["result"]["realtime"];
      if (realtime == null) {
        return;
      }
      print(realtime);
      setState(() {
        weatherStr = realtime["info"];
        temperatureStr = realtime["temperature"];
        windStr = "风向:${realtime["direct"]} ${realtime["power"]}";
      });
//       {
//      "temperature": "31",
//      "humidity": "59",
//      "info": "阴",
//      "wid": "02",
//      "direct": "西南风",
//      "power": "2级",
//      "aqi": "50"
//      },
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
