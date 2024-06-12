import 'package:unetpedia/models/generic/degrees_response_model.dart';

class RegisterResponseModel {
  //final List<String>? errors;
  final User? user;

  RegisterResponseModel({
    //this.errors,
    this.user,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      RegisterResponseModel(
        //errors: json["errors"] == null ? [] : List<String>.from(json["errors"]!.map((x) => x)),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        //"errors": errors == null ? [] : List<dynamic>.from(errors!.map((x) => x)),
        "user": user?.toJson(),
      };
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final int? roleId;
  final String? description;
  final int? careerId;
  final DegreesResponseModel? career;
  final DegreesResponseModel? role;

  User({
    this.id,
    this.name,
    this.email,
    this.roleId,
    this.description,
    this.careerId,
    this.career,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        roleId: json["role_id"],
        description: json["description"],
        careerId: json["career_id"],
        career: json["career"] == null
            ? null
            : DegreesResponseModel.fromJson(json["career"]),
        role: json["role"] == null
            ? null
            : DegreesResponseModel.fromJson(json["role"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "role_id": roleId,
        "description": description,
        "career_id": careerId,
        "career": career?.toJson(),
        "role": role?.toJson(),
      };
}
