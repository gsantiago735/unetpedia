class UserResponseModel {
  final String? uid;
  final String? name;
  final String? lastName;
  final String? email;
  final String? photoUrl;
  final String? role;
  final String? description;
  final String? careerId;
  final DateTime? registerDate;
  final DateTime? lastSignIn;

  final String? password;

  UserResponseModel({
    this.uid,
    this.name,
    this.lastName,
    this.email,
    this.photoUrl,
    this.role,
    this.description,
    this.careerId,
    this.registerDate,
    this.lastSignIn,
    this.password,
  });

  String get fullName => "$name $lastName";

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      UserResponseModel(
        uid: json['uid'],
        name: json['name'],
        lastName: json['lastName'],
        email: json['email'],
        photoUrl: json['photoUrl'],
        role: json['role'],
        description: json['description'],
        careerId: json['careerId'],
        registerDate: json['registerDate'],
        lastSignIn: json['lastSignIn'],
      );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
    "lastName": lastName,
    "email": email,
    "photoUrl": photoUrl,
    "role": role,
    "description": description,
    "careerId": careerId,
    "registerDate": registerDate,
    "lastSignIn": lastSignIn,
  };
}
