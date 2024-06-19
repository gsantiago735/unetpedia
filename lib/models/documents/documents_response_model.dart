import 'package:unetpedia/models/generic/pages_model.dart';

class DocumentsResponseModel {
  final List<DocumentResponseModel>? data;
  final int? count;
  final PagesModel? pages;

  DocumentsResponseModel({
    this.data,
    this.count,
    this.pages,
  });

  DocumentsResponseModel copyWith({
    List<DocumentResponseModel>? data,
    int? count,
    PagesModel? pages,
  }) =>
      DocumentsResponseModel(
        data: data ?? this.data,
        count: count ?? this.count,
        pages: pages ?? this.pages,
      );

  factory DocumentsResponseModel.fromJson(Map<String, dynamic> json) =>
      DocumentsResponseModel(
        data: json["data"] == null
            ? []
            : List<DocumentResponseModel>.from(
                json["data"]!.map((x) => DocumentResponseModel.fromJson(x))),
        count: json["count"],
        pages:
            json["pages"] == null ? null : PagesModel.fromJson(json["pages"]),
      );
}

class DocumentResponseModel {
  final int? categoryId;
  final int? id;
  final String? name;
  final int? subjectId;

  DocumentResponseModel({
    this.categoryId,
    this.id,
    this.name,
    this.subjectId,
  });

  factory DocumentResponseModel.fromJson(Map<String, dynamic> json) =>
      DocumentResponseModel(
        categoryId: json["category_id"],
        id: json["id"],
        name: json["name"],
        subjectId: json["subject_id"],
      );
}
