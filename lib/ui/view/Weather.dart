import 'package:flutter/cupertino.dart';

class Weather extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("天气"),
        Text("天气"),
        Text("天气"),
        Text("天气"),
        Text("天气")
      ],
    );
  }
}
