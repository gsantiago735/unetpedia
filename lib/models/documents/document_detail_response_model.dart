import 'package:unetpedia/models/documents/create_document_response_model.dart';

class DetailDocumentResponseModel {
  final DocumentDetail? data;

  DetailDocumentResponseModel({this.data});

  factory DetailDocumentResponseModel.fromJson(Map<String, dynamic> json) =>
      DetailDocumentResponseModel(
        data:
            json["data"] == null ? null : DocumentDetail.fromJson(json["data"]),
      );
}

class DocumentDetail {
  final int? id;
  final String? name;
  final String? path;
  final int? categoryId;
  final int? subjectId;
  final int? createdBy;
  final Category? category;
  final Category? subject;
  final String? url;

  DocumentDetail({
    this.id,
    this.name,
    this.path,
    this.categoryId,
    this.subjectId,
    this.createdBy,
    this.category,
    this.subject,
    this.url,
  });

  factory DocumentDetail.fromJson(Map<String, dynamic> json) => DocumentDetail(
        id: json["id"],
        name: json["name"],
        path: json["path"],
        categoryId: json["category_id"],
        subjectId: json["subject_id"],
        createdBy: json["created_by"],
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        subject:
            json["subject"] == null ? null : Category.fromJson(json["subject"]),
        url: json["url"],
      );
}
