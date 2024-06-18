class CategoriesResponseModel {
  final int? count;
  final List<CategoryResponseModel>? data;

  CategoriesResponseModel({this.count, this.data});

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) =>
      CategoriesResponseModel(
        count: json["count"],
        data: (json["data"] == null)
            ? []
            : List<CategoryResponseModel>.from(
                json["data"]!.map((x) => CategoryResponseModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CategoryResponseModel {
  final String? name;
  final int? id;
  final Count? count;

  CategoryResponseModel({
    this.name,
    this.id,
    this.count,
  });

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) =>
      CategoryResponseModel(
        name: json["name"],
        id: json["id"],
        count: json["_count"] == null ? null : Count.fromJson(json["_count"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "_count": count?.toJson(),
      };
}

class Count {
  final int? subject;

  Count({this.subject});

  factory Count.fromJson(Map<String, dynamic> json) => Count(
        subject: json["Subject"],
      );

  Map<String, dynamic> toJson() => {
        "Subject": subject,
      };
}
