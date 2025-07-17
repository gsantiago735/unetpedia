class RegisterRequestModel {
  final String name;
  final String lastName;
  final String email;
  final String? photoUrl;
  final String role;
  final String description;
  final String? careerId;

  final String password;

  RegisterRequestModel({
    required this.name,
    required this.lastName,
    required this.email,
    this.photoUrl,
    required this.role,
    required this.description,
    this.careerId,
    required this.password,
  });

  RegisterRequestModel copyWith({
    String? name,
    String? lastName,
    String? email,
    String? photoUrl,
    String? role,
    String? description,
    String? careerId,
    String? password,
  }) => RegisterRequestModel(
    name: name ?? this.name,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    photoUrl: photoUrl ?? this.photoUrl,
    role: role ?? this.role,
    description: description ?? this.description,
    careerId: careerId ?? this.careerId,
    password: password ?? this.password,
  );
}
