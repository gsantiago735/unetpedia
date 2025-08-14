import 'package:cloud_firestore/cloud_firestore.dart';

class MentorshipModel {
  final String? id;
  final String? ownerName;
  final String? ownerUrl;
  final String? subjectName;
  final String? description;
  final String? phone;
  final double? price;
  final DocumentReference? subject;
  final DocumentReference? department;
  final DocumentReference? owner;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MentorshipModel({
    this.id,
    this.ownerName,
    this.ownerUrl,
    this.subjectName,
    this.description,
    this.phone,
    this.price,
    this.subject,
    this.department,
    this.owner,
    this.createdAt,
    this.updatedAt,
  });

  String get getPrice {
    return "\$${price?.toStringAsFixed(2)}";
  }

  factory MentorshipModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MentorshipModel(
      id: doc.id,
      ownerName: data["owner_name"],
      ownerUrl: data["owner_url"],
      subjectName: data["subject_name"],
      description: data["description"],
      phone: data["phone"],
      price: data["price"],
      subject: data["subject"],
      department: data["department"],
      owner: data["owner"],
      createdAt: (data['created_at'] as Timestamp?)?.toDate(),
      updatedAt: (data['updated_at'] as Timestamp?)?.toDate(),
    );
  }
}
