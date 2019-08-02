import 'package:fluttertoast/fluttertoast.dart';

void showToast(String msg) {
  if (msg != null && msg.isNotEmpty)
    Fluttertoast.showToast(
      msg: msg,
    );
}
