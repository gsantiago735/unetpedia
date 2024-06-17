import 'package:unetpedia/models/generic/user_response_model.dart';

class RegisterResponseModel {
  final UserResponseModel? user;
  final String? presignedURL;

  RegisterResponseModel({
    this.user,
    this.presignedURL,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      RegisterResponseModel(
        user: json["data"] == null
            ? null
            : UserResponseModel.fromJson(json["data"]),
        presignedURL: json["presignedURL"],
      );

  Map<String, dynamic> toJson() => {
        "data": user?.toJson(),
      };
}
