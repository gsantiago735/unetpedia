class CreateDocumentResponseModel {
  final String? presignedUrl;
  final String? key;
  final DocumentModel? doc;

  CreateDocumentResponseModel({
    this.presignedUrl,
    this.key,
    this.doc,
  });

  factory CreateDocumentResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateDocumentResponseModel(
        presignedUrl: json["presignedURL"],
        key: json["key"],
        doc: json["doc"] == null ? null : DocumentModel.fromJson(json["doc"]),
      );
}

class DocumentModel {
  final int? id;
  final int? categoryId;
  final int? subjectId;
  final String? name;
  final Category? subject;
  final Category? category;

  DocumentModel({
    this.id,
    this.categoryId,
    this.subjectId,
    this.name,
    this.subject,
    this.category,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) => DocumentModel(
        id: json["id"],
        categoryId: json["category_id"],
        subjectId: json["subject_id"],
        name: json["name"],
        subject:
            json["subject"] == null ? null : Category.fromJson(json["subject"]),
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
      );
}

class Category {
  final int? id;
  final String? name;

  Category({this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
      );
}
