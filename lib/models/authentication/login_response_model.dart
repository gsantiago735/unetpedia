class LoginResponseModel {
  final String? message;
  final int? userId;
  final String? refreshToken;
  final String? accessToken;

  LoginResponseModel({
    this.message,
    this.userId,
    this.refreshToken,
    this.accessToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        message: json["message"],
        userId: json["user_id"],
        refreshToken: json["RefreshToken"],
        accessToken: json["AccessToken"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "user_id": userId,
        "RefreshToken": refreshToken,
        "AccessToken": accessToken,
      };
}
