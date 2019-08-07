import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class mHttp extends http.BaseClient {
  final String token;
  final http.Client _inner;

  mHttp(this.token, this._inner);

  Future<StreamedResponse> send(BaseRequest request) {
    request.headers['user-agent'] = token;
    return _inner.send(request);
  }
}
