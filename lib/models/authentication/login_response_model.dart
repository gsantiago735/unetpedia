class LoginResponseModel {
  final String? message;
  final String? idToken;
  final String? refreshToken;
  final String? accessToken;

  LoginResponseModel({
    this.message,
    this.idToken,
    this.refreshToken,
    this.accessToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        message: json["message"],
        idToken: json["IdToken"],
        refreshToken: json["RefreshToken"],
        accessToken: json["AccessToken"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "IdToken": idToken,
        "RefreshToken": refreshToken,
        "AccessToken": accessToken,
      };
}
