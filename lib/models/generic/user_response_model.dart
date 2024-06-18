import 'package:unetpedia/models/generic/degrees_response_model.dart';

class UserResponseModel {
  final int? id;
  final String? name;
  final String? lastName;
  final String? email;
  final String? photo;
  final int? roleId;
  final String? description;
  final int? careerId;
  final DegreesResponseModel? career;
  final DegreesResponseModel? role;

  UserResponseModel({
    this.id,
    this.name,
    this.lastName,
    this.email,
    this.photo,
    this.roleId,
    this.description,
    this.careerId,
    this.career,
    this.role,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      UserResponseModel(
        id: json["id"],
        name: json["name"],
        lastName: json["lastName"],
        email: json["email"],
        photo: json["photo"],
        roleId: json["role_id"],
        description: json["description"],
        careerId: json["career_id"],
        career: (json["career"] == null)
            ? null
            : DegreesResponseModel.fromJson(json["career"]),
        role: (json["role"] == null)
            ? null
            : DegreesResponseModel.fromJson(json["role"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastName": lastName,
        "email": email,
        "photo": photo,
        "role_id": roleId,
        "description": description,
        "career_id": careerId,
        "career": career?.toJson(),
        "role": role?.toJson(),
      };

  String? get fullName {
    if (name != null && lastName != null) {
      return "$name $lastName";
    } else {
      return null;
    }
  }
}
