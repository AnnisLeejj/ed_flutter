import 'dart:convert';

import 'package:ed_flutter/utils/ToastUtil.dart';
import 'package:http/http.dart';

class HttpUtil {
  static bool isSuccessAndShowErrorMsg(Response response) {
    if (response == null || response.statusCode != 200) {
      showToast("请求失败");
      print("请求失败:$response");
      return false;
    }

    ///根据 c/s 定义方案
    var decode = json.decode(response.body);
    var code = decode["code"];
    if (code != null && "100000" == "$code") {
      return true;
    }
    getMessage(decode);
    return false;
  }

  static getMessage(Response response, {String message}) {
    if (response == null || response.body == null) {
      showToast(message == null ? "请求失败" : message);
    } else {
      var decode = json.decode(response.body);

      ///根据 c/s 定义方案
      var msg = decode["message"];
      showToast(msg == null ? message : msg);
    }
  }
}
