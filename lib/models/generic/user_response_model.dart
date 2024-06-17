import 'package:unetpedia/models/generic/degrees_response_model.dart';

class UserResponseModel {
  final int? id;
  final String? name;
  final String? email;
  final int? roleId;
  final String? description;
  final int? careerId;
  final DegreesResponseModel? career;
  final DegreesResponseModel? role;

  UserResponseModel({
    this.id,
    this.name,
    this.email,
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
        email: json["email"],
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
        "email": email,
        "role_id": roleId,
        "description": description,
        "career_id": careerId,
        "career": career?.toJson(),
        "role": role?.toJson(),
      };
}
