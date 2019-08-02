class BaseResponse<T> {
  static final String SuccessCode = '100000';
  String code;
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

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return new Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
