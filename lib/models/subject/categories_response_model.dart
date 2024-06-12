class CategoriesResponseModel {
  final List<CategoryResponseModel>? data;
  final int? count;
  final Pages? pages;

  CategoriesResponseModel({
    this.data,
    this.count,
    this.pages,
  });

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) =>
      CategoriesResponseModel(
        data: json["data"] == null
            ? []
            : List<CategoryResponseModel>.from(
                json["data"]!.map((x) => CategoryResponseModel.fromJson(x))),
        count: json["count"],
        pages: json["pages"] == null ? null : Pages.fromJson(json["pages"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "count": count,
        "pages": pages?.toJson(),
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

class Pages {
  final dynamic next;
  final dynamic previous;

  Pages({
    this.next,
    this.previous,
  });

  factory Pages.fromJson(Map<String, dynamic> json) => Pages(
        next: json["next"],
        previous: json["previous"],
      );

  Map<String, dynamic> toJson() => {
        "next": next,
        "previous": previous,
      };
}
