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
}
