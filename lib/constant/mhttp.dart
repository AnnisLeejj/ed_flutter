class BaseResponse<T> {
  static final int SuccessCode = 100000;
  int code;
  String message;
  T data;

  BaseResponse({this.code, this.message, this.data});

  bool isSuccess() {
    return SuccessCode == code;
  }

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return new BaseResponse(
      code: json['code'],
      message: json['message'],
      data: json['data'],
    );
  }
}
