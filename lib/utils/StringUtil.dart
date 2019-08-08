import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class StringUtil {
  ///判断是不是手机号
  static bool isPhoneNumber(String phone) {
    RegExp postalcode = new RegExp(
        "^(13[0-9]|15[0-3]|15[5-9]|18[0-9]|14[57]|17[0678]|19[0-9])\\d{8}\$");
    return postalcode.hasMatch(phone);
//    Pattern pattern = Pattern
//        .compile(
//        "^(13[0-9]|15[0-3]|15[5-9]|18[0-9]|14[57]|17[0678]|19[0-9])\\d{8}$");
//    Matcher matcher = pattern.matcher(phone);
//    return matcher.matches();
  }

  ///判断是否为空
  static bool isEmpty(String codeToken) {
    return codeToken == null || codeToken.length == 0;
  }

  /// md5 加密
  static String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }
}
