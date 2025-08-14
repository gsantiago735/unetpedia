import 'package:cloud_firestore/cloud_firestore.dart';

class MentorshipRequestModel {
  final String ownerName;
  final String ownerUrl;
  final String description;
  final String phone;
  final double price;
  final String? subjectName;
  final DocumentReference? subject;
  final DocumentReference? department;
  final DocumentReference? owner;

  MentorshipRequestModel({
    required this.ownerName,
    required this.ownerUrl,
    required this.description,
    required this.phone,
    required this.price,
    required this.subjectName,
    this.subject,
    this.department,
    this.owner,
  });

  MentorshipRequestModel copyWith({
    String? ownerName,
    String? ownerUrl,
    String? description,
    String? phone,
    double? price,
    String? subjectName,
    DocumentReference? subject,
    DocumentReference? department,
    DocumentReference? owner,
  }) => MentorshipRequestModel(
    ownerName: ownerName ?? this.ownerName,
    ownerUrl: ownerUrl ?? this.ownerUrl,
    description: description ?? this.description,
    phone: phone ?? this.phone,
    price: price ?? this.price,
    subjectName: subjectName ?? this.subjectName,
    subject: subject ?? this.subject,
    department: department ?? this.department,
    owner: owner ?? this.owner,
  );

  Map<String, dynamic> toJsonCreate({required String id}) => {
    "id": id,
    "owner_name": ownerName,
    "owner_url": ownerUrl,
    'description': description,
    "phone": phone,
    "price": price,
    "subject_name": subjectName,
    'subject': subject,
    'department': department,
    'owner': owner,
    'created_at': DateTime.now(),
  };

  Map<String, dynamic> toJsonUpdate() => {
    "owner_name": ownerName,
    "owner_url": ownerUrl,
    'description': description,
    "phone": phone,
    "price": price,
    "subject_name": subjectName,
    'updated_at': DateTime.now(),
  };
}
