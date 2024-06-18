class RegisterRequestModel {
  final String name;
  final String lastName;
  final String email;
  final String password;
  final int role;
  final String description;
  final int career;
  final String profilePhotoName;

  RegisterRequestModel({
    required this.name,
    required this.lastName,
    required this.email,
    required this.password,
    required this.role,
    required this.description,
    required this.career,
    required this.profilePhotoName,
  });

  RegisterRequestModel copyWith({
    String? name,
    String? lastName,
    String? email,
    String? password,
    int? role,
    String? description,
    int? career,
    String? profilePhotoName,
  }) =>
      RegisterRequestModel(
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        password: password ?? this.password,
        role: role ?? this.role,
        description: description ?? this.description,
        career: career ?? this.career,
        profilePhotoName: profilePhotoName ?? this.profilePhotoName,
      );

  // factory RegisterRequestModel.fromJson(Map<String, dynamic> json) => RegisterRequestModel(
  //     name: json["name"],
  //     email: json["email"],
  //     password: json["password"],
  //     role: json["role"],
  //     description: json["description"],
  //     career: json["career"],
  // );

  Map<String, dynamic> toJson() => {
        "name": name,
        "lastname": lastName,
        "email": email,
        "password": password,
        "role": role,
        "description": description,
        "career": career,
        "profilePhoto": profilePhotoName,
      };
}
