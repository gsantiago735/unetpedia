import 'package:unetpedia/models/generic/pages_model.dart';
import 'package:unetpedia/models/subject/categories_response_model.dart';

class SubjectsResponseModel {
  final List<SubjectResponseModel>? data;
  final int? count;
  final PagesModel? pages;

  SubjectsResponseModel({
    this.data,
    this.count,
    this.pages,
  });

  SubjectsResponseModel copyWith({
    List<SubjectResponseModel>? data,
    int? count,
    PagesModel? pages,
  }) =>
      SubjectsResponseModel(
        data: data ?? this.data,
        count: count ?? this.count,
        pages: pages ?? this.pages,
      );

  factory SubjectsResponseModel.fromJson(Map<String, dynamic> json) =>
      SubjectsResponseModel(
        pages:
            json["pages"] == null ? null : PagesModel.fromJson(json["pages"]),
        count: json["count"],
        data: (json["data"] == null)
            ? []
            : List<SubjectResponseModel>.from(
                json["data"]!.map((x) => SubjectResponseModel.fromJson(x))),
      );
}

class SubjectResponseModel {
  final String? name;
  final int? id;
  final CategoryResponseModel? category;

  SubjectResponseModel({
    this.name,
    this.id,
    this.category,
  });

  factory SubjectResponseModel.fromJson(Map<String, dynamic> json) =>
      SubjectResponseModel(
        name: json["name"],
        id: json["id"],
        category: json["Category"] == null
            ? null
            : CategoryResponseModel.fromJson(json["Category"]),
      );
}
