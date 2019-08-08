import 'dart:convert';

import 'package:ed_flutter/constant/constant.dart';
import 'package:ed_flutter/utils/SpUtil.dart';
import 'package:http/http.dart';

class mHttp extends BaseClient {
  final String token;
  final Client _inner;

  mHttp(this.token, this._inner);

  Future<StreamedResponse> send(BaseRequest request) {
    request.headers['user-agent'] = token;
    return _inner.send(request);
  }
}

Future<Response> tokenGet(String url, {Map<String, String> headers}) {
  if (headers == null) {
    headers = {};
  }
  headers[ServerApis.TOKEN_HEADER] = SpCommonUtil.getToken();
  headers["platform"] = "2";
  return get(url, headers: headers);
}

Future<Response> tokenPost(String url,
    {Map<String, String> headers, body, Encoding encoding}) {
  if (headers == null) {
    headers = {};
  }
  headers[ServerApis.TOKEN_HEADER] = SpCommonUtil.getToken();
  headers["platform"] = "2";
  return post(url, headers: headers, body: body);
}
