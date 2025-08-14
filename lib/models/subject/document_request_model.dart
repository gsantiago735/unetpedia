import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentRequestModel {
  final String name;
  final String description;
  final String url;
  final String extension;
  final int size;
  final DocumentReference? subject;
  final DocumentReference? department;
  final DocumentReference? owner;

  DocumentRequestModel({
    required this.name,
    required this.description,
    required this.url,
    required this.extension,
    required this.size,
    this.subject,
    this.department,
    this.owner,
  });

  DocumentRequestModel copyWith({
    String? name,
    String? description,
    String? url,
    String? extension,
    int? size,
    DocumentReference? subject,
    DocumentReference? department,
    DocumentReference? owner,
  }) => DocumentRequestModel(
    name: name ?? this.name,
    description: description ?? this.description,
    url: url ?? this.url,
    size: size ?? this.size,
    extension: extension ?? this.extension,
    subject: subject ?? this.subject,
    department: department ?? this.department,
    owner: owner ?? this.owner,
  );

  Map<String, dynamic> toJsonCreate({required String id}) => {
    "id": id,
    'name': name,
    "description": description,
    'url': url,
    "size_in_bytes": size,
    "extension": extension,
    'subject': subject,
    'department': department,
    'owner': owner,
    'created_at': DateTime.now(),
  };

  Map<String, dynamic> toJsonUpdate() => {
    'description': description,
    'updated_at': DateTime.now(),
  };
}
